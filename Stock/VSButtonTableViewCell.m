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
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:text];
    if (color) {
        [lbl setBackgroundColor:color];
    }
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:18.0f]];
}
@end
