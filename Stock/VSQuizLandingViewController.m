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
#import "VSOverallResultsTableViewCell.h"
#import "VSQuizPreviewViewController.h"
#import "VSEmptyTableViewCell.h"
#import "VSDashboardViewController.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSQuizLandingViewController ()

@end

@implementation VSQuizLandingViewController

@synthesize slideButton, quizQuestions, sections, tableView, quizResults, questionsToAsk, quiz;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSidebar];
    [self setupData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self reloadScreen];
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
        self.quizQuestions = [[responseObject quiz] quizQuestions];
        self.quizResults = [responseObject quizResults];
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
    } else if (self.questionsToAsk.count > 0) {
        [self.sections addObject:@"startQuiz"];
    } else {
        [self.sections addObject:@"showResults"];
    }
    
    [self.sections addObject:@"dashboard"];
    
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
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"dashboard"]) {
        return [self tableView:self.tableView dashboardCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView startQuizCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
    NSString *labelText = self.quizResults.count > 0 ? @"Continue Quiz" : @"Start Quiz";
    
    UILabel *title = (UILabel*)[cell.contentView viewWithTag:1];
    [title setText:[self.quiz quizName]];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:24.0f]];
    
    UILabel *action = (UILabel*)[cell.contentView viewWithTag:2];
    [action setText:labelText];
    [action setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView showResultsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
    
    UILabel *title = (UILabel*)[cell.contentView viewWithTag:1];
    [title setText:[self.quiz quizName]];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:24.0f]];
    
    UILabel *action = (UILabel*)[cell.contentView viewWithTag:2];
    [action setText:@"Show Results"];
    [action setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView requestingCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"requestingCell" forIndexPath:indexPath];
    [cell configureWithText:@"Requesting quiz data"];
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
    [accuracy setText:@"LIFETIME\nQUIZ ACCURACY"];
    [accuracy setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:11.0f]];
    
    UILabel* percentage = (UILabel*)[container viewWithTag:2];
    [percentage setText:[NSString stringWithFormat:@"%li%%", (long)[[[[LXSession thisSession] user] objectForKey:@"quiz_percentage"] integerValue]]];
    [percentage setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:30.0f]];
    
    UILabel* label = (UILabel*)[container viewWithTag:3];
    [label setText:@"View the\nLeaderboard"];
    [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]];
    
    
    
    UILabel* strengthsLabel = (UILabel*)[cell.contentView viewWithTag:20];
    [strengthsLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [strengthsLabel setText:@"STRENGTHS"];
    
    UILabel* weaknessesLabel = (UILabel*)[cell.contentView viewWithTag:21];
    [weaknessesLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [weaknessesLabel setText:@"DEVELOPMENT AREAS"];
    
    UILabel* strengths = (UILabel*)[cell.contentView viewWithTag:30];
    [strengths setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:14.0f]];
    if ([[[LXSession thisSession] user] strengths] && [[[[LXSession thisSession] user] strengths] count] > 0) {
        NSString* str = @"";
        for (NSString* s in [[[LXSession thisSession] user] strengths]) {
            str = [NSString stringWithFormat:@"%@%@\n", str, s];
        }
        [strengths setText:str];
    } else {
        [strengths setText:@"None, yet."];
    }
    
    UILabel* weaknesses = (UILabel*)[cell.contentView viewWithTag:31];
    [weaknesses setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:14.0f]];
    if ([[[LXSession thisSession] user] weaknesses] && [[[[LXSession thisSession] user] weaknesses] count] > 0) {
        NSString* str = @"";
        for (NSString* s in [[[LXSession thisSession] user] weaknesses]) {
            str = [NSString stringWithFormat:@"%@%@\n", str, s];
        }
        [weaknesses setHidden:NO];
        [weaknessesLabel setHidden:NO];
        [weaknesses setText:str];
    } else {
        [weaknesses setText:@"None, yet."];
        [weaknesses setHidden:YES];
        [weaknessesLabel setHidden:YES];
    }
    
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"startQuiz"]) {
        [self showQuizPreview];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"showResults"]) {
        [self pushResultsOnStack];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"dashboard"]) {
        [self pushDashboardOnStack];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"startQuiz"]) {
        return 170.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"showResults"]) {
        return 170.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"requesting"]) {
        return 136.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"dashboard"]) {
        return 350.0f;
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
    [self.quizResults addObject:qr];
    [qr saveRemote:^(id responseObject){
        [[LXSession thisSession] setUser:[[[responseObject objectForKey:@"user"] cleanDictionary] mutableCopy]];
        self.quizResults = [[[responseObject objectForKey:@"quiz_results"] cleanArray] mutableCopy];
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

- (void) showQuizPreview
{
    [self showHUDWithMessage:@"Loading Quiz..."];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSQuizPreviewViewController *vc = (VSQuizPreviewViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizPreviewViewController"];
    [vc setDelegate:self];
    [vc setQuiz:self.quiz];
    [self.navigationController presentViewController:vc animated:YES completion:^(void){
        [self hideHUD];
    }];
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) pushResultsOnStack
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSQuizResultsViewController *vc = (VSQuizResultsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizResultsViewController"];
    [vc setQuizResults:self.quizResults];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) pushDashboardOnStack
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSDashboardViewController *vc = (VSDashboardViewController*)[storyboard instantiateViewControllerWithIdentifier:@"dashboardViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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


@end
