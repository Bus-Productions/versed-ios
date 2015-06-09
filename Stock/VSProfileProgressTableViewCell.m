//
//  VSProfileProgressTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSProfileProgressTableViewCell.h"

@implementation VSProfileProgressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    UILabel *name = (UILabel*)[self viewWithTag:1];
    [name setText:[NSString stringWithFormat:@"%@'s Progress", [[[LXSession thisSession] user] name]]];
    
    UILabel *level = (UILabel*)[self viewWithTag:2];
    [level setText:[NSString stringWithFormat:@"— Level: %@ —", [[[LXSession thisSession] user] level]]];
    
    UILabel *tracks = (UILabel*)[self viewWithTag:3];
    NSString *trackCount = [[[LXSession thisSession] user] numberTracksToNextLevel];
    [tracks setText:[NSString stringWithFormat:@"%@ %@ until you reach the next level", trackCount, [trackCount isEqualToString:@"1"] ? @"track" : @"tracks"]];
}

@end
