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
    [self.ratingLabel setText:@"5 out of 5"];

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
