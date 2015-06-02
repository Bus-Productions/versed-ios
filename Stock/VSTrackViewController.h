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
    UIButton *saveToMyTracksButton;
    NSMutableArray *completedPeople;
    NSMutableArray *discussionPeople;
}

@property (strong, nonatomic) NSMutableDictionary *track;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet UIButton *seeCompletedButton;
@property (weak, nonatomic) IBOutlet UIButton *joinDiscussionButton;

- (IBAction)seeCompletedAction:(id)sender;
- (IBAction)joinDiscussionAction:(id)sender;

@end
