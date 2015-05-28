//
//  VSLeaderTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/27/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSLeaderTableViewCell.h"

@implementation VSLeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithUser:(NSMutableDictionary*)user andLeaders:(NSMutableArray*)leaders
{
    UILabel *ranking = (UILabel*)[self viewWithTag:1];
    UILabel *name = (UILabel*)[self viewWithTag:2];
    UILabel *quizzesTaken = (UILabel*)[self viewWithTag:3];
    UILabel *percentCorrect = (UILabel*)[self viewWithTag:4];
    
    [ranking setText:[self rankingOfUser:user inLeaders:leaders]];
    [name setText:[user name]];
    [quizzesTaken setText:[self quizzesTakenTextForUser:user]];
    [percentCorrect setText:[user overallQuizPercentage]];
}

- (NSString *) rankingOfUser:(NSMutableDictionary*)user inLeaders:(NSMutableArray*)leaders
{
    return [NSString stringWithFormat:@"#%lu", (unsigned long)[leaders indexOfObject:user] + 1];
}

- (NSString *) quizzesTakenTextForUser:(NSMutableDictionary*)user
{
    NSString *quizText = @"quizzes";
    if ([[user totalQuizzes] isEqualToString:@"1"]){
        quizText = @"quiz";
    }
    return [NSString stringWithFormat:@"%@ %@ taken", [user totalQuizzes], quizText];
}

@end
