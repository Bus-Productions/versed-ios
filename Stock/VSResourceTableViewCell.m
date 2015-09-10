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
    [subtitle setText:[[NSString stringWithFormat:@"%@ · %@ · %@", [resource objectForKey:@"source"], [resource resourceDate], [resource resourceType]] uppercaseString]];
    [subtitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [subtitle setTextColor:[UIColor grayColor]];
    
    UILabel* descriptionLabel = (UILabel*)[baseView viewWithTag:3];
    NSLog(@"paywall = %@", [resource objectForKey:@"paywall"]);
    NSLog(@"class = %@", [[resource objectForKey:@"paywall"] class]);
    [descriptionLabel setText:[NSString stringWithFormat:@"%@ %@", [resource objectForKey:@"description"], NULL_TO_NIL([resource objectForKey:@"paywall"]) && [[resource objectForKey:@"paywall"] boolValue] == YES ? [resource objectForKey:@"paywall"] : @""]];
    [descriptionLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]];
    [descriptionLabel setTextColor:[UIColor grayColor]];
    
    UIImageView* sourceView = (UIImageView*)[baseView viewWithTag:82];
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
    
    UIImageView* readImage = (UIImageView*) [baseView viewWithTag:83];
    [readImage setImage:[UIImage imageNamed:@"green_check.png"]];
    if ([completedResources containsObject:[resource ID]]) {
        [readImage setHidden:NO];
        [baseView setAlpha:0.7f];
        [sourceView setAlpha:0.7f];
    } else {
        [readImage setHidden:YES];
        [baseView setAlpha:1.0f];
        [sourceView setAlpha:1.0f];
    }
    
    baseView.layer.cornerRadius = 4.0;
    baseView.layer.shadowColor = [UIColor blackColor].CGColor;
    baseView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    baseView.layer.shadowOpacity = 0.2f;
    baseView.layer.shadowPath = [UIBezierPath bezierPathWithRect:baseView.bounds].CGPath;
}


+ (CGFloat) heightForText:(NSString*)text width:(CGFloat)width font:(UIFont*)font
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

- (CGFloat) heightForRow
{
    UILabel* title = (UILabel*)[(UIView*)[self.contentView viewWithTag:10] viewWithTag:1];
    return [VSResourceTableViewCell heightForText:[self.resource headline] width:title.frame.size.width font:title.font] + 100.0f;
}


@end
