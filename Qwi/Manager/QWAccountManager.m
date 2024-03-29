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

const NSString *kLastAccountKey = @"lastAccount";

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
                if (cache == nil) { // 保存されていないとき
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
                } else { // 保存されているとき
                    QWAccount *account = [[QWAccount alloc] initWithUser:cache account:acAccount];
                    if (![_accounts containsObject:account]) {
                        NSLog(@"load account %@", account.user.screenName);
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
            }
        }
    }];
}

- (BOOL)containsUser:(QWUser *)user {
    for (QWAccount *account in self.accounts) {
        if ([account.user.screenName isEqual:user.screenName]) {
            return YES;
        }
    }
    return NO;
}

- (void)restoreLastAccount:(void (^)(QWAccount *account, BOOL succeed))completion {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *lastAccount = [ud objectForKey:kLastAccountKey];
    if (lastAccount) {
        ACAccountType *type = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [_accountStore requestAccessToAccountsWithType:type options:nil completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *accounts = [NSMutableArray arrayWithArray:[_accountStore accountsWithAccountType:type]];
                for (ACAccount *acAccount in accounts) {
                    if ([acAccount.username isEqual:lastAccount]) {
                        QWUser *user = [[QWUserManager sharedManager] selectUserByName:lastAccount];
                        if (user) {
                            NSLog(@"restore account %@", lastAccount);
                            QWAccount *account = [[QWAccount alloc] initWithUser:user account:acAccount];
                            self.currentAccount = account;
                            completion(account, YES);
                        } else {
                            [ud setObject:@"" forKey:kLastAccountKey];
                            completion(nil, NO);
                        }
                        break;
                    }
                }
            }
        }];
    }
}

- (void)setCurrentAccount:(QWAccount *)currentAccount {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (currentAccount) {
        [ud setObject:currentAccount.user.screenName forKey:kLastAccountKey];
    } else {
        [ud setObject:@"" forKey:kLastAccountKey];
    }
    _currentAccount = currentAccount;
}

@end