//
//  VSQuizViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSQuizQuestionViewController.h"
#import "SWRevealViewController.h"
#import "VSQuizQuestionTableViewCell.h"
#import "VSQuizAnswerTableViewCell.h"
#import "VSButtonTableViewCell.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSQuizQuestionViewController ()

@end

@implementation VSQuizQuestionViewController

@synthesize sections, tableView, question;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Question %d of %d", 1, 10]];
    [self.navigationItem setLeftBarButtonItem:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    if (self.question) {
        [self.sections addObject:@"question"];
        [self.sections addObject:@"answer"];
        [self.sections addObject:@"next"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"question"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"answer"]) {
        return [[self.question questionAnswers] count];
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"next"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"question"]) {
        return [self tableView:self.tableView questionCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answer"]) {
        return [self tableView:self.tableView answerCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"next"]) {
        return [self tableView:self.tableView nextCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView questionCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSQuizQuestionTableViewCell *cell = (VSQuizQuestionTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    [cell configureWithQuestion:self.question];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView answerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSQuizAnswerTableViewCell *cell = (VSQuizAnswerTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
    [cell configureWithAnswer:[[self.question questionAnswers] objectAtIndex:indexPath.row]];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView nextCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = (VSButtonTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"nextCell" forIndexPath:indexPath];
    [cell configureWithText:@"Next" andColor:[UIColor blueColor]];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (alreadyAnswered && [[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answer"]){
        return nil;
    }
    return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answer"]) {
        [self updateViewWithAnswerAtIndexPath:indexPath success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"next"]) {
        alreadyAnswered = NO;
        [self.tableView reloadData];
    }
}


# pragma mark - Helpers

- (NSIndexPath*) indexPathOfCorrectAnswer
{
    for (NSMutableDictionary *answer in [self.question questionAnswers]) {
        if ([[answer ID] isEqualToString:[self.question correctAnswerID]]) {
            return [NSIndexPath indexPathForRow:[[self.question questionAnswers] indexOfObject:answer] inSection:[self.sections indexOfObject:@"answer"]];
        }
    }
    return nil;
}


- (void) updateViewWithAnswerAtIndexPath:(NSIndexPath*)indexPath success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    alreadyAnswered = YES;
    UITableViewCell *correctCell = [self.tableView cellForRowAtIndexPath:[self indexPathOfCorrectAnswer]];
    UITableViewCell *chosenCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [correctCell setBackgroundColor:[UIColor greenColor]];
    if (![chosenCell isEqual:correctCell]) {
        [chosenCell setBackgroundColor:[UIColor grayColor]];
    }

    successCallback(nil);
}

@end
