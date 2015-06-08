//
//  VSCompletedTrackTitleTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSCompletedTrackTitleTableViewCell : UITableViewCell

- (void) configureWithTrack:(NSMutableDictionary*)track andUsers:(NSMutableArray*)users;
- (void) configureForDiscussionWithTrack:(NSMutableDictionary*)track;

@end
