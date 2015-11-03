//
//  VSButtonTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSButtonTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VSButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithText:(NSString*)text andColor:(UIColor*)color
{
    [self configureWithText:text andColor:color andBorder:NO andTextColor:nil];
}

- (void) configureWithText:(NSString*)text andColor:(UIColor*)color andBorder:(BOOL)border andTextColor:(UIColor*)textColor
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:text];
    if (color) {
        [lbl setBackgroundColor:color];
    }
    if (border) {
        lbl.layer.borderColor = textColor.CGColor;
        lbl.layer.borderWidth = 2.0;
    }
    if (textColor) {
        [lbl setTextColor:textColor];
    }
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:18.0f]];
}

- (CGFloat) configureHeight
{
    if ([[UIScreen mainScreen] bounds].size.height < 500.0) { //4s & iPad
        self.imageViewHeight.constant = 40;
    } else if ([[UIScreen mainScreen] bounds].size.height < 510.0) { //5s
        self.imageViewHeight.constant = 45;
    } else { //6 & 6+
        self.imageViewHeight.constant = 80;
    }
    return self.imageViewHeight.constant;
}
@end
