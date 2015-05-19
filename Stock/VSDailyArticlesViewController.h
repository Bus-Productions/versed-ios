//
//  VSDailyArticlesViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/18/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSDailyArticlesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *articles; 
@property (strong, nonatomic) NSMutableArray *sections;

@end
