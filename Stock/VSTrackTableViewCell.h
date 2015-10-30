//
//  VSTrackTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSTrackTableViewCell : UITableViewCell

@property (strong, nonatomic) NSMutableDictionary* track;
@property (strong, nonatomic) UIButton *saveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *minutesRemainingInTrackLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minutesRemainingLeadingConstraint;

- (void) configureWithTrack:(NSMutableDictionary*)t andIndexPath:(NSIndexPath*)indexPath;

- (IBAction)saveTrackAction:(id)sender;
- (IBAction)showDiscussionAction:(id)sender;

@end
