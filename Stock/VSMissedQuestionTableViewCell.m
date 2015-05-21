//
//  VSMissedQuestionTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/21/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSMissedQuestionTableViewCell.h"

@implementation VSMissedQuestionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithQuizResult:(NSMutableDictionary*)quizResult {
    UILabel *questionMissed = (UILabel*)[self viewWithTag:1];
    [questionMissed setText:[[quizResult quizQuestion] questionText]];
    UILabel *track = (UILabel*)[self viewWithTag:2];
    [track setText:[[[quizResult quizQuestion] track] headline]];
}

@end
