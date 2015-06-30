//
//  VSResourceTableViewCell.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSResourceTableViewCell.h"

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
    [subtitle setText:[[NSString stringWithFormat:@"%@ · %@ · %@", [resource objectForKey:@"source"], [[NSDate dateFromString:[resource createdAt]] timeAgoActual], [resource resourceType]] uppercaseString]];
    [subtitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [subtitle setTextColor:[UIColor grayColor]];
    
    UILabel* descriptionLabel = (UILabel*)[baseView viewWithTag:3];
    [descriptionLabel setText:[resource objectForKey:@"description"]];
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


//    if ([completedResources containsObject:resource] || [completedResources containsObject:[resource ID]]) {
//        //[lbl setText:[NSString stringWithFormat:@"%@ %@", [resource objectForKey:@"headline"], @"(completed)"]];
//        [lbl setText:[resource objectForKey:@"headline"]];
//    } else {
//        [lbl setText:[resource objectForKey:@"headline"]];
//    }