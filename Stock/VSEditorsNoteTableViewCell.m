//
//  VSEditorsNoteTableViewCell.m
//  Versed
//
//  Created by Joseph Gill on 8/4/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSEditorsNoteTableViewCell.h"

#define SAVE_TO_MY_TRACKS_TEXT @"Save to my tracks"
#define REMOVE_FROM_MY_TRACKS_TEXT @"Remove from my tracks"

@implementation VSEditorsNoteTableViewCell

@synthesize track;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureAndHide:(BOOL)hide
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.detailContainerView setBackgroundColor:[UIColor clearColor]];
    [self.detailContainerView setHidden:hide];
    NSString *arrow = hide ? @"\u25B8" : @"\u25BC";
    
    UILabel *title = (UILabel*)[self.contentView viewWithTag:1];
    [title setText:[NSString stringWithFormat:@"%@ Introduction", arrow]];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:13.0f]];
    [title setTextColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0]];
    
    UILabel *note = (UILabel*)[self.contentView viewWithTag:3];
    [note setText:[self.track editorsNote]];
    [note setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]];
}


# pragma mark actions

- (void) contract
{
    UILabel *title = (UILabel*)[self.contentView viewWithTag:1];
    [title setText:@"\u25B8 Introduction"];
    self.detailContainerView.hidden = YES;
}

- (void) expand
{
    UILabel *title = (UILabel*)[self.contentView viewWithTag:1];
    [title setText:@"\u25BC Introduction"];
    self.detailContainerView.hidden = NO;
}

@end
