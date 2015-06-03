//
//  VSPollResultsViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSPollResultsViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *poll;
@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
