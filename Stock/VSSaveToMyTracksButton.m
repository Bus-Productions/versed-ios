//
//  VSSaveToMyTracksButton.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSSaveToMyTracksButton.h"
@import QuartzCore;

#define SAVE_TO_MY_TRACKS_TEXT @"SAVE TO MY TRACKS"
#define REMOVE_FROM_MY_TRACKS_TEXT @"REMOVE FROM MY TRACKS"

@implementation VSSaveToMyTracksButton

@synthesize myTrackIDs, track;


+ (VSSaveToMyTracksButton*) initWithTrack:(NSMutableDictionary*)t andMyTrackIDs:(NSMutableArray*)ids
{
    VSSaveToMyTracksButton *btn = [[VSSaveToMyTracksButton alloc] init];
    
    btn.myTrackIDs = ids;
    btn.track = t;
    
    [btn setTitle:[btn saveToMyTracksButtonTitle] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[btn titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [btn setShowsTouchWhenHighlighted:YES];
    
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
        NSMutableArray *myTracks = [[(NSArray*)[responseObject objectForKey:@"my_tracks"] cleanArray] mutableCopy];
        [myTracks saveLocalWithKey:@"myTracks"];
    }failure:nil];
}

@end
