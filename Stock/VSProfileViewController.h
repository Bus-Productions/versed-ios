//
//  VSProfileViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface VSProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWRevealViewControllerDelegate>
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

- (IBAction)logoutAction:(id)sender;
- (IBAction)updateSettingsAction:(id)sender;

@end
