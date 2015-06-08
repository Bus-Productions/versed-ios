//
//  VSResourceTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSResourceTableViewCell.h"

@implementation VSResourceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithResource:resource andCompletedResources:completedResources
{
    UILabel *lbl = (UILabel*)[self.contentView viewWithTag:1];
    if ([completedResources containsObject:resource] || [completedResources containsObject:[resource ID]]) {
        [lbl setText:[NSString stringWithFormat:@"%@ %@", [resource objectForKey:@"headline"], @"(completed)"]];
    } else {
        [lbl setText:[resource objectForKey:@"headline"]];
    }
}
@end
