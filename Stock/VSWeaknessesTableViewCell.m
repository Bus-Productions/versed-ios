//
//  VSWeaknessesTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 7/14/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSWeaknessesTableViewCell.h"

@implementation VSWeaknessesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithWeakness:(NSMutableDictionary*)weakness
{
    UIView* container = (UIView*)[self.contentView viewWithTag:10];
    
    UILabel *headline = (UILabel*)[container viewWithTag:3];
    [headline setText:[weakness headline]];
    [headline setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:12.0f]];
    [headline setTextColor:[UIColor whiteColor]];
    
    headline.layer.shadowColor = [[UIColor blackColor] CGColor];
    headline.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    headline.layer.shadowRadius = 2.0;
    headline.layer.shadowOpacity = 1.0;
    headline.layer.masksToBounds = NO;
    
    UIImageView* headlineImage = (UIImageView*)[container viewWithTag:2];
    if ([weakness mediaURL]) {
        if ([SGImageCache haveImageForURL:[weakness mediaURL]]) {
            [headlineImage setImage:[SGImageCache imageForURL:[weakness mediaURL]]];
        } else if (![headlineImage.image isEqual:[SGImageCache imageForURL:[weakness mediaURL]]]) {
            headlineImage.image = nil;
            [headlineImage setAlpha:0.0f];
            [SGImageCache getImageForURL:[weakness mediaURL]].then(^(UIImage* image) {
                if (image) {
                    headlineImage.image = image;
                }
                [UIView animateWithDuration:1.0f animations:^(void){
                    [headlineImage setAlpha:1.0f];
                }];
            });
        }
    }
}

@end
