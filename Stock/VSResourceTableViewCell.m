//
//  VSResourceTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSResourceTableViewCell.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation VSResourceTableViewCell

@synthesize resource;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithResource:r andCompletedResources:completedResources
{
    [self setResource:r];
        
    UIView* baseView = (UIView*)[self.contentView viewWithTag:10];
    
    UILabel* title = (UILabel*)[baseView viewWithTag:1];
    [title setText:[resource objectForKey:@"headline"]];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    
    UILabel* subtitle = (UILabel*)[baseView viewWithTag:2];
    [subtitle setText:[NSString stringWithFormat:@"%@ · %@ · %@ · %@ min", [resource objectForKey:@"source"], [resource resourceDate], [resource resourceType], [resource estimatedTime]]];
    [subtitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [subtitle setTextColor:[UIColor grayColor]];
    
    UILabel* descriptionLabel = (UILabel*)[baseView viewWithTag:3];
    [descriptionLabel setText:[NSString stringWithFormat:@"%@ %@", [resource objectForKey:@"description"], NULL_TO_NIL([resource objectForKey:@"paywall"]) && [[resource objectForKey:@"paywall"] boolValue] == YES ? [resource objectForKey:@"paywall"] : @""]];
    [descriptionLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]];
    [descriptionLabel setTextColor:[UIColor grayColor]];
    
    UILabel* horizontalLineLabel = (UILabel*)[baseView viewWithTag:99];
    
    UIImageView* sourceView = (UIImageView*)[baseView viewWithTag:82];
    
    if ([completedResources containsObject:[resource ID]]) {
        [horizontalLineLabel setHidden:YES];
        [sourceView setImage:[UIImage imageNamed:@"checkmark_gray.png"]];
        [baseView setBackgroundColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:0.3]];
        [title setTextColor:[UIColor grayColor]];
        baseView.layer.shadowPath = nil;
        [descriptionLabel setHidden:YES];
        self.descriptionLabelHeightConstraint.constant = 0;
    } else {
        [horizontalLineLabel setHidden:NO]; 
        [baseView setBackgroundColor:[UIColor whiteColor]];
        if ([resource mediaURL]) {
            if ([SGImageCache haveImageForURL:[resource mediaURL]]) {
                [sourceView setImage:[SGImageCache imageForURL:[resource mediaURL]]];
            } else if (![sourceView.image isEqual:[SGImageCache imageForURL:[resource mediaURL]]]) {
                sourceView.image = nil;
                [sourceView setAlpha:0.0f];
                [SGImageCache getImageForURL:[resource mediaURL]].then(^(UIImage* image) {
                    if (image) {
                        sourceView.image = image;
                    }
                    [UIView animateWithDuration:1.0f animations:^(void){
                        [sourceView setAlpha:1.0f];
                    }];
                });
            }
        }
        [descriptionLabel setHidden:NO];
        [title setTextColor:[UIColor blackColor]];
        self.descriptionLabelHeightConstraint.constant = [self heightForText:[self.resource description] width:baseView.frame.size.width-30.0f font:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]];
        [sourceView setAlpha:1.0f];
        baseView.layer.cornerRadius = 4.0;
        baseView.layer.shadowColor = [UIColor blackColor].CGColor;
        baseView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        baseView.layer.shadowOpacity = 0.2f;
        baseView.layer.shadowPath = [UIBezierPath bezierPathWithRect:baseView.bounds].CGPath;
    }
}


- (CGFloat) heightForText:(NSString*)text width:(CGFloat)width font:(UIFont*)font
{
    if (!text || [text length] == 0) {
        return 0.0f;
    }
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 100000)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size.height;
}



@end
