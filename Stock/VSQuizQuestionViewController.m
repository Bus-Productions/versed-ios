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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSLog(@"1");
    VSQuizQuestionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
            NSLog(@"2");
    [cell configureWithQuestion:self.question];
            NSLog(@"3");
    NSLog(@"cell = %@", cell);
        NSLog(@"cell class = %@", [cell class]);
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView answerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            NSLog(@"4");
    VSQuizAnswerTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
            NSLog(@"5");
    [cell configureWithAnswer:[[self.question questionAnswers] objectAtIndex:indexPath.row]];
            NSLog(@"6");
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView nextCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            NSLog(@"7");
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"nextCell" forIndexPath:indexPath];
            NSLog(@"8");
    [cell configureWithText:@"Next" andColor:[UIColor blueColor]];
            NSLog(@"9");
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
    }
}


# pragma mark - Helpers

- (BOOL) answerAtIndexPathIsCorrect:(NSIndexPath*)indexPath
{
    return [[self.question correctAnswerID] isEqualToString:[[[self.question questionAnswers] objectAtIndex:indexPath.row] ID]];
}

- (void) updateViewWithAnswerAtIndexPath:(NSIndexPath*)indexPath success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    alreadyAnswered = YES;
    for (int i=0; i < [[self.question questionAnswers] count]; i++) {
        if ([self answerAtIndexPathIsCorrect:indexPath]) {
            NSLog(@"correct was = %ld", (long)indexPath.row);
        } else if (indexPath.row == i) {
            NSLog(@"missed it");
        }
    }
    successCallback(nil);
}

@end
