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

- (void) configureWithPoll:(NSMutableDictionary*)poll andIndexPath:(NSIndexPath *)indexPath andColors:(NSArray*)colors
{
    NSMutableDictionary *pollAnswer = [[poll pollAnswers] objectAtIndex:indexPath.row];
    NSMutableDictionary *userAnswer = [poll userAnswer];
    
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:[pollAnswer answerText]];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:20.0]];
    
    UILabel *percentage = (UILabel*)[self.contentView viewWithTag:2];
    [percentage setText:[NSString stringWithFormat:@"%@", [pollAnswer percentage]]];
    [percentage setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:15.0]];
    
    UILabel *numberChosen = (UILabel*)[self.contentView viewWithTag:3];
    [numberChosen setText:[NSString stringWithFormat:@"%@ %@", [pollAnswer numberChosen], [[pollAnswer numberChosen] isEqualToString:@"1"] ? @"response" : @"responses"]];
    [numberChosen setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:15.0]];
    
    [self setBackgroundColor:[colors objectAtIndex:indexPath.row]];
    [lbl setTextColor:[UIColor whiteColor]];
    [percentage setTextColor:[UIColor whiteColor]];
    [numberChosen setTextColor:[UIColor whiteColor]];

    UIImageView* readView = (UIImageView*)[self.contentView viewWithTag:43];
    if ([[pollAnswer stringID] isEqualToString:[userAnswer pollAnswerID]]) {
        [readView setHidden:NO];
    } else {
        [readView setHidden:YES];
    }
}
@end
