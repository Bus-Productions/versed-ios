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
#import "VSButtonTableViewCell.h"
#import "VSQuizResultsViewController.h"
#import "VSOverallResultsTableViewCell.h"
#import "VSQuizPreviewViewController.h"
#import "VSEmptyTableViewCell.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSQuizLandingViewController ()

@end

@implementation VSQuizLandingViewController

@synthesize slideButton, quizQuestions, sections, tableView, quizResults, questionsToAsk, quiz;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
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
    self.quizQuestions = [[NSMutableArray alloc] init];
    self.questionsToAsk = [[NSMutableArray alloc] init];
    self.quizResults = [[NSMutableArray alloc] init];
    self.quiz = [[NSMutableDictionary alloc] init];
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
    
    if (isRequesting){
        [self.sections addObject:@"requesting"];
    } else if (self.questionsToAsk.count > 0) {
        [self.sections addObject:@"startQuiz"];
    } else {
        [self.sections addObject:@"showResults"];
    }
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
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView startQuizCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
    NSString *labelText = self.quizResults.count > 0 ? @"Continue Quiz" : @"Start Quiz";
    [cell configureWithText:labelText andColor:[UIColor blueColor]];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView showResultsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
    [cell configureWithText:@"Show Results" andColor:[UIColor blueColor]];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView requestingCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"requestingCell" forIndexPath:indexPath];
    [cell configureWithText:@"Requesting quiz data"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"startQuiz"]) {
        [self showQuizPreview];
    }else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"showResults"]) {
        [self pushResultsOnStack];
    }
}


# pragma mark - VSCreateQuizResultDelegate

- (void) createQuizResultWithQuestion:(NSMutableDictionary *)question andAnswer:(NSMutableDictionary *)answer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSMutableDictionary *qr = [NSMutableDictionary create:@"quiz_result"];
        [qr setObject:[answer ID] forKey:@"quiz_answer_id"];
        [qr setObject:[question ID] forKey:@"quiz_question_id"];
        [qr setObject:[question quizID] forKey:@"quiz_id"];
        [qr setObject:[question quizAnswerID] forKey:@"correct_answer_id"];
        [qr setObject:[[[LXSession thisSession] user] ID] forKey:@"user_id"];
        [self.quizResults addObject:qr];
        [qr saveRemote:^(id responseObject){
            [[LXSession thisSession] setUser:[[responseObject objectForKey:@"user"] mutableCopy]];
            [self.tableView reloadData];
        }failure:nil];
    });
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSQuizPreviewViewController *vc = (VSQuizPreviewViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizPreviewViewController"];
    [vc setDelegate:self];
    [vc setQuiz:self.quiz];
    [self.navigationController presentViewController:vc animated:YES completion:nil]; 
}

- (void) pushQuestionOnStack
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSQuizQuestionViewController *vc = (VSQuizQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizQuestionViewController"];
    [vc setQuestion:[self.questionsToAsk firstObject]];
    [vc setTotalQuestions:[self.quizQuestions count]];
    [vc setQuestionsCompleted:[self.quizResults count] + 1];
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

@end
