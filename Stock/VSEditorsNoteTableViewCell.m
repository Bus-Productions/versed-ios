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

@synthesize track, myTrackIDs;

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
    NSString *arrow = hide ? @"\u25BC" : @"\u25B4";
    
    UILabel *title = (UILabel*)[self.contentView viewWithTag:1];
    [title setText:[NSString stringWithFormat:@"Introduction %@", arrow]];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:13.0f]];
    
    UILabel *note = (UILabel*)[self.contentView viewWithTag:3];
    [note setText:[self.track editorsNote]];
    [note setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]];
    
    UIButton *saveButton = (UIButton*)[self.contentView viewWithTag:5];
    [saveButton setTitle:[self saveToMyTracksButtonTitle] forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[UIColor colorWithRed:0.925f green:0.925f blue:0.925f alpha:1.0f]];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[saveButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]];
}


# pragma mark actions

- (IBAction)saveToMyTracks:(id)sender {
    [self switchSaveToTracksText:(UIButton*)sender];
    [self updateMyTrack];
}

- (void) updateMyTrack
{
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/update_my_tracks.json", [[[LXSession thisSession] user] ID]] withMethod:@"POST" withParamaters:@{@"track_id": [self.track ID]} authType:@"none"
                           success:^(id responseObject){
                               [[[(NSArray*)[responseObject objectForKey:@"my_tracks"] cleanArray] mutableCopy] saveLocalWithKey:@"myTracks"];
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedMyTracks" object:nil userInfo:responseObject];
                           } failure:^(NSError* error) {
                           }
     ];
}

- (void) switchSaveToTracksText:(UIButton*)btn
{
    if ([btn.currentTitle isEqualToString:SAVE_TO_MY_TRACKS_TEXT]) {
        [btn setTitle:REMOVE_FROM_MY_TRACKS_TEXT forState:UIControlStateNormal];
    } else {
        [btn setTitle:SAVE_TO_MY_TRACKS_TEXT forState:UIControlStateNormal];
    }
}

- (NSString*) saveToMyTracksButtonTitle
{
    NSMutableArray *myTracksIDs = [[NSMutableArray alloc] init];
    [myTracksIDs addObjectsFromArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] pluckIDs]];
    if (myTracksIDs && myTracksIDs.count > 0 && [myTracksIDs containsObject:[track ID]]) {
        return REMOVE_FROM_MY_TRACKS_TEXT;
    }
    return SAVE_TO_MY_TRACKS_TEXT;
}

- (void) contract
{
    UILabel *title = (UILabel*)[self.contentView viewWithTag:1];
    [title setText:@"Introduction \u25BC"];
    self.detailContainerView.hidden = YES;
}

- (void) expand
{
    UILabel *title = (UILabel*)[self.contentView viewWithTag:1];
    [title setText:@"Introduction \u25B4"];
    self.detailContainerView.hidden = NO;
}

@end
