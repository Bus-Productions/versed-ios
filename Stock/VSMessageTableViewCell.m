
//
//  VSMessageTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/8/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSMessageTableViewCell.h"

@implementation VSMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureWithMessage:(NSMutableDictionary*)message
{
    UILabel *name = (UILabel*)[self.contentView viewWithTag:1];
    [name setText:[[message objectForKey:@"user"] name]];

    UILabel *mess = (UILabel*)[self.contentView viewWithTag:2];
    [mess setText:[message message]];
    
    UILabel *date = (UILabel*)[self.contentView viewWithTag:3];
    [date setText:[message creationDate]];
}

@end
