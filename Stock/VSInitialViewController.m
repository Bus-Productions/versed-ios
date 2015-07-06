//
//  VSInitialViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 7/6/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSInitialViewController.h"

@interface VSInitialViewController ()

@end

@implementation VSInitialViewController

@synthesize pageController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupView
{
    pageController = [[VSOnboardingPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [pageController.view setFrame:self.view.frame];
    
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
}


@end
