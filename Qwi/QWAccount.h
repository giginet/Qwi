//
// Created by giginet on 2013/5/12.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import "QWUser.h"


@interface QWAccount : QWUser

@property (readwrite, nonatomic) ACAccount *acAccount;

@end