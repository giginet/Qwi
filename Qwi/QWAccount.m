//
// Created by giginet on 2013/5/12.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QWAccount.h"


@implementation QWAccount
@synthesize acAccount;

- (id)initWithUser:(QWUser *)user account:(ACAccount *)account {
    self = [super init];
    if (self) {
        self.user = user;
        self.acAccount = account;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[QWAccount class]]) {
        QWAccount *other = (QWAccount *)object;
        return [other.acAccount.username isEqualToString:self.acAccount.username];
    }
    return NO;
}

@end