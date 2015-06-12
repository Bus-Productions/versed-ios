//
//  VSPollQuestionTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPollQuestionTableViewCell.h"

@implementation VSPollQuestionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithPoll:(NSMutableDictionary*)poll
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:[poll pollQuestion]];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0f]];
}

@end
