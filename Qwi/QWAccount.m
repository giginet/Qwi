//
// Created by giginet on 2013/5/12.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QWAccount.h"


@implementation QWAccount
@synthesize acAccount;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)isOwnAccount {
    return YES;
}

@end