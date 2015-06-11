//
//  VSTrackTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSTrackTableViewCell.h"

#define SAVE_TO_MY_TRACKS_TEXT @"Save To My Tracks"
#define REMOVE_FROM_MY_TRACKS_TEXT @"Remove From My Tracks"

@implementation VSTrackTableViewCell

@synthesize saveButton;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithTrack:(NSMutableDictionary*)track andIndexPath:(NSIndexPath*)indexPath
{
    UIView* baseView = (UIView*) [self.contentView viewWithTag:10];
    
    UIImageView* headlineImage = (UIImageView*)[baseView viewWithTag:1];
    //NSURL* imageURL = NSURL URLWithString:[track ]
    
    UILabel *title = (UILabel*)[baseView viewWithTag:2];
    [title setText:[track headline]];
    
    self.saveButton = (UIButton*)[self.contentView viewWithTag:2];
    [self.saveButton setTitle:[self saveToMyTracksButtonTitleWithTrack:track] forState:UIControlStateNormal];
}

- (NSString*) saveToMyTracksButtonTitleWithTrack:(NSMutableDictionary*)track
{
    NSMutableArray *myTracksIDs = [[NSMutableArray alloc] init];
    [myTracksIDs addObjectsFromArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] pluckIDs]];
    if (myTracksIDs && myTracksIDs.count > 0 && [myTracksIDs containsObject:[track ID]]) {
        return REMOVE_FROM_MY_TRACKS_TEXT;
    }
    return SAVE_TO_MY_TRACKS_TEXT;
}

@end
