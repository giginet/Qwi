//
//  QWAccountManagerViewController.h
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface QWAccountManagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    ACAccountStore *_accountStore;
    NSMutableArray *_accounts;
}

- (IBAction)doneButtonPressed:(id)sender;

@property(readonly, nonatomic) IBOutlet UITableView *tableView;

@end
