//
//  VSProfileViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

- (IBAction)updateSettingsAction:(id)sender;

@end
