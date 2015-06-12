//
//  VSUsersCompletedTrackTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSUsersCompletedTrackTableViewCell.h"

@implementation VSUsersCompletedTrackTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) configure:(NSMutableDictionary*)dict
{
    UILabel *name = (UILabel*)[self.contentView viewWithTag:1];
    [name setText:[[dict objectForKey:@"user"] name]];
    UILabel *completedDate = (UILabel*)[self.contentView viewWithTag:2];
    //NSLog(@"%@", [[dict trackUserPairs] firstObject]);
    [completedDate setText:[[[dict trackUserPairs] firstObject] completionDate]];
}
@end
