//
//  VSMainViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface VSAllTracksViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, SWRevealViewControllerDelegate>
{
    NSInteger selectedIndex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *categoriesWithTracks;

@property (strong, nonatomic) IBOutlet UIScrollView *horizontalMenu;
@property (strong, nonatomic) NSMutableArray* menuButtons;
@property (strong, nonatomic) NSMutableArray* sections; 

@end
