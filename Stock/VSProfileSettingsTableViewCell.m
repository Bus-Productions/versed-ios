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
    UILabel* settings = (UILabel*)[self.contentView viewWithTag:40];
    [settings setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    
    UILabel* nameLabel = (UILabel*)[self.contentView viewWithTag:1];
    [nameLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    
    UILabel* passwordLabel = (UILabel*)[self.contentView viewWithTag:3];
    [passwordLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    
    UILabel* version = (UILabel*)[self.contentView viewWithTag:5];
    [version setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:14.0f]];
    
    UITextField *name = (UITextField*)[self viewWithTag:4];
    [self setupTextFieldAppearance:name];
    name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Name" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]}];

    UITextField *password = (UITextField*)[self viewWithTag:6];
    [self setupTextFieldAppearance:password];
    
    password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Change Password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]}];
    
    UIButton* submitButton = (UIButton*)[self.contentView viewWithTag:7];
    
    NSMutableDictionary *user = [[LXSession thisSession] user];
    
    [name setText:[user name] ? [user name] : @""];
    
    [password setText:@""]; 
    [password setPlaceholder:@"Change Password"];
    
    [version setText:[NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];

    
    [self setupButtonAppearance:submitButton];
}



- (void) setupButtonAppearance:(UIButton*)button
{
    [[button titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    button.layer.cornerRadius = 4;
    button.clipsToBounds = YES;
}

- (void) setupTextFieldAppearance:(UITextField*)textField
{
    [self addBottomBorderToField:textField];
    
    [self setTintForField:textField withPlaceholder:@""];
}

- (void) addBottomBorderToField:(UITextField*)field
{
    CGFloat borderHeight = 1.0f;
    
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0, field.frame.size.height-borderHeight, field.frame.size.width, 1.0f);
    bottomBorder1.backgroundColor = [UIColor whiteColor].CGColor;
    
    [field.layer addSublayer:bottomBorder1];
}

- (void) setTintForField:(UITextField*)field withPlaceholder:(NSString*)placeholderText
{
    [field setTintColor:[UIColor whiteColor]];
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]}];
    [field setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.5f]];
}

@end
