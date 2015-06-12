//
//  VSSaveToMyTracksButton.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSSaveToMyTracksButton : UIButton

+ (VSSaveToMyTracksButton*) initWithTrack:(NSMutableDictionary*)t andMyTrackIDs:(NSMutableArray*)ids;

@property (strong, nonatomic) NSMutableArray *myTrackIDs;
@property (strong, nonatomic) NSMutableDictionary *track;

- (void) updateMyTracks;

@end
