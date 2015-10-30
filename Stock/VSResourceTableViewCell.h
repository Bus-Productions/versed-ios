//
//  VSResourceTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSResourceTableViewCell : UITableViewCell

@property (strong, nonatomic) NSMutableDictionary* resource;

- (void) configureWithResource:r andCompletedResources:completedResources;

- (CGFloat) heightForText:(NSString*)text width:(CGFloat)width font:(UIFont*)font;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLabelHeightConstraint;

@end
