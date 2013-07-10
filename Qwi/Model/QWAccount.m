//
//  QWAccount.m
//  Qwi
//
//  Created by giginet on 3/6/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "QWAccount.h"

@implementation QWAccount

- (id)initWithUser:(QWUser *)user account:(ACAccount *)account {
    self = [super init];
    if (self) {
        self.user = user;
        self.account = account;
    }
    return self;
}

@end
