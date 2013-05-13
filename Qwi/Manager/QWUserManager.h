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

- (QWUser *)updateFromJSON:(NSString *)jsonString for:(QWUser *)user;
- (QWUser *)selectUserByName:(NSString *)name;
- (BOOL)isCachedByName:(NSString *)name;

@end
