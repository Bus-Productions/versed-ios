//
//  VSDeepDiveTableViewCell.m
//  Versed
//
//  Created by Joseph Gill on 11/2/15.
//  Copyright © 2015 LXV. All rights reserved.
//

#import "VSDeepDiveTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VSDeepDiveTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithDeepDive:(NSMutableDictionary*)deepDive
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    [lbl setBackgroundColor:[UIColor clearColor]];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\u2022 %@ (%@)", [deepDive headline], [deepDive source]]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,string.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f] range:NSMakeRange(0,2+[[deepDive headline] length])];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-LightIt" size:16.0f] range:NSMakeRange(3+[[deepDive headline] length],[[deepDive source] length] + 2)];
    [string addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(2,[[deepDive headline] length])];
    
    [lbl setAttributedText:[string copy]];
}

@end
