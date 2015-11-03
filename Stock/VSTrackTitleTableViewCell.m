//
//  VSTrackTitleTableViewCell.m
//  Versed
//
//  Created by Will Schreiber on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSTrackTitleTableViewCell.h"

@implementation VSTrackTitleTableViewCell

@synthesize track;

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
    UIView* baseView = (UIView*) self.contentView;
    
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
    [subTitle setText:[NSString stringWithFormat:@"%@ resources · %@ min · %@", [track numberResources], [track estimatedTime], [track updatedAtFormatted]]];
    [subTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [subTitle setTextColor:[UIColor whiteColor]];
    
    subTitle.layer.shadowColor = [[UIColor blackColor] CGColor];
    subTitle.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    subTitle.layer.shadowRadius = 1.5;
    subTitle.layer.shadowOpacity = 1.0;
    subTitle.layer.masksToBounds = NO;
    
    [baseView setAlpha:[self.track alphaForImage]];
    [headlineImage setAlpha:[self.track alphaForImage]];
}


@end
