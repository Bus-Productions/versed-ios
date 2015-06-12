//
//  VSEmptyTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSEmptyTableViewCell.h"

@implementation VSEmptyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithText:(NSString*)text
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setText:text];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
}

- (void) configureWithTextsInArray:(NSArray*)array
{
    NSInteger i = 0;
    for (NSString* text in array) {
        ++i;
        UILabel* label = (UILabel*)[self.contentView viewWithTag:i];
        if (i == 1) {
            [label setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:25.0f]];
        } else if (i == 2) {
            [label setFont:[UIFont fontWithName:@"SourceSansPro-LightIt" size:16.0f]];
        }
        [label setText:text];
    }
}

@end
