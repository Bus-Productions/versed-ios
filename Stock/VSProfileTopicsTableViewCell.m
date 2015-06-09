//
//  VSProfileTopicsTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSProfileTopicsTableViewCell.h"

@implementation VSProfileTopicsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    UILabel *tracks = (UILabel*)[self viewWithTag:1];
    NSString *trackCount = [[[LXSession thisSession] user] completedTracksCount];
    [tracks setText:[NSString stringWithFormat:@"You are well-versed on %@ %@", trackCount, [trackCount isEqualToString:@"1"] ? @"topic" : @"topics"]];
}

@end
