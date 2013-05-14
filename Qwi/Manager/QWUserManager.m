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

@implementation QWUserManager

const NSURL *kBaseURL = @"http://api.twitter.com/1.1/";
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
    }
    return self;
}

- (NSURL *)buildURL:(NSString *)endPoint {
    return [NSURL URLWithString:endPoint relativeToURL:[NSURL URLWithString:kBaseURL]];
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
    [showRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if ([account.username isEqual:screenName]) {
            QWAccount *user = [NSEntityDescription insertNewObjectForEntityForName:@"QWUser"
                                                         inManagedObjectContext:self.managedObjectContext];
            [self updateFromJSON:jsonString for:user];
            [_users setObject:user forKey:screenName];
            if (onSucceed) {
                onSucceed(user, urlResponse, error);
            }
        } else {
            QWUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"QWUser"
                                                         inManagedObjectContext:self.managedObjectContext];
            [self updateFromJSON:jsonString for:user];
            [_users setObject:user forKey:screenName];
            if (onSucceed) {
                onSucceed(user, urlResponse, error);
            }
        }
    }];
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
        [self.managedObjectContext deleteObject:user];
        return YES;
    }
    return NO;
}

- (QWUser *)selectUserByName:(NSString *)name {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([QWUser class])];
    request.predicate = [NSPredicate predicateWithFormat:@"screenName = %@", name];

    NSArray *cache = [self.managedObjectContext executeFetchRequest:request error:nil];
    if ([cache count] > 0) {
        return [cache lastObject];
    }
    return nil;
}

- (BOOL)isCachedByName:(NSString *)name {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([QWUser class])];
    request.predicate = [NSPredicate predicateWithFormat:@"screenName = %@", name];
    return [self.managedObjectContext countForFetchRequest:request error:nil] > 0;
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

- (void)updateFriends:(ACAccount *)account {
    [self updateFriends:account count:1000];
}

- (void)updateFriends:(ACAccount *)account count:(int)count {
    NSLog(@"fetch friends of %@ limit %d", account.username, count);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"screen_name" : account.username,
            @"count" : [NSString stringWithFormat:@"%d", count]}];
    SLRequest *listRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:[self buildURL:kFriendsIdsAPI]
                                                   parameters:params];
    listRequest.account = account;
    [listRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        NSError *err;
        NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:responseData error:&err];
        if (!err) {
            NSArray *ids = dictionary[@"ids"];
            int count = [ids count];
            NSLog(@"count = %d", count);
            const int kIDLimit = 100;
            for (int i = 0; i < count; i += kIDLimit) {
                [self updateFriendsWithIDs:account
                                       ids:[ids subarrayWithRange:NSMakeRange(i, MIN(kIDLimit, count - i))]];
            }
            [self.managedObjectContext save:nil];
        }
    }];
}

- (void)updateFriendsWithIDs:(ACAccount *)account ids:(NSArray *)ids {
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
                                                                                                    QWUser *user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([QWUser class])
                                                                                                                                                 inManagedObjectContext:self.managedObjectContext];
                                                                                                    [self updateFromDictionary:userInfo for:user];
                                                                                                    NSLog(@"create %@", screenName);
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

                                                                                        }];
    [[NSOperationQueue new] addOperation:operation];
}

@end
