//
//  VSIntroViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 7/6/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSIntroViewController.h"

@interface VSIntroViewController ()

@end

@implementation VSIntroViewController

@synthesize index;
@synthesize messageLabel;
@synthesize text;
@synthesize backgroundImageView;
@synthesize image;
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAppearance];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.messageLabel setText:self.text];
    [self.messageLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:20.0f]];
    
    if (!self.text || [self.text length] == 0) {
        [self.imageView setHidden:YES];
    } else {
        [self.imageView setHidden:NO];
    }
}

- (void) setupAppearance
{
    [self.backgroundImageView setImage:[UIImage imageNamed:self.image]];
}

- (void) setMessage:(NSString*)message
{
    [self setText:message];
    [self.messageLabel setText:message];
}


@end
