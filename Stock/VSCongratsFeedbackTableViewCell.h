//
//  VSCongratsFeedbackTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/10/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSCongratsFeedbackTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

- (void) configure;

- (void) sliderChanged;
- (NSNumber*) sliderValue;

@end
