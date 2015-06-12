//
//  VSFaqResponseTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSFaqResponseTableViewCell.h"

@implementation VSFaqResponseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithFaq:(NSMutableDictionary*)faq
{
    UILabel *responseText = (UILabel*)[self.contentView viewWithTag:1];
    [responseText setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [responseText setText:[faq faqResponse]];
}

@end
