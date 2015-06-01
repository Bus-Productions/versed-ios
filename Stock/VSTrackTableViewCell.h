//
//  VSTrackTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSTrackTableViewCell : UITableViewCell

- (void) configureWithTrack:(NSMutableDictionary*)track andIndexPath:(NSIndexPath*)indexPath;
@property (strong, nonatomic) UIButton *saveButton;

@end
