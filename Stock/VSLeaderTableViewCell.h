//
//  VSLeaderTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/27/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSLeaderTableViewCell : UITableViewCell

- (void) configureWithUser:(NSMutableDictionary*)user andLeaders:(NSMutableArray*)leaders;

@end
