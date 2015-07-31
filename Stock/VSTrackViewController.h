//
//  VSTrackViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSTrackViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *myTracksIDs;
    NSMutableArray *completedPeople;
    NSMutableArray *usersDiscussing;
    NSMutableArray *completedResources; 
    NSMutableArray *messages;
    BOOL requesting;
    BOOL showCongrats;
    NSMutableDictionary *pollToShow;
}

@property (strong, nonatomic) NSMutableDictionary *track;
@property (strong, nonatomic) NSMutableArray *sections;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *seeCompletedButton;
@property (weak, nonatomic) IBOutlet UIButton *joinDiscussionButton;

@property (strong, nonatomic) IBOutlet UIView *bottomToolbarView;

- (IBAction)seeCompletedAction:(id)sender;
- (IBAction)joinDiscussionAction:(id)sender;

@end
