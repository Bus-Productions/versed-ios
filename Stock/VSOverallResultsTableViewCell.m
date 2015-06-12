
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

- (void) configureWithQuizResults:(NSMutableArray*)quizResults
{
    UILabel *recentQuizResultLabel = (UILabel*)[self viewWithTag:1];
    [recentQuizResultLabel setText:[NSString stringWithFormat:@"%d of %lu", [quizResults numberQuizResultsCorrect], (unsigned long)[quizResults count]]];
    [recentQuizResultLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:40.0f]];
    [recentQuizResultLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *overallStatsLabel = (UILabel*)[self viewWithTag:2];
    [overallStatsLabel setText:[[[LXSession thisSession] user] overallQuizPercentage]];
    [overallStatsLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:40.0f]];
    [overallStatsLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *labelLeft = (UILabel*)[self viewWithTag:3];
    [labelLeft setText:@"QUESTIONS CORRECT"];
    [labelLeft setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [labelLeft setTextColor:[UIColor whiteColor]];
    
    UILabel *labelRight = (UILabel*)[self viewWithTag:4];
    [labelRight setText:@"LIFETIME ACCURACY"];
    [labelRight setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [labelRight setTextColor:[UIColor whiteColor]];
    
    UIButton* button = (UIButton*)[self.contentView viewWithTag:5];
    [[button titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
}

@end
