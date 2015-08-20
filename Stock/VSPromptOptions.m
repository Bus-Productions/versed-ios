//
//  VSPromptOptions.m
//  Versed
//
//  Created by Will Schreiber on 7/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPromptOptions.h"

@interface VSPromptOptions ()

@end

@implementation VSPromptOptions

@synthesize topButton;
@synthesize bottomButton;
@synthesize topLabel;
@synthesize bottomLabel;
@synthesize orLabel;


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupViews];
    [self setupAppearance]; 
    
    [self.bottomButton setTitle:@"Get Versed" forState:UIControlStateNormal];
    [self.topButton setTitle:@"Test Your Knowledge" forState:UIControlStateNormal];
    
    [self.bottomLabel setText:@"Go straight to tracks to learn about the trends and forces shaping business."];
    [self.topLabel setText:@"Find out how much you know by taking a quiz about key business topics."];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setupViews
{
    [self.topLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    
    [self.bottomLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    
    [[self.topButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [self.topButton.layer setCornerRadius:4.0f];
    [self.topButton setClipsToBounds:YES];
    
    [[self.bottomButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [self.bottomButton.layer setCornerRadius:4.0f];
    [self.bottomButton setClipsToBounds:YES];
    
    [self.orLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    
    if (self.view.frame.size.height < 500.0) { //4s & iPad
        self.logoToTopConstraint.constant = 0;
    } else if (self.view.frame.size.height < 510.0) { //5s
        self.logoToTopConstraint.constant = 25;
    } else { //6 & 6+
        self.logoToTopConstraint.constant = 60;
        self.logoHeightConstraint.constant = 80;
    }
    NSLog(@"height = %f", self.view.frame.size.height);
    
}

- (void) setupAppearance
{
    NSArray *backgroundImages = [NSArray arrayWithObjects:@"quiz_splash.png", @"1.png", @"2.png", @"3.png", @"4.png", nil];
    [self.backgroundImageView setImage:[UIImage imageNamed:[backgroundImages randomArrayItem]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)topAction:(id)sender
{
    [self closeWindow:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToOption" object:nil userInfo:@{@"to":@"quiz"}];
}


- (IBAction)bottomAction:(id)sender
{
    [self closeWindow:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToOption" object:nil userInfo:@{@"to":@"allTracks"}];
}

- (void) closeWindow:(BOOL)animated
{
    [self dismissViewControllerAnimated:animated completion:^(void){
    }];
}

@end
