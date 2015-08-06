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
    UILabel *score = (UILabel*)[self viewWithTag:4];
    
    [ranking setText:[self rankingOfUser:user inLeaders:leaders]];
    [ranking setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:40]];
    
    [name setText:[user name]];
    [name setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:14.0f]];
    
    [quizzesTaken setText:[NSString stringWithFormat:@"%@ - %@", [self quizzesTakenTextForUser:user], [user level]]];
    [quizzesTaken setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:10.0f]];
    [quizzesTaken setTextColor:[UIColor lightGrayColor]];
    
    [score setText:[user score]];
    [score setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:30]];
}

- (NSString *) rankingOfUser:(NSMutableDictionary*)user inLeaders:(NSMutableArray*)leaders
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[leaders indexOfObject:user] + 1];
}

- (NSString *) quizzesTakenTextForUser:(NSMutableDictionary*)user
{
    NSString *quizText = @"quizzes";
    if ([[user quizzesTaken] isEqualToString:@"1"]){
        quizText = @"quiz";
    }
    return [NSString stringWithFormat:@"%@ %@ taken", [user quizzesTaken], quizText];
}

@end
