//
//  VSQuizLandingViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSQuizLandingViewController.h"
#import "VSQuizQuestionViewController.h"
#import "VSButtonTableViewCell.h"
#import "VSQuizResultsViewController.h"
#import "VSReviewQuizTableViewCell.h"
#import "VSQuizPreviewViewController.h"
#import "VSEmptyTableViewCell.h"
#import "VSDashboardViewController.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSQuizLandingViewController ()

@end

@implementation VSQuizLandingViewController

@synthesize slideButton, quizQuestions, sections, tableView, quizResults, questionsToAsk, quiz, backgroundImageView, totalPoints;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSidebar];
    [self setupAppearance]; 
    [self setupData];
    [self reloadScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    [self.tableView reloadData];
}

# pragma mark - Setup

- (void) setupSidebar
{
    [self setTitle:@"Quiz"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    [revealViewController setDelegate:self];
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void) setupData
{
    self.quizQuestions = [[NSMutableArray alloc] init];
    self.questionsToAsk = [[NSMutableArray alloc] init];
    self.quizResults = [[NSMutableArray alloc] init];
    self.quiz = [[NSMutableDictionary alloc] init];
    self.totalPoints = 0;
    
    NSString *buttonText = self.quizResults.count > 0 ? @"Continue Quiz" : @"Start Quiz";
    UIButton *action = (UIButton*)[self.startQuizView viewWithTag:2];
    [action setTitle:buttonText forState:UIControlStateNormal];
    action.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f];
    
}

- (void) setupAppearance
{
    NSArray *backgroundImages = [NSArray arrayWithObjects:@"quiz_splash.png", @"1.png", @"2.png", @"3.png", nil];
    [self.backgroundImageView setImage:[UIImage imageNamed:[backgroundImages randomArrayItem]]];
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


# pragma mark - Request/Reload
- (void) reloadScreen
{
    isRequesting = YES;
    [[LXServer shared] requestPath:@"/quizzes/live.json" withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        self.quizResults = [[NSMutableArray alloc] init];
        self.totalPoints = 0;
        self.quizQuestions = [[responseObject quiz] objectForKey:@"random_quiz_questions"];
        self.questionsToAsk = [self.quizQuestions mutableCopy];
        self.quiz = [responseObject quiz];
        [self removeAnsweredQuestionsFromQuestionsToAsk];
        isRequesting = NO;
        [self.tableView reloadData];
    }failure:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    if (isRequesting) {
        [self.sections addObject:@"requesting"];
        [self.startQuizView setHidden:YES];
    } else {
        [self.sections addObject:@"explanation"];
        [self.startQuizView setHidden:NO];
    }
//    [self.sections addObject:@"dashboard"];
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"startQuiz"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"showResults"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"requesting"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"explanation"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"dashboard"]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"startQuiz"]) {
        return [self tableView:self.tableView startQuizCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"showResults"]) {
        return [self tableView:self.tableView showResultsCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"requesting"]) {
        return [self tableView:self.tableView requestingCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"explanation"]) {
        return [self tableView:self.tableView explanationCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"dashboard"]) {
        return [self tableView:self.tableView dashboardCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView startQuizCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView showResultsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
    
    UILabel *title = (UILabel*)[cell.contentView viewWithTag:1];
    NSDate *now = [NSDate date];
    [title setText:[NSString stringWithFormat:@"%@ %@", [now formattedDateStringWithFormat:@"MMMM d"], [self.quiz quizName]]];
//    [title setText:@"You've currently answered all the questions!"];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:24.0f]];
    
    UILabel *action = (UILabel*)[cell.contentView viewWithTag:2];
    [action setText:@"Show Results"];
    [action setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView requestingCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"requestingCell" forIndexPath:indexPath];
    [cell configureWithText:@"Requesting quiz data" andBackgroundColor:nil];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView explanationCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"explanationCell" forIndexPath:indexPath];
    UILabel *title = (UILabel*)[cell.contentView viewWithTag:1];
    NSDate *now = [NSDate date];
    [title setText:[NSString stringWithFormat:@"%@ %@", [now formattedDateStringWithFormat:@"MMMM d"], [self.quiz quizName]]];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:24.0f]];
    
    UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:2];
    if (self.quizQuestions && self.quizQuestions.count > 0) {
        [lbl setText:[NSString stringWithFormat:@"This %lu-question quiz is a pulse check on the forces and trends shaping business. You have 20 seconds for each question. Get ready - it's time to test your knowledge!", self.quizQuestions.count]];
    } else if (isRequesting) {
        [lbl setText:@""];
    } else {
        [lbl setText:@"You've already answered every quiz question! Don't worry, we'll continually be adding more questions."];
    }

    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:20.0f]];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView dashboardCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"dashboardCell" forIndexPath:indexPath];
    //[cell configureWithText:@"See Dashboard" andColor:[UIColor greenColor]];
    
    UILabel* perfOv = (UILabel*)[cell.contentView viewWithTag:1];
    [perfOv setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:14.0f]];
    
    UIView* container = (UIView*)[cell.contentView viewWithTag:10];
    
    UILabel* accuracy = (UILabel*)[container viewWithTag:1];
    [accuracy setText:@"LIFETIME\nPOINTS"];
    [accuracy setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:11.0f]];
    
    UILabel* percentage = (UILabel*)[container viewWithTag:2];
    [percentage setText:[[[LXSession thisSession] user] score]];
    [percentage setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:30.0f]];
    
    UILabel* label = (UILabel*)[container viewWithTag:3];
    [label setText:@"View the\nLeaderboard"];
    [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"startQuiz"]) {
        [self pushQuestionOnStack];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"showResults"]) {
        [self pushResultsOnStack];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"dashboard"]) {
        [self pushDashboardOnStack];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"startQuiz"]) {
        return 100.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"showResults"]) {
        return 170.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"requesting"]) {
        return 136.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"dashboard"]) {
        return 350.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"explanation"]) {
        return self.tableView.frame.size.height - self.startQuizView.frame.size.height;
    }
    return 100.0f;
}

# pragma mark - VSCreateQuizResultDelegate

- (void) createQuizResultWithQuestion:(NSMutableDictionary *)question andAnswer:(NSMutableDictionary *)answer success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    NSMutableDictionary *qr = [NSMutableDictionary create:@"quiz_result"];
    [qr setObject:(answer ? [answer ID] : @"-1") forKey:@"quiz_answer_id"];
    [qr setObject:[question ID] forKey:@"quiz_question_id"];
    [qr setObject:[question quizID] forKey:@"quiz_id"];
    [qr setObject:[question quizAnswerID] forKey:@"correct_answer_id"];
    [qr setObject:[[[LXSession thisSession] user] ID] forKey:@"user_id"];
    [self updateTotalPointsWithQuizResult:qr andQuestion:question];
    [self.quizResults addObject:qr];
    [qr saveRemote:^(id responseObject){
        NSUInteger indexOfQuizResult = [self.quizResults indexOfObject:qr];
        [qr setObject:question forKey:@"quiz_question"];
        if (indexOfQuizResult && indexOfQuizResult < self.quizResults.count) {
            [self.quizResults replaceObjectAtIndex:indexOfQuizResult withObject:qr];
        }
        [[LXSession thisSession] setUser:[[[responseObject objectForKey:@"user"] cleanDictionary] mutableCopy]];
        successCallback(@{@"quiz_results": self.quizResults});
    }failure:nil];
}

- (void) updateQuizQuestions
{
    [self.questionsToAsk removeObjectAtIndex:0];
    if (self.questionsToAsk.count > 0) {
        [self pushQuestionOnStack];
    } else {
        [self pushResultsOnStack];
    }
}

- (void) pushQuestionOnStack
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSQuizQuestionViewController *vc = (VSQuizQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizQuestionViewController"];
    [vc setQuestion:[self.questionsToAsk firstObject]];
    [vc setTotalQuestions:[self.quizQuestions count]];
    [vc setQuestionsCompleted:[self.quizResults count] + 1];
    [vc setQuizResults:self.quizResults];
    [vc setDelegate:self];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void) pushResultsOnStack
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSQuizResultsViewController *vc = (VSQuizResultsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizResultsViewController"];
    [vc setQuizResults:self.quizResults];
    [vc setDelegate:self];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void) pushDashboardOnStack
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSDashboardViewController *vc = (VSDashboardViewController*)[storyboard instantiateViewControllerWithIdentifier:@"dashboardViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) updateTotalPointsWithQuizResult:(NSMutableDictionary*)qr andQuestion:(NSMutableDictionary*)question
{
    if ([[qr correctAnswerID] isEqualToString:[qr quizAnswerID]] && ![[question pointsForQuestion] isEqualToString:@"0"]) {
        self.totalPoints = self.totalPoints + 1;
    }
}

- (NSInteger) pointsForRound
{
    return self.totalPoints; 
}

# pragma mark - Helpers

- (void) removeAnsweredQuestionsFromQuestionsToAsk
{
    NSMutableArray *quizQuestionIDs = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *qr in self.quizResults) {
        [quizQuestionIDs addObject:[qr quizQuestionID]];
    }
    for (NSMutableDictionary *qq in self.quizQuestions) {
        if ([quizQuestionIDs containsObject:[NSString stringWithFormat:@"%@", [qq ID]]]) {
            [self.questionsToAsk removeObject:qq];
        }
    }
}



# pragma mark hud delegate

- (void) showHUDWithMessage:(NSString*) message
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
    [hud setColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0]];
    [hud setLabelFont:[UIFont fontWithName:@"SourceSansPro-Light" size:14.0f]];
}

- (void) hideHUD
{
    if (hud) {
        [hud hide:YES];
    }
}


- (IBAction)startQuizAction:(id)sender {
    [self pushQuestionOnStack];
}
@end
