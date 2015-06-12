//
//  VSFaqQuestionTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSFaqQuestionTableViewCell.h"

@implementation VSFaqQuestionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithFaq:(NSMutableDictionary*)faq
{
    UILabel *questionText = (UILabel*)[self.contentView viewWithTag:1];
    [questionText setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:22.0f]];
    [questionText setText:[faq faqQuestion]];
}

@end
