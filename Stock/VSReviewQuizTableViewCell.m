
//
//  VSOverallResultsTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/20/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSReviewQuizTableViewCell.h"

@implementation VSReviewQuizTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithQuizResults:(NSMutableArray*)quizResults andPointsThatRound:(NSInteger)pts
{
    UILabel *recentQuizResultLabel = (UILabel*)[self viewWithTag:1];
    [recentQuizResultLabel setText:[NSString stringWithFormat:@"%d of %lu", [quizResults numberQuizResultsCorrect], (unsigned long)[quizResults count]]];
    [recentQuizResultLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:40.0f]];
    [recentQuizResultLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *ptsThatRound = (UILabel*)[self viewWithTag:2];
    [ptsThatRound setText:[NSString stringWithFormat:@"%ld", (long)pts]];
    [ptsThatRound setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:40.0f]];
    [ptsThatRound setTextColor:[UIColor whiteColor]];
    
    UILabel *overallStatsLabel = (UILabel*)[self viewWithTag:3];
    [overallStatsLabel setText:[[[LXSession thisSession] user] score]];
    [overallStatsLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:40.0f]];
    [overallStatsLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *labelLeft = (UILabel*)[self viewWithTag:4];
    [labelLeft setText:@"QUESTIONS CORRECT"];
    [labelLeft setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [labelLeft setTextColor:[UIColor whiteColor]];
    
    UILabel *labelMiddle = (UILabel*)[self viewWithTag:5];
    [labelMiddle setText:@"POINTS EARNED"];
    [labelMiddle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [labelMiddle setTextColor:[UIColor whiteColor]];
    
    UILabel *labelRight = (UILabel*)[self viewWithTag:6];
    [labelRight setText:@"LIFETIME POINTS"];
    [labelRight setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [labelRight setTextColor:[UIColor whiteColor]];
    
    UIButton* button = (UIButton*)[self.contentView viewWithTag:7];
    if (button) {
        [[button titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    }
    
    UIButton* showLeaderboard = (UIButton*)[self.contentView viewWithTag:8];
    if (showLeaderboard) {
        [[showLeaderboard titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    }
}

@end
