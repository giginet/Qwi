//
//  QWUserManager.h
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import "QWUser.h"

@interface QWUserManager : NSObject {
    NSMutableDictionary *_users;
}

@property (readwrite, nonatomic) NSOperationQueue *queue;

+ (id)sharedManager;

- (void)createUserWithScreenName:(NSString *)screenName
                             via:(ACAccount *)account
                         succeed:(void (^)(QWUser *user, NSHTTPURLResponse *urlResponse, NSError *error))onSucceed;
- (QWUser *)updateUserByName:(NSString *)screenName
                         via:(ACAccount *)account
                     succeed:(void (^)(QWUser *user, NSHTTPURLResponse *urlResponse, NSError *error))onSucceed;
- (QWUser *)selectUserByName:(NSString *)screenName;
- (BOOL)deleteUserByName:(NSString *)screenName;
- (BOOL)isCachedByName:(NSString *)screenName;
- (void)fetchFriends:(NSString *)screenName
                 via:(ACAccount *)account
          completion:(void (^)(QWUser *user, NSSet *friends, BOOL success))completion;
- (void)fetchFriends:(NSString *)screenName
                 via:(ACAccount *)account
               count:(int)count
          completion:(void (^)(QWUser *user, NSSet *friends, BOOL success))completion;
- (void)createUsersWithIDs:(NSArray *)ids
                       via:(ACAccount *)account
                completion:(void (^)(NSSet *friends, BOOL success))completion;
- (void)save:(void (^)(BOOL success, NSError *error))succeed;

@end
