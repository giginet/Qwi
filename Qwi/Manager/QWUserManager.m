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
#import "NSManagedObject+MagicalFinders.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"

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
                QWUser *user = [self insertNewUser];
                [user updateFromJSON:JSON];
                NSLog(@"create %@", user.screenName);
                [_users setObject:user forKey:screenName];
                NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
                [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    if (onSucceed) {
                        onSucceed(user, request, nil);
                    }
                }];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

            }];
    [self.queue addOperation:operation];
}

- (QWUser *)updateUserByName:(NSString *)screenName
                         via:(ACAccount *)account
                     succeed:(void (^)(QWUser *, NSHTTPURLResponse *, NSError *))onSucceed {
    QWUser *user = [self selectUserByName:screenName];
    if (user) {
        SLRequest *showRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:[self buildURL:kFriendListAPI]
                                                   parameters:@{@"screen_name" : screenName}];
        showRequest.account = account;
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[showRequest preparedURLRequest]
                                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                [user updateFromJSON:JSON];
                                                                                                onSucceed(user, response, nil);
                                                                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    onSucceed(user, response, error);
                }];
        [self.queue addOperation:operation];
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
    NSArray *cache = [QWUser MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"screenName = %@", name]];
    if ([cache count] > 0) {
        return [cache lastObject];
    }
    return nil;
}

- (BOOL)isCachedByName:(NSString *)name {
    return [QWUser MR_countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"screenName = %@", name]];
}

- (void)fetchFriends:(NSString *)screenName via:(ACAccount *)account completion:(void (^)(QWUser *user, NSSet *friends, BOOL success))completion {
    [self fetchFriends:screenName via:account count:1000 completion:completion];
}

- (void)fetchFriends:(NSString *)screenName via:(ACAccount *)account count:(int)count completion:(void (^)(QWUser *user, NSSet *friends, BOOL success))completion {
    NSLog(@"fetch friends of %@ limit %d", account.username, count);
    QWUser *user = [[QWUserManager sharedManager] selectUserByName:screenName];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"screen_name" : screenName,
            @"count" : [NSString stringWithFormat:@"%d", count]}];
    SLRequest *listRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:[self buildURL:kFriendsIdsAPI]
                                                   parameters:params];
    listRequest.account = account;
    AFJSONRequestOperation *operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[listRequest preparedURLRequest]
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSArray *ids = JSON[@"ids"];
                int count = [ids count];
                NSLog(@"friend count = %d", count);
                __block int i = 0;
                __block NSMutableSet *set = [NSMutableSet set];
                void (^block)(NSSet *friends, BOOL success) = ^(NSSet *friends, BOOL success) {
                    NSLog(@"fetchFriend from %d", i);
                    if (friends) {
                        [set setByAddingObjectsFromSet:friends];
                    }
                    if (i < count) {
                        [self createUsersWithIDs:[ids subarrayWithRange:NSMakeRange(i, MIN(kIDLimit, count - i))] via:account completion:block];
                    } else {
                        completion(user, set, YES);
                    }
                    i += kIDLimit;
                };
                block(nil, NO);
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                completion(user, nil, NO);
            }];
    [self.queue addOperation:operation];
}

- (void)createUsersWithIDs:(NSArray *)ids via:(ACAccount *)account completion:(void (^)(NSSet *friends, BOOL success))completion {
    NSString *users = [ids componentsJoinedByString:@","];
    NSDictionary *params = @{@"user_id" : users};
    SLRequest *lookupRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                   requestMethod:SLRequestMethodGET
                                                             URL:[self buildURL:kUserLookupAPI]
                                                      parameters:params];
    lookupRequest.account = account;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[lookupRequest preparedURLRequest]
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSMutableSet *friends = [NSMutableSet set];
                for (NSDictionary *userInfo in JSON) {
                    NSString *screenName = userInfo[@"screen_name"];
                    if ([self isCachedByName:screenName]) {
                        // 保存済みの時
                        QWUser *user = [self selectUserByName:screenName];
                        [user updateFromJSON:userInfo];
                        [friends addObject:user];
                        NSLog(@"update %@", screenName);
                    } else {
                        // 保存されていなかったとき。新規生成してあげるよ！
                        QWUser *user = [self insertNewUser];
                        [user updateFromJSON:userInfo];
                        [friends addObject:user];
                        NSLog(@"create %@", screenName);
                    }
                }
                completion(friends, YES);
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                // ToDo 上手くいかなかったとき。スルー
                completion(nil, NO);
            }];
    [self.queue addOperation:operation];
}

#pragma mark private

- (NSURL *)buildURL:(NSString *)endPoint {
    return [NSURL URLWithString:endPoint relativeToURL:[NSURL URLWithString:kBaseURL]];
}

- (QWUser *)insertNewUser {
    return [QWUser MR_createEntity];
}

@end
