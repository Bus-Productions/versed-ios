//
//  VSPollsTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPollsTableViewCell.h"

@implementation VSPollsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithPoll:(NSMutableDictionary*)poll andIndexPath:(NSIndexPath*)indexPath
{
    UIView* container = (UIView*)[self.contentView viewWithTag:10];
    
    UILabel *lbl = (UILabel*)[container viewWithTag:1];
    [lbl setText:[NSString stringWithFormat:@"guesstimate #%ld", indexPath.row + 1]];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:18.0f]];
    
    UILabel *bottomLabel = (UILabel*)[container viewWithTag:2];
    [bottomLabel setText:[[poll objectForKey:@"poll"] pollQuestion]];
    [bottomLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0f]];
}
@end
