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
  NSMutableDictionary* _users;
}

+ (id)sharedManager;
- (void)createUserWithScreenName:(NSString*)screenName via:(ACAccount*)account;
- (QWUser*)userWithScreenName:(NSString*)screenName;

@end
