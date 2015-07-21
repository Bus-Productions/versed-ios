//
//  VSPollsViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 7/17/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface VSPollsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWRevealViewControllerDelegate>
{
    NSMutableArray *pollKeys;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *polls;
@property (strong, nonatomic) NSMutableArray *sections;

@end
