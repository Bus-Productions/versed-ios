//
//  VSTracksViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSMyTracksViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *myTracks;
@property (strong, nonatomic) NSMutableArray *sections; 
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
