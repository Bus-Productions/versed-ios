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
    NSMutableDictionary *user = [[LXSession thisSession] user];

    UILabel *tracks = (UILabel*)[container viewWithTag:1];
    [tracks setText:[NSString stringWithFormat:@"%@", [user score]]];
    [tracks setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:100.0f]];
    
    UILabel *pts = (UILabel*)[container viewWithTag:5];
    [pts setText:@"LIFETIME POINTS"];
    [pts setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:12.0f]];
    
    UILabel *tracksCompleted = (UILabel*)[self viewWithTag:2];
    [tracksCompleted setText:[NSString stringWithFormat:@"%@ of %@ %@ completed", [user completedTracksCount], [user liveTracksCount], [[user liveTracksCount] isEqualToString:@"1"] ? @"track" : @"tracks"]];
    [tracksCompleted setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [tracksCompleted setTextColor:[UIColor grayColor]];
    
    UIProgressView *progressBar = (UIProgressView*)[self.contentView viewWithTag:3];
    progressBar.progressTintColor  = [UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0];
    progressBar.progress = [[user completedTracksCount] floatValue]/[[user liveTracksCount] floatValue];
    CATransform3D transform = CATransform3DScale(progressBar.layer.transform, 1.0f, 3.0f, 1.0f);
    progressBar.layer.transform = transform;

}

@end
