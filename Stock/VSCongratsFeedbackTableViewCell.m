//
//  VSCongratsFeedbackTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/10/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSCongratsFeedbackTableViewCell.h"

@implementation VSCongratsFeedbackTableViewCell

@synthesize slider;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    UILabel* topLabel = (UILabel*)[self.contentView viewWithTag:100];
    [topLabel setTextColor:[UIColor grayColor]];
    [topLabel setText:@"How helpful was this track?"];
    [topLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:20.0f]];
    
    UIButton* submitButton = (UIButton*)[self.contentView viewWithTag:9];
    [[submitButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]];
    
    [self.ratingLabel setText:@"5 out of 5"];
    [self.ratingLabel setFont:[UIFont fontWithName:@"SourcsSansPro-Bold" size:18.0f]];
    [self.ratingLabel setTextColor:[UIColor blackColor]];

    [self.slider setBackgroundColor:[UIColor clearColor]];
    [self.slider setMinimumValue:0.0];
    [self.slider setMaximumValue:5.0];
    [self.slider setContinuous:YES];
    [self.slider setValue:5.0]; 
}

- (void) sliderChanged
{
    [self.ratingLabel setText:[NSString stringWithFormat:@"%@ out of 5", [self sliderValue]]];
}

- (NSNumber*) sliderValue
{
    return [NSNumber numberWithLong:lroundf(self.slider.value)];
}

@end
