//
//  VSEditorsNoteTableViewCell.h
//  Versed
//
//  Created by Joseph Gill on 8/4/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSEditorsNoteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *detailContainerView;
@property (strong, nonatomic) NSMutableDictionary *track;
@property (strong, nonatomic) NSMutableArray *myTrackIDs;

- (void) configure;
- (IBAction)saveToMyTracks:(id)sender;
- (void) contract;
- (void) expand; 
@end
