//
//  VSPollsTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPollsTableViewCell.h"

@implementation VSPollsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithPoll:(NSMutableDictionary*)poll andIndexPath:(NSIndexPath*)indexPath
{
    UIView* container = (UIView*)[self.contentView viewWithTag:10];
    UIImageView *backgroundImage = (UIImageView*)[container viewWithTag:43];
    NSMutableDictionary *track = [poll track];
    
    if ([track mediaURL]) {
        if ([SGImageCache haveImageForURL:[track mediaURL]]) {
            [backgroundImage setImage:[SGImageCache imageForURL:[track mediaURL]]];
        } else if (![backgroundImage.image isEqual:[SGImageCache imageForURL:[track mediaURL]]]) {
            backgroundImage.image = nil;
            [backgroundImage setAlpha:0.0f];
            [SGImageCache getImageForURL:[track mediaURL]].then(^(UIImage* image) {
                if (image) {
                    backgroundImage.image = image;
                }
                [UIView animateWithDuration:1.0f animations:^(void){
                    [backgroundImage setAlpha:1.0];
                }];
            });
        }
    }
    
    UILabel *lbl = (UILabel*)[container viewWithTag:1];
    [lbl setText:[NSString stringWithFormat:@"%ld", indexPath.row + 1]];
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:46.0f]];
    [lbl setTextColor:[UIColor whiteColor]];
    
    UILabel *bottomLabel = (UILabel*)[container viewWithTag:2];
    [bottomLabel setText:[[poll objectForKey:@"poll"] pollQuestion]];
    [bottomLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]];
    [bottomLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = (UILabel*)[container viewWithTag:3];
    [titleLabel setText:[track headline]];
    [titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0f]];
    [titleLabel setTextColor:[UIColor whiteColor]];
//    
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:container.bounds
//                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight)
//                                           cornerRadii:CGSizeMake(4.0, 4.0)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    backgroundImage.layer.mask = maskLayer;
    
    container.layer.cornerRadius = 4.0;
    container.layer.shadowColor = [UIColor blackColor].CGColor;
    container.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    container.layer.shadowOpacity = 0.2f;
    container.layer.shadowPath = [UIBezierPath bezierPathWithRect:container.bounds].CGPath;
    
    lbl.layer.shadowColor = [[UIColor blackColor] CGColor];
    lbl.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    lbl.layer.shadowRadius = 4.0;
    lbl.layer.shadowOpacity = 1.0;
    lbl.layer.masksToBounds = NO;
    
    bottomLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    bottomLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    bottomLabel.layer.shadowRadius = 4.0;
    bottomLabel.layer.shadowOpacity = 1.0;
    bottomLabel.layer.masksToBounds = NO;
    
    titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    titleLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    titleLabel.layer.shadowRadius = 4.0;
    titleLabel.layer.shadowOpacity = 1.0;
    titleLabel.layer.masksToBounds = NO;
}
@end
