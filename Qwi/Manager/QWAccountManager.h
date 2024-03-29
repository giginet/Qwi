//
// Created by giginet on 2013/5/12.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import "QWAccount.h"


@interface QWAccountManager : NSObject {
    ACAccountStore *_accountStore;
}

@property (readwrite, nonatomic) QWAccount *currentAccount;
@property (readonly, nonatomic) NSMutableArray *accounts;

+ (id)sharedManager;
- (void)loadAccounts:(ACAccountStoreRequestAccessCompletionHandler)completion;
- (void)updateAccounts:(void (^)(QWUser *user, NSHTTPURLResponse *urlResponse, NSError *error))onSucceed;
- (BOOL)containsUser:(QWUser *)user;
- (void)restoreLastAccount:(void (^)(QWAccount *account, BOOL succeed))completion;

@end