//
//  VSOnboardingPageViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 7/6/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSOnboardingPageViewController.h"
#import "VSIntroViewController.h"

@interface VSOnboardingPageViewController ()

@end

@implementation VSOnboardingPageViewController

@synthesize childIndex;
@synthesize quotes;
@synthesize images;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.childIndex = 0;
    
    [self setDelegate:self];
    [self setDataSource:self];
    
    UIPageControl *pageControlAppearance = [UIPageControl appearanceWhenContainedIn:[UIPageViewController class], nil];
    pageControlAppearance.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControlAppearance.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0];
    
    quotes = @[
               @"To be successful, you need to understand the external business landscape. \n\nCurrently there's no timely way to build this knowledge. Versed can help.",
               @"Versed solves the information overload problem with expert curated content that will get you up to speed on the forces and trends shaping business today.",
               @""
               ];
    images = @[
               @"1.png",
               @"2.png",
               @"login_warm_background.png"
               ];
    
    [self setViewControllers:@[[self messageControllerWithMessage:[self.quotes firstObject] andIndex:0 andImage:[self.images firstObject]]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(index)]) {
        if ([(VSIntroViewController*)viewController index] > 0) {
            return [self messageControllerWithMessage:[self.quotes objectAtIndex:([(VSIntroViewController*)viewController index]-1)] andIndex:([(VSIntroViewController*)viewController index]-1) andImage:[self.images objectAtIndex:([(VSIntroViewController*)viewController index]-1)]];
        }
    }
    return nil;
}


- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(index)]) {
        if ([(VSIntroViewController*)viewController index] == self.quotes.count-1) {
            return (UINavigationController*)[[UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"mainNavigationController"];
        } else if ([(VSIntroViewController*)viewController index] < self.quotes.count-1) {
            return [self messageControllerWithMessage:[self.quotes objectAtIndex:([(VSIntroViewController*)viewController index]+1)] andIndex:([(VSIntroViewController*)viewController index]+1) andImage:[self.images objectAtIndex:([(VSIntroViewController*)viewController index]+1)]];
        }
    }
    return nil;
}

- (void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if ([[pageViewController.viewControllers firstObject] respondsToSelector:@selector(index)]) {
        [self setChildIndex:[[pageViewController.viewControllers firstObject] index]];
        if ([[pageViewController.viewControllers firstObject] index] == [self.quotes count]-1) {
            [self presentLoginView];
        }
    } else {
        [self setChildIndex:self.quotes.count];
    }
}

- (void) presentLoginView
{
    [self presentViewController:(UINavigationController*)[[UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"mainNavigationController"] animated:NO completion:nil];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.quotes count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return [self childIndex];
}


- (VSIntroViewController*) messageControllerWithMessage:(NSString*)message andIndex:(NSUInteger)index andImage:(NSString*)image
{
    VSIntroViewController* controller = (VSIntroViewController*)[[UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"introViewController"];
    
    [controller setMessage:message];
    [controller setImage:image];
    [controller setIndex:index];
    
    return controller;
}

@end
