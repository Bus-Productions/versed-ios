//
//  VSProfileTopicsTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSProfileTopicsTableViewCell.h"

@implementation VSProfileTopicsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    UIView* container = (UIView*)[self.contentView viewWithTag:10];
    NSMutableDictionary *user = [[LXSession thisSession] user];

    UILabel *tracks = (UILabel*)[container viewWithTag:1];
    [tracks setText:[NSString stringWithFormat:@"%@", [user score]]];
    [tracks setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:100.0f]];
    
    UILabel *pts = (UILabel*)[container viewWithTag:5];
    [pts setText:@"LIFETIME POINTS"];
    [pts setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:12.0f]];
    
    UILabel *level = (UILabel*)[self viewWithTag:2];
    [level setText:[NSString stringWithFormat:@"LEVEL: %@", [[user level] uppercaseString]]];
    [level setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    
    UILabel *points = (UILabel*)[self viewWithTag:3];
    NSString *pointsToNextLevel = [user pointsToNextLevel];
    if ([pointsToNextLevel isEqualToString:@"0"]) {
        [points setText:@"You are at the highest level!"];
    } else {
        [points setText:[NSString stringWithFormat:@"Only %@ more %@ until you\nreach the next level.", pointsToNextLevel, [pointsToNextLevel isEqualToString:@"1"] ? @"point" : @"points"]];
    }
    [points setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
}

@end
