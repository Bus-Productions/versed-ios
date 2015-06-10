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
    [congrats setText:[NSString stringWithFormat:@"Completed the %@ Track", [track headline]]];
    
    UILabel *status = (UILabel*)[self viewWithTag:2];
    [status setText:[NSString stringWithFormat:@"Your status: %@", [[[LXSession thisSession] user] level]]];
}
@end
