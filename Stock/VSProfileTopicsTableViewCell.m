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
    UIView* container = (UIView*)[self.contentView viewWithTag:10];
    
    UILabel *tracks = (UILabel*)[container viewWithTag:1];
    NSString *score = [[[LXSession thisSession] user] score];
    [tracks setText:[NSString stringWithFormat:@"%@", score]];
    [tracks setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:100.0f]];
    
    UILabel *pts = (UILabel*)[container viewWithTag:5];
    [pts setText:@"LIFETIME POINTS"];
    [pts setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:12.0f]];

    NSString *trackCount = [[[LXSession thisSession] user] completedTracksCount];
    UILabel *description = (UILabel*)[container viewWithTag:2];
    [description setText:[NSString stringWithFormat:@"You have completed\n%@ %@.", trackCount, [trackCount isEqualToString:@"1"] ? @"tracks" : @"tracks"]];
    [description setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0f]];
    [description setTextColor:[UIColor grayColor]];
}

@end
