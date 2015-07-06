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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
}

- (void)didReceiveMemoryWarning {
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
    if ([self.text containsString:@"top issues shaping business today."]) {
        [self.messageLabel boldSubstring:@"top issues shaping business today."];
    } else if ([self.text containsString:@"too much time to find good content."]) {
        [self.messageLabel boldSubstring:@"too much time to find good content."];
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
