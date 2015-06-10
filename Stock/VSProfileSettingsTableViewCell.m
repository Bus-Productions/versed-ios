//
//  VSProfileSettingsTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSProfileSettingsTableViewCell.h"

@implementation VSProfileSettingsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    UITextField *name = (UITextField*)[self viewWithTag:4];
    UITextField *email = (UITextField*)[self viewWithTag:5];
    UITextField *password = (UITextField*)[self viewWithTag:6];
    NSMutableDictionary *user = [[LXSession thisSession] user];
    [name setText:[user name]];
    [email setText:[user email]];
    [password setText:@""]; 
    [password setPlaceholder:@"Change Password"];
}

@end
