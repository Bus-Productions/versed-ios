//
//  VSButtonTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

- (void) configureWithText:(NSString*)text andColor:(UIColor*)color;
- (void) configureWithText:(NSString*)text andColor:(UIColor*)color andBorder:(BOOL)border andTextColor:(UIColor*)textColor;

- (CGFloat) configureHeight;
@end
