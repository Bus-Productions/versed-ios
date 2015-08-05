//
//  VSEditorsNoteTableViewCell.m
//  Versed
//
//  Created by Joseph Gill on 8/4/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSEditorsNoteTableViewCell.h"

@implementation VSEditorsNoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithDetails:(BOOL)details andTrack:(NSMutableDictionary *)track
{
    [self setWithDetails:details];
    UILabel *title = (UILabel*)[self.contentView viewWithTag:1];
    [title setText:@"Editor's Note"];
}


- (void)setWithDetails:(BOOL)withDetails {
    _withDetails = withDetails;
    
    if (withDetails) {
        self.detailContainerViewHeightConstraint.priority = 250;
    } else {
        self.detailContainerViewHeightConstraint.priority = 999;
    }
}


- (void)animateOpen {
    UIColor *originalBackgroundColor = self.contentView.backgroundColor;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.detailContainerView foldOpenWithTransparency:YES
                                   withCompletionBlock:^{
                                       self.contentView.backgroundColor = originalBackgroundColor;
                                   }];
}

- (void)animateClosed {
    UIColor *originalBackgroundColor = self.contentView.backgroundColor;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.detailContainerView foldClosedWithTransparency:YES withCompletionBlock:^{
        self.contentView.backgroundColor = originalBackgroundColor;
    }];
}

@end
