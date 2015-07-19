//
//  VSCongratsTracksTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/10/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSCongratsTracksTableViewCell.h"
//#import "YLProgressBar.h"

@implementation VSCongratsTracksTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configure
{
    NSMutableDictionary *user = [[LXSession thisSession] user];
    UILabel *tracksCompleted = (UILabel*)[self viewWithTag:1];
    [tracksCompleted setText:[[NSString stringWithFormat:@"%@ of %@ %@ completed", [user completedTracksCount], [user liveTracksCount], [[user liveTracksCount] isEqualToString:@"1"] ? @"track" : @"tracks"] uppercaseString]];
    [tracksCompleted setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [tracksCompleted setTextColor:[UIColor whiteColor]];
    
//    YLProgressBar *progressBar = (YLProgressBar*)[self.contentView viewWithTag:2];
////    progressBar.type               = YLProgressBarTypeRounded;
//    progressBar.progressTintColor  = [UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0];
////    progressBar.hideStripes        = YES;
//    progressBar.progress = [[user liveTracksCount] floatValue]/[[user completedTracksCount] floatValue];
}
@end
