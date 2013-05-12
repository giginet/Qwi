//
// Created by giginet on 2013/5/12.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QWAccountManager.h"
#import "QWUserManager.h"


@implementation QWAccountManager

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
        _accounts = [NSMutableArray array];
        _accountStore = [ACAccountStore new];
    }
    return self;
}

- (void)loadAccounts:(ACAccountStoreRequestAccessCompletionHandler)completion {
    ACAccountType *type = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [_accountStore requestAccessToAccountsWithType:type options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [NSMutableArray arrayWithArray:[_accountStore accountsWithAccountType:type]];
            QWUserManager *manager = [QWUserManager sharedManager];
            for (ACAccount *account in accounts) {
                [manager createUserWithScreenName:account.username via:account succeed:^(QWUser *user, NSHTTPURLResponse *response, NSError *err) {
                    QWAccount *account = (QWAccount *)user;
                    [_accounts addObject:account];
                    completion(granted, error);
                }];
            }
        }
    }];
}

@end