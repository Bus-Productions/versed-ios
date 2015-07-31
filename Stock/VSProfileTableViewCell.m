//
//  VSProfileTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSProfileTableViewCell.h"

@implementation VSProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    UILabel *name = (UILabel*)[self viewWithTag:1];
    [name setText:[[[LXSession thisSession] user] name]];
    [name setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:20.0f]];
    [name setTextColor:[UIColor whiteColor]];
    
    UILabel *level = (UILabel*)[self viewWithTag:2];
    [level setText:[NSString stringWithFormat:@"Level: %@", [[[[LXSession thisSession] user] level] uppercaseString]]];
    [level setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    [level setTextColor:[UIColor whiteColor]];
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0];
    self.selectedBackgroundView = selectionColor;
}

@end
