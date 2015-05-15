//
//  VSTracksViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSMyTracksViewController.h"
#import "SWRevealViewController.h"

@interface VSMyTracksViewController ()

@end

@implementation VSMyTracksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupSidebar
{
    [self setTitle:@"My Tracks"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}


@end
