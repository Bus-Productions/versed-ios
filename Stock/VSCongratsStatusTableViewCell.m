//
//  VSCongratsStatusTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/10/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSCongratsStatusTableViewCell.h"

@implementation VSCongratsStatusTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithTrack:(NSMutableDictionary*)track
{
    UILabel *congrats = (UILabel*)[self viewWithTag:1];
    [congrats setText:[NSString stringWithFormat:@"Nice work!\nWay to go, %@!", [[[LXSession thisSession] user] firstName]]];
    [congrats setTextColor:[UIColor whiteColor]];
    [congrats setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:32.0f]];
    
    UILabel *status = (UILabel*)[self viewWithTag:2];
    [status setText:[NSString stringWithFormat:@"You've completed the %@ track. Your new status: %@", [track headline], [[[[LXSession thisSession] user] level] uppercaseString]]];
    [status setTextColor:[UIColor whiteColor]];
    [status setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
}
@end
