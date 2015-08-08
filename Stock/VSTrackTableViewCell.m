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

@synthesize track;
@synthesize saveButton;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithTrack:(NSMutableDictionary*)t andIndexPath:(NSIndexPath*)indexPath
{
    [self setTrack:t];
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
                    [headlineImage setAlpha:[self.track alphaForImage]];
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
    [subTitle setText:[NSString stringWithFormat:@"%@ resources · %@", [track numberResources], [track estimatedTime]]];
    [subTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:15.0f]];
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
    
    UILabel* numberOfPeople = (UILabel*)[baseView viewWithTag:7];
    [numberOfPeople setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:12.0f]];
    if ([track objectForKey:@"people_discussing"] && [[track objectForKey:@"people_discussing"] count] > 0) {
        //NSLog(@"%@", [track objectForKey:@"completed_in_company"]);
        [numberOfPeople setText:[NSString stringWithFormat:@"%lu", (unsigned long)[[track objectForKey:@"people_discussing"] count]]];
    } else {
        [numberOfPeople setText:@"0"];
    }
    
    self.saveButton = (UIButton*)[baseView viewWithTag:5];
    [self.saveButton setTitle:[self saveToMyTracksButtonTitle] forState:UIControlStateNormal];
    [self.saveButton setBackgroundColor:[UIColor colorWithRed:0.925f green:0.925f blue:0.925f alpha:1.0f]];
    [self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[self.saveButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]];
    
    [baseView setAlpha:[self.track alphaForImage]];
    [headlineImage setAlpha:[self.track alphaForImage]];
    
    UIImageView* readView = (UIImageView*)[baseView viewWithTag:43];
    if ([self.track completed]) {
        [readView setHidden:NO];
    } else {
        [readView setHidden:YES];
    }
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:headlineImage.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    headlineImage.layer.mask = maskLayer;

    baseView.layer.cornerRadius = 4.0; 
    baseView.layer.shadowColor = [UIColor blackColor].CGColor;
    baseView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    baseView.layer.shadowOpacity = 0.2f;
    baseView.layer.shadowPath = [UIBezierPath bezierPathWithRect:baseView.bounds].CGPath;

}


# pragma mark actions

- (IBAction)saveTrackAction:(id)sender
{
    [self switchSaveToTracksText:(UIButton*)sender];
    [self updateMyTrack];
}

- (IBAction)showDiscussionAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showDiscussion" object:nil userInfo:@{@"track": self.track}];
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

@end
