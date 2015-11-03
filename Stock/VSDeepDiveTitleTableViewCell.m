//
//  VSDeepDiveTitleTableViewCell.m
//  Versed
//
//  Created by Joseph Gill on 11/2/15.
//  Copyright © 2015 LXV. All rights reserved.
//

#import "VSDeepDiveTitleTableViewCell.h"

@implementation VSDeepDiveTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) configure
{
    UILabel *title = (UILabel*)[self.contentView viewWithTag:1];
    [title setText:@"   Deep Dive"];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [title setTextColor:[UIColor darkGrayColor]];
}
@end
