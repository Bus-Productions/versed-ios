//
//  VSSaveToMyTracksButton.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSSaveToMyTracksButton.h"

#define SAVE_TO_MY_TRACKS_TEXT @"Save To My Tracks"
#define REMOVE_FROM_MY_TRACKS_TEXT @"Remove From My Tracks"

@implementation VSSaveToMyTracksButton

@synthesize myTrackIDs, track;


+ (VSSaveToMyTracksButton*) initWithTrack:(NSMutableDictionary*)t andMyTrackIDs:(NSMutableArray*)ids
{
    VSSaveToMyTracksButton *btn = [[VSSaveToMyTracksButton alloc] init];
    btn.myTrackIDs = ids;
    btn.track = t;
    [btn setTitle:[btn saveToMyTracksButtonTitle] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal]; 
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    return btn;
}

- (NSString*) saveToMyTracksButtonTitle
{
    if ([self.myTrackIDs containsObject:[self.track ID]]) {
        return REMOVE_FROM_MY_TRACKS_TEXT;
    }
    return SAVE_TO_MY_TRACKS_TEXT;
}

- (void) switchSaveTracksText
{
    if ([self.currentTitle isEqualToString:SAVE_TO_MY_TRACKS_TEXT]) {
        [self setTitle:REMOVE_FROM_MY_TRACKS_TEXT forState:UIControlStateNormal];
    } else {
        [self setTitle:SAVE_TO_MY_TRACKS_TEXT forState:UIControlStateNormal];
    }
}


# pragma mark - Actions

- (void) updateMyTracks
{
    [self switchSaveTracksText];
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/update_my_tracks.json", [[[LXSession thisSession] user] ID]] withMethod:@"POST" withParamaters:@{@"track_id": [self.track ID]} authType:@"none" success:^(id responseObject){
        NSMutableArray *myTracks = [[responseObject objectForKey:@"my_tracks"] mutableCopy];
        [[myTracks cleanArray] saveLocalWithKey:@"myTracks"];
    }failure:nil];
}

@end