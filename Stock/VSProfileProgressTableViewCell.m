//
//  VSProfileProgressTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSProfileProgressTableViewCell.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

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
    NSMutableDictionary *user = [[LXSession thisSession] user];
    UILabel *name = (UILabel*)[self viewWithTag:1];
    [name setText:[NSString stringWithFormat:@"%@'s Progress", [user firstName]]];
    [name setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:28.0f]];
    
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
