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

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

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
- (void)updateFriends:(ACAccount *)account;
- (void)updateFriends:(ACAccount *)account cursor:(NSString *)cursor;

@end
