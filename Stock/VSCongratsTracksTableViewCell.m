//
//  VSCongratsTracksTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/10/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSCongratsTracksTableViewCell.h"

@implementation VSCongratsTracksTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    NSMutableDictionary *user = [[LXSession thisSession] user];
    UILabel *tracksCompleted = (UILabel*)[self viewWithTag:1];
    [tracksCompleted setText:[[NSString stringWithFormat:@"%@ tracks completed", [user completedTracksCount]] uppercaseString]];
    [tracksCompleted setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [tracksCompleted setTextColor:[UIColor whiteColor]];
    
    UILabel *nextLevel = (UILabel*)[self viewWithTag:2];
    [nextLevel setText:[NSString stringWithFormat:@"Your status: %@", [user numberTracksToNextLevel]]];
    [nextLevel setHidden:YES];
}
@end
