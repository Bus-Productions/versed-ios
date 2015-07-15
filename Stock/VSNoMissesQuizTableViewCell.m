//
//  VSNoMissesQuizTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/21/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSNoMissesQuizTableViewCell.h"

@implementation VSNoMissesQuizTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    UILabel *lbl = (UILabel*)[self viewWithTag:1];
    [lbl setText:@"Congrats! You got them all right!"];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:20.0f]];
}

@end
