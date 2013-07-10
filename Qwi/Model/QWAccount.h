//
//  QWAccount.h
//  Qwi
//
//  Created by giginet on 3/6/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "QWUser.h"
#import <Accounts/Accounts.h>

@interface QWAccount : NSObject {
}

@property (readwrite) ACAccount* account;
@property (readwrite) QWUser *user;

- (id)initWithUser:(QWUser *)user account:(ACAccount *)account;

@end
