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
    NSDate *now = [NSDate date];
    [self.titleLabel setText:[NSString stringWithFormat:@"%@ %@", [now formattedDateStringWithFormat:@"MMMM d"], [self.quiz quizName]]];

    [self.infoLabel setText:@"This 10-question quiz is a pulse check on how much you know about the trends and forces shaping business today. Your results will allow Versed to recommended specific tracks for you to focus on.\n\nYou only have 25 seconds for each question. So, get ready.  It’s time to test your knowledge."];
}

- (void) setupAppearance
{
    [self.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:24.0f]];
    [self.infoLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.infoLabel setTextColor:[UIColor whiteColor]];
    
    [[self.cancelButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    [[self.startButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:20.0f]];
    
    NSArray *backgroundImages = [NSArray arrayWithObjects:@"quiz_splash.png", @"1.png", @"2.png", @"3.png", nil];
    [self.backgroundImage setImage:[UIImage imageNamed:[backgroundImages randomArrayItem]]];
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
