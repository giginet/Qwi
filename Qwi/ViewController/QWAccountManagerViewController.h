//
//  QWAccountManagerViewController.h
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QWAccountManagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
}

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;

@property(readonly, nonatomic) IBOutlet UITableView *tableView;

@end
