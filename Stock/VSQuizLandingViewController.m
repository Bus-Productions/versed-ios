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

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSQuizLandingViewController ()

@end

@implementation VSQuizLandingViewController

@synthesize slideButton, quizQuestions, sections, tableView;

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
        [self.tableView reloadData];
    }failure:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    if (self.quizQuestions.count > 0) {
        [self.sections addObject:@"startQuiz"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"startQuiz"]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"startQuiz"]) {
        return [self tableView:self.tableView startQuizCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView startQuizCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"startQuizCell" forIndexPath:indexPath];
    [cell configureWithText:@"Start Quiz" andColor:[UIColor blueColor]];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"startQuiz"]) {
        if (self.quizQuestions.count > 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            VSQuizQuestionViewController *vc = (VSQuizQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizQuestionViewController"];
            [vc setQuestion:[self.quizQuestions objectAtIndex:questionIndex]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


@end
