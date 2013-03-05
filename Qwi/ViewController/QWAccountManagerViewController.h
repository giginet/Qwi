//
//  QWAccountManagerViewController.h
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface QWAccountManagerViewController : UITableViewController {
  ACAccountStore* _accountStore;
  NSMutableArray* _accounts;
}

@end
