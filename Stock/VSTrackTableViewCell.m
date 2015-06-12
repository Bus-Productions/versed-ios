//
//  VSTrackTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSTrackTableViewCell.h"

#define SAVE_TO_MY_TRACKS_TEXT @"Save to my tracks"
#define REMOVE_FROM_MY_TRACKS_TEXT @"Remove from my tracks"

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
    if ([track mediaURL]) {
        if ([SGImageCache haveImageForURL:[track mediaURL]]) {
            [headlineImage setImage:[SGImageCache imageForURL:[track mediaURL]]];
        } else if (![headlineImage.image isEqual:[SGImageCache imageForURL:[track mediaURL]]]) {
            headlineImage.image = nil;
            [headlineImage setAlpha:0.0f];
            [SGImageCache getImageForURL:[track mediaURL]].then(^(UIImage* image) {
                if (image) {
                    headlineImage.image = image;
                }
                [UIView animateWithDuration:1.0f animations:^(void){
                    [headlineImage setAlpha:1.0f];
                }];
            });
        }
    }
    
    UILabel* title = (UILabel*)[baseView viewWithTag:2];
    [title setText:[track headline]];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:28.0f]];
    [title setTextColor:[UIColor whiteColor]];
    
    title.layer.shadowColor = [[UIColor blackColor] CGColor];
    title.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    title.layer.shadowRadius = 4.0;
    title.layer.shadowOpacity = 1.0;
    title.layer.masksToBounds = NO;
    
    UILabel* subTitle = (UILabel*)[baseView viewWithTag:3];
    [subTitle setText:@"10 resources · 43 minutes"];
    [subTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [subTitle setTextColor:[UIColor whiteColor]];
    
    subTitle.layer.shadowColor = [[UIColor blackColor] CGColor];
    subTitle.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    subTitle.layer.shadowRadius = 1.5;
    subTitle.layer.shadowOpacity = 1.0;
    subTitle.layer.masksToBounds = NO;
    
    UILabel* description = (UILabel*)[baseView viewWithTag:4];
    [description setTextColor:[UIColor grayColor]];
    [description setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [description setText:[track objectForKey:@"description"]];
    
    self.saveButton = (UIButton*)[baseView viewWithTag:5];
    [self.saveButton setTitle:[self saveToMyTracksButtonTitleWithTrack:track] forState:UIControlStateNormal];
    [self.saveButton setBackgroundColor:[UIColor colorWithRed:0.925f green:0.925f blue:0.925f alpha:1.0f]];
    [self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[self.saveButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
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
