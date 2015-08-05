//
//  VSEditorsNoteTableViewCell.h
//  Versed
//
//  Created by Joseph Gill on 8/4/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Fold.h"

@interface VSEditorsNoteTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL withDetails;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *detailContainerView;

- (void) configureWithDetails:(BOOL)details andTrack:(NSMutableDictionary*)track; 
- (void)animateOpen;
- (void)animateClosed;

@end
