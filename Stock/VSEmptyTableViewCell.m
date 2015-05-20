//
//  VSEmptyTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSEmptyTableViewCell.h"

@implementation VSEmptyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithText:(NSString*)text
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:text];
}

@end