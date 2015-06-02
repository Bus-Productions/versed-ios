//
//  VSCompletedTrackViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSSaveToMyTracksButton.h"

@interface VSCompletedTrackViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    VSSaveToMyTracksButton *saveToMyTracksButton;
}
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *usersCompleted;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *track;
@property (strong, nonatomic) NSMutableArray *myTracksIDs;

@end
