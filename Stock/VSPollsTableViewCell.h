//
//  VSPollsTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSPollsTableViewCell : UITableViewCell

- (void) configureWithPoll:(NSMutableDictionary*)poll andIndexPath:(NSIndexPath*)indexPath;

@end
