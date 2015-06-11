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
    
    UILabel* title = (UILabel*)[baseView viewWithTag:2];
    [title setText:[track headline]];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:32.0f]];
    [title setTextColor:[UIColor whiteColor]];
    
    title.layer.shadowColor = [[UIColor blackColor] CGColor];
    title.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    title.layer.shadowRadius = 3.0;
    title.layer.shadowOpacity = 0.8;
    title.layer.masksToBounds = NO;
    
    UILabel* subTitle = (UILabel*)[baseView viewWithTag:3];
    [subTitle setText:@"10 resources · 43 minutes"];
    [subTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]];
    [subTitle setTextColor:[UIColor whiteColor]];
    
    titsubTitlele.layer.shadowColor = [[UIColor blackColor] CGColor];
    subTitle.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    subTitle.layer.shadowRadius = 2.0;
    subTitle.layer.shadowOpacity = 0.8;
    subTitle.layer.masksToBounds = NO;
    
    UILabel* description = (UILabel*)[baseView viewWithTag:4];
    
    self.saveButton = (UIButton*)[baseView viewWithTag:5];
    [self.saveButton setTitle:[self saveToMyTracksButtonTitleWithTrack:track] forState:UIControlStateNormal];
    [self.saveButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[self.saveButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
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
