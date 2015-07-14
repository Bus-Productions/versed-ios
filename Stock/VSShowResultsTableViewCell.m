//
//  VSShowResultsTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 7/14/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSShowResultsTableViewCell.h"

@implementation VSShowResultsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    NSMutableDictionary *user = [[LXSession thisSession] user];
    
    UILabel *totalQuizzes = (UILabel*)[self.contentView viewWithTag:1];
    [totalQuizzes setText:[user quizzesTaken]];
    [totalQuizzes setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:40.0f]];
    [totalQuizzes setTextColor:[UIColor whiteColor]];
    
    UILabel *totalPoints = (UILabel*)[self.contentView viewWithTag:2];
    [totalPoints setText:[user score]];
    [totalPoints setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:40.0f]];
    [totalPoints setTextColor:[UIColor whiteColor]];
    
    UILabel *totalQuizzesTitle = (UILabel*)[self.contentView viewWithTag:3];
    [totalQuizzesTitle setText:@"QUIZZES COMPLETED"];
    [totalQuizzesTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [totalQuizzesTitle setTextColor:[UIColor whiteColor]];
    
    UILabel *totalPointsTitle = (UILabel*)[self.contentView viewWithTag:4];
    [totalPointsTitle setText:@"TOTAL POINTS"];
    [totalPointsTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [totalPointsTitle setTextColor:[UIColor whiteColor]];
    
    UIButton* button = (UIButton*)[self.contentView viewWithTag:7];
    [[button titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
}

@end
