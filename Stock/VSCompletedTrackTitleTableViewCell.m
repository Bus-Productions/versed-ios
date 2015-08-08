//
//  VSCompletedTrackTitleTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSCompletedTrackTitleTableViewCell.h"

@implementation VSCompletedTrackTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithTrack:(NSMutableDictionary*)track andUsers:(NSMutableArray*)users
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:[NSString stringWithFormat:@"%@ in your organization %@ versed on %@", [users formattedPluralizationForSingular:@"person" orPlural:@"people"], users.count == 1 ? @"is" : @"are", [track headline]]];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:24.0f]];
    [lbl boldSubstring:[track headline]];
}

- (void) configureForDiscussionWithTrack:(NSMutableDictionary*)track
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:[NSString stringWithFormat:@"Join the %@ discussion", [track headline]]];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:24.0f]];
    [lbl boldSubstring:[track headline]];
}
@end
