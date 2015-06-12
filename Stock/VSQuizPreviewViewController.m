//
//  VSQuizPreviewViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/26/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSQuizPreviewViewController.h"

@interface VSQuizPreviewViewController ()

@end

@implementation VSQuizPreviewViewController

@synthesize titleLabel, quiz, delegate;
@synthesize infoLabel, cancelButton, startButton, backgroundImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTextLabels];
    [self setupAppearance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupTextLabels
{
    [self.titleLabel setText:[self.quiz quizName]];
    [self.infoLabel setText:@"This quiz is a pulse check:\nA way to make sure you're up to speed on all the major trends and identify potential knowledge gaps."];
}

- (void) setupAppearance
{
    [self.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:24.0f]];
    [self.infoLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.infoLabel setTextColor:[UIColor whiteColor]];
    
    [[self.cancelButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    [[self.startButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:20.0f]];
}


# pragma mark - Actions

- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takeQuizAction:(id)sender
{
    [self.delegate pushQuestionOnStack];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
