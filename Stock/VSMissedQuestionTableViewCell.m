//
//  VSMissedQuestionTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/21/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSMissedQuestionTableViewCell.h"

@implementation VSMissedQuestionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithQuizResult:(NSMutableDictionary*)quizResult
{
    UIView* container = (UIView*)[self.contentView viewWithTag:10];
    
    NSDictionary* track = [[quizResult quizQuestion] track];
    
    UILabel *questionMissed = (UILabel*)[container viewWithTag:1];
    [questionMissed setText:[NSString stringWithFormat:@"You missed: \"%@\"", [[quizResult quizQuestion] questionText]]];
    [questionMissed setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [questionMissed setTextColor:[UIColor grayColor]];
    
    UILabel *headline = (UILabel*)[container viewWithTag:3];
    [headline setText:[[[quizResult quizQuestion] track] headline]];
    [headline setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:12.0f]];
    [headline setTextColor:[UIColor whiteColor]];
    
    headline.layer.shadowColor = [[UIColor blackColor] CGColor];
    headline.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    headline.layer.shadowRadius = 2.0;
    headline.layer.shadowOpacity = 1.0;
    headline.layer.masksToBounds = NO;
    
    UIImageView* headlineImage = (UIImageView*)[container viewWithTag:2];
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
                    [headlineImage setAlpha:1.0f];
                }];
            });
        }
    }
}

@end
