//
//  VSDailyArticlesViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/18/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface VSDailyArticlesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWRevealViewControllerDelegate>
{
    BOOL firstTime;
    NSMutableArray *completedResources; 
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *articles; 
@property (strong, nonatomic) NSMutableArray *sections;

@end
