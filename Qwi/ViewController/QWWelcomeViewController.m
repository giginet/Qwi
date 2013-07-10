//
//  QWWelcomeViewController.m
//  Qwi
//
//  Created by giginet on 05/16/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "QWWelcomeViewController.h"
#import "QWAccountManager.h"

@interface QWWelcomeViewController ()

@end

@implementation QWWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.startButton.enabled = NO;
    QWAccountManager *manager = [QWAccountManager sharedManager];
    if (!manager.currentAccount) {
        [manager restoreLastAccount:^(QWAccount *account, BOOL succeed) {
            if (succeed) {
                self.startButton.enabled = YES;
            }
        }];
    } else {
        self.startButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
