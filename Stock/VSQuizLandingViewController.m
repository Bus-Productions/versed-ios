//
//  VSQuizLandingViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSQuizLandingViewController.h"
#import "SWRevealViewController.h"
#import "VSQuizQuestionViewController.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSQuizLandingViewController ()

@end

@implementation VSQuizLandingViewController

@synthesize slideButton, quizQuestions;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self setupData];
    [self reloadScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupSidebar
{
    [self setTitle:@"Quiz"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}


# pragma mark - Setup
- (void) setupData
{
    questionIndex = 0;
    self.quizQuestions = [[NSMutableArray alloc] init];
}


# pragma mark - Request/Reload
- (void) reloadScreen
{
    [[LXServer shared] requestPath:@"/quizzes/live.json" withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        self.quizQuestions = [[responseObject quiz] quizQuestions];
    }failure:nil];
}


# pragma mark - Actions

- (IBAction)startQuiz:(id)sender {
    if (self.quizQuestions.count > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSQuizQuestionViewController *vc = (VSQuizQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizQuestionViewController"];
        [vc setQuestion:[self.quizQuestions objectAtIndex:questionIndex]];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
@end
