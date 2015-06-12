//
//  VSTrackTitleTableViewCell.h
//  Versed
//
//  Created by Will Schreiber on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSTrackTitleTableViewCell : UITableViewCell

@property (strong, nonatomic) NSMutableDictionary* track;

- (void) configureWithTrack:(NSMutableDictionary*)t andIndexPath:(NSIndexPath*)indexPath;

@end
