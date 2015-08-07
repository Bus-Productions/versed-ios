//
//  VSSidebarViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSMyTracksViewController.h"
#import "VSQuizQuestionViewController.h"
#import "VSAllTracksViewController.h"
#import "SWRevealViewController.h"
#import "VSDailyArticlesViewController.h"
#import "VSQuizLandingViewController.h"
#import "VSProfileViewController.h"
#import "VSProfileTableViewCell.h"


@interface VSSidebarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *menuOptions;
@property (strong, nonatomic) NSMutableArray *bottomOptions;
@property (strong, nonatomic) NSMutableArray *menuIdentifiers;
@property (strong, nonatomic) NSMutableArray *sections; 

@end
