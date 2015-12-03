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
    [name setText:[NSString stringWithFormat:@"%@ Progress", [user firstName] ? [NSString stringWithFormat:@"%@'s", [user firstName]] : @"Your"]];
    [name setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:28.0f]];
    
    UILabel *tracksCompleted = (UILabel*)[self viewWithTag:2];
    [tracksCompleted setText:[NSString stringWithFormat:@"%@ of %@ %@ completed", [user completedTracksCount], [user liveTracksCount], [[user liveTracksCount] isEqualToString:@"1"] ? @"track" : @"tracks"]];
    [tracksCompleted setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [tracksCompleted setTextColor:[UIColor grayColor]];
    
    UIProgressView *progressBar = (UIProgressView*)[self.contentView viewWithTag:3];
    progressBar.progressTintColor  = [UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0];
    progressBar.progress = [[user completedTracksCount] floatValue]/[[user liveTracksCount] floatValue];
    if (progressBar.frame.size.height < 7.0) {
        CATransform3D transform = CATransform3DScale(progressBar.layer.transform, 1.0f, 3.0f, 1.0f);
        progressBar.layer.transform = transform;
    }
}

@end
