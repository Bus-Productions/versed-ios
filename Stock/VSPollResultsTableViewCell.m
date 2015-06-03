//
//  VSPollResultsTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPollResultsTableViewCell.h"

@implementation VSPollResultsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithPollResult:(NSMutableDictionary*)pollAnswer andUserAnswer:(NSMutableDictionary*)userAnswer
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:[pollAnswer answerText]];
    
    UILabel *percentage = (UILabel*)[self.contentView viewWithTag:2];
    [percentage setText:[NSString stringWithFormat:@"%@", [pollAnswer percentage]]];
    
    if ([[pollAnswer stringID] isEqualToString:[userAnswer pollAnswerID]]) {
        [self setBackgroundColor:[UIColor greenColor]];
    }
}
@end
