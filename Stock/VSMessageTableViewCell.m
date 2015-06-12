
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
    [name setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:14.0f]];

    UILabel *mess = (UILabel*)[self.contentView viewWithTag:2];
    [mess setText:[message message]];
    [mess setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    
    UILabel *date = (UILabel*)[self.contentView viewWithTag:3];
    [date setText:[[NSDate dateFromString:[message createdAt]] timeAgoInWords]];
    [date setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]];
    [date setTextColor:[UIColor grayColor]];
}

@end
