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
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

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
    [subTitle setText:[NSString stringWithFormat:@"%@ resources · %@ minutes · %@", [track numberResources], [track estimatedTime], [track updatedAtFormatted]]];
    [subTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:11.0f]];
    [subTitle setTextColor:[UIColor whiteColor]];
    
    subTitle.layer.shadowColor = [[UIColor blackColor] CGColor];
    subTitle.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    subTitle.layer.shadowRadius = 1.5;
    subTitle.layer.shadowOpacity = 1.0;
    subTitle.layer.masksToBounds = NO;
    
    UILabel* description = (UILabel*)[baseView viewWithTag:4];
    [description setTextColor:[UIColor grayColor]];
    [description setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [description setText:[[track objectForKey:@"editors_note"] truncated:230]];
    
    UIView* bottomView = (UIView*) [self.contentView viewWithTag:55];
    [bottomView setBackgroundColor:[UIColor clearColor]];
    
    UILabel* numberOfPeople = (UILabel*)[bottomView viewWithTag:7];
    [numberOfPeople setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:20.0f]];
    if ([track objectForKey:@"people_discussing"] && [[track objectForKey:@"people_discussing"] count] > 0) {
        //NSLog(@"%@", [track objectForKey:@"completed_in_company"]);
        [numberOfPeople setText:[NSString stringWithFormat:@"%lu", (unsigned long)[[track objectForKey:@"people_discussing"] count]]];
    } else {
        [numberOfPeople setText:@"0"];
    }
    
    [baseView setAlpha:[self.track alphaForImage]];
    [headlineImage setAlpha:[self.track alphaForImage]];
    
    UIView* readView = (UIView*)[baseView viewWithTag:43];
    UILabel* completedLabel = (UILabel*)[readView viewWithTag:44];
    [completedLabel setText:[NSString stringWithFormat:@"Completed on %@", [self.track completionDateFormatted]]];
    [completedLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:15.0f]];
    
    if ([self.track completed]) {
        UIBezierPath *completedViewMaskPath = [UIBezierPath bezierPathWithRoundedRect:readView.bounds
                                                                    byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                                          cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *completedViewMaskLayer = [[CAShapeLayer alloc] init];
        completedViewMaskLayer.frame = self.bounds;
        completedViewMaskLayer.path = completedViewMaskPath.CGPath;
        readView.layer.mask = completedViewMaskLayer;
        [readView setHidden:NO];
        [bottomView setHidden:YES];
        self.bottomViewHeightConstraint.constant = 0; 
    } else {
        UIProgressView *progressBar = (UIProgressView*)[bottomView viewWithTag:66];
        progressBar.progress = ([[track estimatedTime] floatValue] - [[track minutesRemaining] floatValue])/([[track estimatedTime] floatValue] < 1.0 ? 1.0 : [[track estimatedTime] floatValue]);
    
        [self.minutesRemainingInTrackLabel setText:[NSString stringWithFormat:@"%@ minutes remaining", [track minutesRemaining]]];
        [self.minutesRemainingInTrackLabel setFont:[UIFont fontWithName:@"SourceSansPro-LightIt" size:12.0f]];
        [self.minutesRemainingInTrackLabel setTextColor:[UIColor whiteColor]];
        if (progressBar.progress < 0.4) {
            self.minutesRemainingLeadingConstraint.constant = progressBar.progress*progressBar.frame.size.width + 6;
            [self.minutesRemainingInTrackLabel setTextColor:[UIColor grayColor]];
        } else {
            self.minutesRemainingLeadingConstraint.constant = 4;
            [self.minutesRemainingInTrackLabel setTextColor:[UIColor whiteColor]];
        }
        [readView setHidden:YES];
        [bottomView setHidden:NO]; 
        self.bottomViewHeightConstraint.constant = 25;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headlineImage.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(3.0, 3.0)];
    
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
