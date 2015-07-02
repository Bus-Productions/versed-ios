//
//  VSQuizQuestionTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSQuizQuestionTableViewCell.h"

@implementation VSQuizQuestionTableViewCell

@synthesize timerLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithQuestion:(NSMutableDictionary *)question
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:[question questionText]];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:22.0f]];
}

- (void) updateTimerLabel:(int)time
{
    [self.timerLabel setText:[NSString stringWithFormat:@"%ds", time]];
}

@end
