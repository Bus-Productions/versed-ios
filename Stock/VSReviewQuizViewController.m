//
//  VSReviewQuizViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 7/14/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSReviewQuizViewController.h"
#import "VSReviewQuizTableViewCell.h"
#import "VSNoMissesQuizTableViewCell.h"
#import "VSMissedQuestionTableViewCell.h"
#import "VSTrackViewController.h"
#import "VSDashboardViewController.h"

@interface VSReviewQuizViewController ()

@end

@implementation VSReviewQuizViewController

@synthesize quizResults, missedQuestions, pointsThatRound;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup
- (void) setupNavigationBar
{
    NSDate *now = [NSDate date];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ Quiz", [now formattedDateStringWithFormat:@"MMMM d"]]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    if (self.quizResults.count > 0) {
        [self.sections addObject:@"reviewQuiz"];
    }
    if (self.missedQuestions.count > 0) {
        [self.sections addObject:@"missedQuestions"];
    } else {
        [self.sections addObject:@"noMisses"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"reviewQuiz"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"missedQuestions"]) {
        return self.missedQuestions.count;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"noMisses"]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"reviewQuiz"]) {
        return [self tableView:self.tableView reviewQuizCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"missedQuestions"]) {
        return [self tableView:self.tableView missedQuestionsCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"noMisses"]) {
        return [self tableView:self.tableView noMissesCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView noMissesCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSNoMissesQuizTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"noMissesCell" forIndexPath:indexPath];
    [cell configure];
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView reviewQuizCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSReviewQuizTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"reviewQuizCell" forIndexPath:indexPath];
    [cell configureWithQuizResults:self.quizResults andPointsThatRound:self.pointsThatRound];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView missedQuestionsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSMissedQuestionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"missedQuestionCell" forIndexPath:indexPath];
    [cell configureWithQuizResult:[self.missedQuestions objectAtIndex:indexPath.row]];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"missedQuestions"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSTrackViewController *vc = (VSTrackViewController*)[storyboard instantiateViewControllerWithIdentifier:@"trackViewController"];
        [vc setTrack:[[[[self.missedQuestions objectAtIndex:indexPath.row] quizQuestion] track] mutableCopy]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"missedQuestions"]) {
        return 100.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"reviewQuiz"]) {
        return 100.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"noMisses"]) {
        return 100.0f;
    }
    return 54.0f;
}

- (void) showLeaderboard:(UIButton*)button
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSDashboardViewController *vc = (VSDashboardViewController*)[storyboard instantiateViewControllerWithIdentifier:@"dashboardViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
