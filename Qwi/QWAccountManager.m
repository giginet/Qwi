//
// Created by giginet on 2013/5/12.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QWAccountManager.h"
#import "QWUserManager.h"
#import "MagicalRecord+Setup.h"
#import "MagicalRecordShorthand.h"
#import "NSManagedObjectContext+MagicalRecord.h"

#define MR_SHORTHAND

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
        [MagicalRecord setupCoreDataStackWithStoreNamed:@"Qwi.sqlite"];
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
            for (ACAccount *acAccount in accounts) {
                QWUser *cache = [manager selectUserByName:acAccount.username];
                if (cache == NULL) {
                    [manager createUserWithScreenName:acAccount.username via:acAccount succeed:^(QWUser *user, NSHTTPURLResponse *response, NSError *err) {
                        QWAccount *account = [[QWAccount alloc] initWithUser:user account:acAccount];
                        [_accounts addObject:account];
                        NSError *saveErr;
                        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
                        [context save:&saveErr];
                        if (manager.queue.operationCount == 0) {
                            completion(granted, error);
                        }
                    }];
                } else {
                    QWAccount *account = [[QWAccount alloc] initWithUser:cache account:acAccount];
                    if (![_accounts containsObject:account]) {
                        [_accounts addObject:account];
                    }
                }
            }
            if (manager.queue.operationCount == 0) {
                completion(granted, error);
            }
        }
    }];
}

- (void)updateAccounts:(void (^)(QWUser *, NSHTTPURLResponse *, NSError *))onSucceed {
    ACAccountType *type = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [_accountStore requestAccessToAccountsWithType:type options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [NSMutableArray arrayWithArray:[_accountStore accountsWithAccountType:type]];
            QWUserManager *manager = [QWUserManager sharedManager];
            for (ACAccount *acAccount in accounts) {
                QWUser *cache = [manager selectUserByName:acAccount.username];
                [manager updateUserByName:cache.screenName
                                      via:acAccount
                                  succeed:onSucceed];
                [manager updateFriends:cache.screenName via:acAccount];
            }
        }
    }];
}

@end