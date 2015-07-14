//
//  VSQuizResultsViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/20/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSQuizResultsViewController.h"
#import "VSOverallResultsTableViewCell.h"
#import "VSMissedQuestionTableViewCell.h"
#import "VSNoMissesQuizTableViewCell.h"
#import "VSTrackViewController.h"
#import "VSEmptyTableViewCell.h"
#import "VSDashboardViewController.h"

@interface VSQuizResultsViewController ()

@end

@implementation VSQuizResultsViewController

@synthesize quizResults, tableView, sections, missedQuestions;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupData];
    [self.delegate reloadScreen];
    [self updateUserWithFinishedQuiz];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup
- (void) setupData
{
    self.missedQuestions = [[NSMutableArray alloc] init];
    [self setupMissedQuestions:^(id responseObject){
        [self.tableView reloadData];
    }failure:nil];
}

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:@"Quiz Results"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    [self.sections addObject:@"wellDone"];
    
    [self.sections addObject:@"showResults"];
    
    if (self.missedQuestions.count > 0 && self.quizResults.count > 0) {
        [self.sections addObject:@"missedQuestions"];
    } else if (isRequesting) {
        [self.sections addObject:@"empty"];
    } else if (self.quizResults.count > 0) {
        [self.sections addObject:@"noMisses"];
    }
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"showResults"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"missedQuestions"]) {
        return self.missedQuestions.count;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"noMisses"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"wellDone"]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"showResults"]) {
        return [self tableView:self.tableView showResultsCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"missedQuestions"]) {
        return [self tableView:self.tableView missedQuestionsCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"noMisses"]) {
        return [self tableView:self.tableView noMissesCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return [self tableView:self.tableView emptyCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"wellDone"]) {
        return [self tableView:self.tableView wellDoneCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView showResultsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSOverallResultsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"overallResultsCell" forIndexPath:indexPath];
    [cell configureWithQuizResults:self.quizResults];
    
    UIButton* button = (UIButton*)[cell.contentView viewWithTag:5];
    [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [button addTarget:self action:@selector(showLeaderboard:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView missedQuestionsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSMissedQuestionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"missedQuestionCell" forIndexPath:indexPath];
    [cell configureWithQuizResult:[self.missedQuestions objectAtIndex:indexPath.row]];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView noMissesCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSNoMissesQuizTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"noMissesCell" forIndexPath:indexPath];
    [cell configure];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    [cell configureWithText:@"Fetching results"];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView wellDoneCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"wellDoneCell" forIndexPath:indexPath];
    
    UILabel* topLabel = (UILabel*)[cell.contentView viewWithTag:1];
    NSString *topLabelText = [NSString stringWithFormat:@"Well done, %@!", [[[LXSession thisSession] user] firstName]];
    NSString *bottomLabelText = [NSString stringWithFormat:@"You are steadily getting versed on key topics."];
    
    if ([self.quizResults numberQuizResultsCorrect]/(self.quizResults && self.quizResults.count > 0 ? self.quizResults.count : 0) <= 0.5) {
        topLabelText = [NSString stringWithFormat:@"Keep practicing, %@!", [[[LXSession thisSession] user] firstName]];
        bottomLabelText = [NSString stringWithFormat:@"With a little more reading, you can get a solid grasp on these topics."];
    }
    [topLabel setText:topLabelText];
    [topLabel setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:28.0f]];
    [topLabel setTextColor:[UIColor whiteColor]];
    
    UILabel* bottomLabel = (UILabel*)[cell.contentView viewWithTag:2];
    [bottomLabel setText:bottomLabelText];
    [bottomLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:22.0f]];
    [bottomLabel setTextColor:[UIColor whiteColor]];
    
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
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"showResults"]) {
        return 170.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"missedQuestions"]) {
        return 100.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"noMisses"]) {

    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {

    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"wellDone"]) {
        return 190.0f;
    }
    return 54.0f;
}

- (void) updateUserWithFinishedQuiz
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSMutableDictionary *user = [[LXSession thisSession] user];
        [user incrementQuizzesTaken];
        [user removeObjectForKey:@"password"];
        [user removeObjectForKey:@"password_confirmation"];
        [user saveBoth:nil failure:nil];
    });
}


# pragma mark - Helpers

- (void) showLeaderboard:(UIButton*)sender
{
    [self pushDashboardOnStack];
}

- (void) pushDashboardOnStack
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSDashboardViewController *vc = (VSDashboardViewController*)[storyboard instantiateViewControllerWithIdentifier:@"dashboardViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) setupMissedQuestions:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    for (NSMutableDictionary *qr in self.quizResults) {
        if (![qr quizResultIsCorrect]) {
            [self.missedQuestions addObject:qr];
        }
    }
}

@end
