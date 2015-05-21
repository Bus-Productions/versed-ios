
//
//  VSOverallResultsTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/20/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSOverallResultsTableViewCell.h"

@implementation VSOverallResultsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithQuizResult:(NSMutableArray*)quizResults
{
    UILabel *recentQuizResultLabel = (UILabel*)[self viewWithTag:1];
    [recentQuizResultLabel setText:[NSString stringWithFormat:@"%d of %lu correct", [quizResults numberQuizResultsCorrect], (unsigned long)[quizResults count]]];
    UILabel *overallStatsLabel = (UILabel*)[self viewWithTag:2];
    [overallStatsLabel setText:[[[LXSession thisSession] user] overallQuizPercentage]];
}

@end
