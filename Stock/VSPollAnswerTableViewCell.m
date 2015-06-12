//
//  VSPollAnswerTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPollAnswerTableViewCell.h"

@implementation VSPollAnswerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithPollAnswer:(NSMutableDictionary*)pollAnswer
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:[pollAnswer answerText]];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0f]];
    [lbl setTextColor:[UIColor blackColor]];
}

@end
