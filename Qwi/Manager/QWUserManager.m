//
//  QWUserManager.m
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "QWUserManager.h"
#import "AFNetworking.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>

#include "CJSONDeserializer.h"

#import "QWAccount.h"
#import "NSManagedObject+MagicalRecord.h"
#import "MagicalRecordShorthand.h"
#import "NSManagedObject+MagicalAggregation.h"

#define MR_SHORTHAND

@implementation QWUserManager

const int kIDLimit = 100;
const NSString *kBaseURL = @"http://api.twitter.com/1.1/";
const NSString *kUserShowAPI = @"users/show.json";
const NSString *kFriendListAPI = @"friends/list.json";
const NSString *kUserLookupAPI = @"users/lookup.json";
const NSString *kFriendsIdsAPI = @"friends/ids.json";

+ (id)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _users = [NSMutableDictionary dictionary];
        _queue = [NSOperationQueue new];
    }
    return self;
}

- (void)createUserWithScreenName:(NSString *)screenName
                             via:(ACAccount *)account
                         succeed:(void (^)(QWUser *, NSHTTPURLResponse *, NSError *))onSucceed {
    /*
     iOS6ではTWRequestではなく、SLRequestを利用するのが良いらしい
     5は切り捨てる方針で
     // http://stackoverflow.com/questions/13330596/twrequest-is-deprecated-in-ios-6-0-what-can-i-use-instead
     */
    SLRequest *showRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:[self buildURL:kUserShowAPI]
                                                   parameters:@{@"screen_name" : screenName}];
    showRequest.account = account;

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[showRequest preparedURLRequest]
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                if ([account.username isEqual:screenName]) {
                    QWUser *user = [self insertNewUser];
                    [self updateFromDictionary:JSON for:user];
                    [_users setObject:user forKey:screenName];
                    if (onSucceed) {
                        onSucceed(user, request, nil);
                    }
                } else {
                    QWUser *user = [self insertNewUser];
                    [self updateFromDictionary:JSON for:user];
                    [_users setObject:user forKey:screenName];
                    if (onSucceed) {
                        // ToDo エラーは後で！
                        onSucceed(user, request, [NSError errorWithDomain:@"" code:@"" userInfo:nil]);
                    }
                }

            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

            }];
    [self.queue addOperation:operation];
}

- (QWUser *)updateUserByName:(NSString *)screenName via:(ACAccount *)account succeed:(void (^)(QWUser *, NSHTTPURLResponse *, NSError *))onSucceed {
    QWUser *user = [self selectUserByName:screenName];
    if (user) {
        SLRequest *showRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:[self buildURL:kFriendListAPI]
                                                   parameters:@{@"screen_name" : screenName}];
        showRequest.account = account;
        [showRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            [self updateFromJSON:jsonString for:user];
            onSucceed(user, urlResponse, error);
        }];

    }
    return user;
}

- (BOOL)deleteUserByName:(NSString *)screenName {
    QWUser *user = [self selectUserByName:screenName];
    if (user) {
        [user MR_deleteEntity];
        return YES;
    }
    return NO;
}

- (QWUser *)selectUserByName:(NSString *)name {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"screenName = %@", name];

    NSArray *cache = [QWUser MR_executeFetchRequest:request];
    if ([cache count] > 0) {
        return [cache lastObject];
    }
    return nil;
}

- (BOOL)isCachedByName:(NSString *)name {
    return [QWUser MR_countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"screenName = %@", name]];
}

- (QWUser *)updateFromDictionary:(NSDictionary *)dictionary for:(QWUser *)user {
    user.name = dictionary[@"name"];
    user.screenName = dictionary[@"screen_name"];
    if (![dictionary[@"description"] isEqual:[NSNull null]]) {
        user.bio = dictionary[@"description"];
    }
    user.friendsCount = dictionary[@"friends_count"];
    user.favoritesCount = dictionary[@"favorites_count"];
    user.statusesCount = dictionary[@"statuses_count"];
    user.followersCount = dictionary[@"followers_count"];
    user.listedCount = dictionary[@"listed_count"];
    if (![dictionary[@"url"] isEqual:[NSNull null]]) {
        user.url = dictionary[@"url"];
    }
    user.profileImageURL = dictionary[@"profile_image_url"];
    if (![dictionary[@"location"] isEqual:[NSNull null]]) {
        user.location = dictionary[@"location"];
    }
    //NSURL *imageURL = [[NSURL alloc] initWithString:user.profileImageURL];
    //user.profileImage = [NSData dataWithContentsOfURL:imageURL];
    return user;
}

- (QWUser *)updateFromJSON:(NSString *)jsonString for:(QWUser *)user {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    NSLog(@"name = %@", dictionary[@"name"]);
    return [self updateFromDictionary:dictionary for:user];
}

- (void)updateFriends:(NSString *)screenName via:(ACAccount *)account {
    [self updateFriends:screenName via:account count:1000];
}

- (void)updateFriends:(NSString *)screenName via:(ACAccount *)account count:(int)count {
    NSLog(@"fetch friends of %@ limit %d", account.username, count);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"screen_name" : screenName,
            @"count" : [NSString stringWithFormat:@"%d", count]}];
    SLRequest *listRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:[self buildURL:kFriendsIdsAPI]
                                                   parameters:params];
    listRequest.account = account;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[listRequest preparedURLRequest]
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSArray *ids = JSON[@"ids"];
                int count = [ids count];
                for (int i = 0; i < count; i += kIDLimit) {
                    [self updateFriendsWithIDs:[ids subarrayWithRange:NSMakeRange(i, MIN(kIDLimit, count - i))] via:account];
                }
                //[self.managedObjectContext save:nil];
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

            }];
    [self.queue addOperation:operation];
}

- (void)updateFriendsWithIDs:(NSArray *)ids via:(ACAccount *)account {
    NSString *users = [ids componentsJoinedByString:@","];
    NSDictionary *params = @{@"user_id" : users};
    SLRequest *lookupRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                   requestMethod:SLRequestMethodGET
                                                             URL:[self buildURL:kUserLookupAPI]
                                                      parameters:params];
    lookupRequest.account = account;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[lookupRequest preparedURLRequest]
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                for (NSDictionary *userInfo in JSON) {
                    NSString *screenName = userInfo[@"screen_name"];
                    if ([self isCachedByName:screenName]) {
                        // 保存済みの時
                        QWUser *user = [self selectUserByName:screenName];
                        [self updateFromDictionary:userInfo for:user];
                        NSLog(@"update %@", screenName);
                    } else {
                        // 保存されていなかったとき。新規生成してあげるよ！
                        QWUser *user = [self insertNewUser];
                        [self updateFromDictionary:userInfo for:user];
                        NSLog(@"create %@", screenName);
                    }
                }
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                // ToDo 上手くいかなかったとき。スルー
            }];
}

#pragma mark private

- (NSURL *)buildURL:(NSString *)endPoint {
    return [NSURL URLWithString:endPoint relativeToURL:[NSURL URLWithString:kBaseURL]];
}

- (QWUser *)insertNewUser {
    return [QWUser MR_createEntity];
}

@end
