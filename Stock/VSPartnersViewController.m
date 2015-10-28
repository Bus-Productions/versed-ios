//
//  VSPartnersViewController.m
//  Versed
//
//  Created by Joseph Gill on 10/28/15.
//  Copyright © 2015 LXV. All rights reserved.
//

#import "VSPartnersViewController.h"

@interface VSPartnersViewController ()

@end

@implementation VSPartnersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self setupText];
    [self setupBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupSidebar
{
    [self setTitle:@"Partners"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    [revealViewController setDelegate:self];
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void) setupText
{
    UIFont* titleFont;
    UIFont* linkFont;
    UIFont* disclaimerFont;
    if ([[UIScreen mainScreen] bounds].size.height < 500.0) { //4s & iPad
        titleFont = [UIFont fontWithName:@"Times New Roman" size:15.0f];
        linkFont = [UIFont fontWithName:@"SourceSansPro-Light" size:14.0f];
        disclaimerFont = [UIFont fontWithName:@"SourceSansPro-ExtraLightIt" size:9.0f];
    } else if ([[UIScreen mainScreen] bounds].size.height < 570.0) { //5s
        titleFont = [UIFont fontWithName:@"Times New Roman" size:16.0f];
        linkFont = [UIFont fontWithName:@"SourceSansPro-Light" size:15.0f];
        disclaimerFont = [UIFont fontWithName:@"SourceSansPro-ExtraLightIt" size:10.0f];
    } else { //6 & 6+
        titleFont = [UIFont fontWithName:@"Times New Roman" size:18.0f];
        linkFont = [UIFont fontWithName:@"SourceSansPro-Light" size:19.0f];
        disclaimerFont = [UIFont fontWithName:@"SourceSansPro-ExtraLightIt" size:14.0f];
    }
    
    
    [self.companyTitleLabel setText:@"FINANCIAL TIMES"];
    [self.linkLabel setText:@"Visit http://ftcorporate.ft.com/ to claim a one month free trial to FT.com for your organization"];
    
    [self.disclaimerLabel setText:@"Articles sourced from the Financial Times have been referenced and are used under license from the Financial Times. These articles remain the Copyright of the Financial Times Limited. All Rights Reserved. FT and 'Financial Times' are trademarks of The Financial Times Ltd. The learning resources contained herein were prepared by Versed, Inc.. The Financial Times Limited has not endorsed, verified or been involved in the creation of these learning resources, and is not responsible or liable for their accuracy, completeness or content."];
    [self.linkLabel setFont:linkFont];
    [self.linkLabel boldSubstring:@"http://ftcorporate.ft.com/"];
    [self.companyTitleLabel setFont:titleFont];
    [self.disclaimerLabel setFont:disclaimerFont];
}

- (void) setupBottomView
{
    [self.bottomView setBackgroundColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0]]; 
}

#pragma mark - SWRevealViewController Delegate Methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}
@end
