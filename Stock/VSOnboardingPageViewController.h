//
//  VSOnboardingPageViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 7/6/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSOnboardingPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) NSUInteger childIndex;

@property (strong, nonatomic) NSArray* quotes;
@property (strong, nonatomic) NSArray* images;

@end
