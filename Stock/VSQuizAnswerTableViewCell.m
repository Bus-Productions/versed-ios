//
//  VSQuizAnswerTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSQuizAnswerTableViewCell.h"

@implementation VSQuizAnswerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithAnswer:(NSMutableDictionary *)answer
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:[answer answerText]];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0f]];
    [lbl setTextColor:[UIColor blackColor]];
}

@end
