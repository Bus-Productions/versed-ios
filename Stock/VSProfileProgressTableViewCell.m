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
    UILabel *name = (UILabel*)[self viewWithTag:1];
    [name setText:[NSString stringWithFormat:@"%@'s Progress", [[[LXSession thisSession] user] firstName]]];
    [name setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:28.0f]];
    
    UILabel *level = (UILabel*)[self viewWithTag:2];
    [level setText:[NSString stringWithFormat:@"LEVEL: %@", [[[[LXSession thisSession] user] level] uppercaseString]]];
    [level setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    
    UILabel *tracks = (UILabel*)[self viewWithTag:3];
    NSString *trackCount = [[[LXSession thisSession] user] numberTracksToNextLevel];
    [tracks setText:[NSString stringWithFormat:@"Only %@ more %@ until you\nreach the next level.", !NULL_TO_NIL(trackCount) ? @"0" : trackCount, [trackCount isEqualToString:@"1"] ? @"track" : @"tracks"]];
    [tracks setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
}

@end
