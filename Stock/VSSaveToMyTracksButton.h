//
//  VSSaveToMyTracksButton.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSSaveToMyTracksButton : UIButton

@property (strong, nonatomic) NSMutableArray *myTrackIDs;
@property (strong, nonatomic) NSMutableDictionary *track;
+ (VSSaveToMyTracksButton*) initWithTrack:(NSMutableDictionary*)t andMyTrackIDs:(NSMutableArray*)ids;
- (void) updateMyTracks;
@end
