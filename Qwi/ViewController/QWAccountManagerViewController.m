//
//  QWAccountManagerViewController.m
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "QWAccountManagerViewController.h"
#import "QWAccountManager.h"
#import "QWUserManager.h"

@interface QWAccountManagerViewController ()

@end

@implementation QWAccountManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:indicator];
    [indicator startAnimating];

    QWAccountManager *manager = [QWAccountManager sharedManager];
    [manager loadAccounts:^(BOOL granted, NSError *error) {
        [indicator stopAnimating];
        QWUserManager *userManager = [QWUserManager sharedManager];
        [userManager save:^(BOOL success, NSError *error) {
            [self.tableView reloadData];
        }];
    }];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[QWAccountManager sharedManager] accounts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AccountCell";
    NSArray *accounts = [[QWAccountManager sharedManager] accounts];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    QWAccount *account = accounts[indexPath.row];
    QWUser *user = account.user;
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.screenName;
    cell.imageView.image = [UIImage imageWithData:user.profileImage];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    QWAccountManager *manager = [QWAccountManager sharedManager];
    QWAccount *account = manager.accounts[row];
    manager.currentAccount = account;
    if (account) {
        [[QWUserManager sharedManager] fetchFriends:account.user.screenName via:account.account completion:^(QWUser *user, NSSet *friends, BOOL success) {
            NSLog(@"fetch friend complete");
            QWUserManager *userManager = [QWUserManager sharedManager];
            [userManager save:^(BOOL success, NSError *error) {

            }];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)refreshButtonPressed:(id)sender {
    [[QWAccountManager sharedManager] updateAccounts:^(QWUser *user, NSHTTPURLResponse *urlResponse, NSError *error) {
        [self.tableView reloadData];
    }];
}
@end
