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

@synthesize sections, tableView, question, delegate, totalQuestions, questionsCompleted, quizResults;
@synthesize nextButton, nextContainer, nextContainerHeightConstraint;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupTimer];
    
    [self showOrHideNextBar];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showOrHideNextBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [timer invalidate];
}

# pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Question %lu of %lu", (unsigned long)questionsCompleted, (unsigned long)totalQuestions]];
}

- (void) setupTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector:@selector(onTick:)
                                                userInfo: nil repeats:YES];
    remainingTime = 25;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    if (self.question) {
        [self.sections addObject:@"header"];
        [self.sections addObject:@"question"];
        [self.sections addObject:@"answer"];
        //if (alreadyAnswered) {
            //[self.sections addObject:@"next"];
        //}
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
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"header"]) {
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
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return [self tableView:self.tableView headerCellForRowAtIndexPath:indexPath];
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
    [cell configureWithText:@"Next" andColor:nil];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView headerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
    
    UILabel* timerLabel = (UILabel*)[cell.contentView viewWithTag:1];
    [timerLabel setText:[NSString stringWithFormat:@"00:%@", remainingTime > 9 ? [NSString stringWithFormat:@"%d", remainingTime] : [NSString stringWithFormat:@"0%d",remainingTime]]];
    
    UILabel* pointsLabel = (UILabel*)[cell.contentView viewWithTag:2];
    [pointsLabel setText:[NSString stringWithFormat:@"+%@", [self.question seen]]];
    
    UILabel* questionLabel = (UILabel*)[cell.contentView viewWithTag:3];
    [questionLabel setText:[NSString stringWithFormat:@"%lu/%lu",  (unsigned long)self.questionsCompleted, (unsigned long)self.totalQuestions]];

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (alreadyAnswered && [[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answer"]){
        return nil;
    } else if (!alreadyAnswered && [[self.sections objectAtIndex:indexPath.section] isEqualToString:@"next"]) {
        return nil;
    }
    return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answer"]) {
        requesting = YES;
        [self updateViewWithAnswerAtIndexPath:indexPath success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
        [self.delegate createQuizResultWithQuestion:self.question andAnswer:[[self.question questionAnswers] objectAtIndex:indexPath.row] success:^(id responseObject){
            requesting = NO;
            self.quizResults = [responseObject objectForKey:@"quiz_results"];
            [self.tableView reloadData];
        } failure:nil];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"next"]) {
        [self.delegate updateQuizQuestions]; 
    }
}

- (IBAction)nextAction:(id)sender
{
    [self.delegate updateQuizQuestions];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return self.view.frame.size.width/1080.0f*420.0f + 37.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answer"]) {
        return 44.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"next"]) {
        return 62.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"question"]) {
        return 40.0f + [self heightForText:[self.question questionText] width:(self.view.frame.size.width-32.0f) font:[UIFont fontWithName:@"SourceSansPro-Light" size:16.0f]];
    }
    return 100.0f;
}

- (CGFloat) heightForText:(NSString*)text width:(CGFloat)width font:(UIFont*)font
{
    if (!text || [text length] == 0) {
        return 0.0f;
    }
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 100000)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size.height;
}


# pragma mark - Helpers

- (NSIndexPath*) indexPathOfCorrectAnswer
{
    for (NSMutableDictionary *answer in [self.question questionAnswers]) {
        if ([[NSString stringWithFormat:@"%@", [answer ID]] isEqualToString:[self.question quizAnswerID]]) {
            return [NSIndexPath indexPathForRow:[[self.question questionAnswers] indexOfObject:answer] inSection:[self.sections indexOfObject:@"answer"]];
        }
    }
    return nil;
}


- (void) updateViewWithAnswerAtIndexPath:(NSIndexPath*)indexPath success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    alreadyAnswered = YES;
    UITableViewCell *correctCell = [self.tableView cellForRowAtIndexPath:[self indexPathOfCorrectAnswer]];
    UITableViewCell *chosenCell;
    if (NULL_TO_NIL(indexPath)) {
        chosenCell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (![chosenCell isEqual:correctCell]) {
            [[chosenCell.contentView viewWithTag:1] setBackgroundColor:[UIColor grayColor]];
            [(UILabel*)[chosenCell.contentView viewWithTag:1] setTextColor:[UIColor blackColor]];
        }
    } else {
        [self showAlertWithText:@"You ran out of time!"];
    }
    [[correctCell.contentView viewWithTag:1] setBackgroundColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0]];

    successCallback(nil);
    
    [self showOrHideNextBar];
}

- (NSIndexPath*) questionIndexPath
{
    NSInteger questionSectionIndex = [self.sections indexOfObject:@"question"];
    NSInteger firstRowIndex = 0;
    return [NSIndexPath indexPathForRow:firstRowIndex inSection:questionSectionIndex];
}

- (NSIndexPath*) timerIndexPath
{
    NSInteger questionSectionIndex = [self.sections indexOfObject:@"header"];
    NSInteger firstRowIndex = 0;
    return [NSIndexPath indexPathForRow:firstRowIndex inSection:questionSectionIndex];
}



- (void) showOrHideNextBar
{
    if (alreadyAnswered) {
        self.nextContainerHeightConstraint.constant = 56;
    } else {
        self.nextContainerHeightConstraint.constant = 0;
    }
}



# pragma mark - Timer

-(void) onTick:(id)sender
{
    if (alreadyAnswered) {
        [timer invalidate];
    } else if (remainingTime <= 0) {
        requesting = YES;
        [self updateViewWithAnswerAtIndexPath:nil success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
        [self.delegate createQuizResultWithQuestion:self.question andAnswer:nil success:^(id responseObject){
            self.quizResults = [responseObject objectForKey:@"quiz_results"];
            requesting = NO; 
            [self.tableView reloadData];
        } failure:nil];
        [timer invalidate];
    } else {
        remainingTime = remainingTime - 1;
        UITableViewCell *cell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:[self timerIndexPath]];
        UILabel *timerLabel = (UILabel*)[cell.contentView viewWithTag:1];
        [timerLabel setText:[NSString stringWithFormat:@"00:%@", remainingTime > 9 ? [NSString stringWithFormat:@"%d", remainingTime] : [NSString stringWithFormat:@"0%d",remainingTime]]];
    }
}


# pragma mark - Alert

- (void) showAlertWithText:(NSString*)text
{
    [self showAlertWithText:text andTitle:@"Sorry!"];
}

- (void) showAlertWithText:(NSString*)text andTitle:(NSString*)title
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}


@end
