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
#import "PNChart.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })
static int QUESTION_TIME = 25;

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
    [self setupNextButton];
    [self showOrHideNextBar];
    
//    NSLog(@"question: %@", self.question);
    //NSLog(@"qr: %@", self.quizResults);
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
//    [self.navigationItem setTitle:[NSString stringWithFormat:@"Question %lu of %lu", (unsigned long)questionsCompleted, (unsigned long)totalQuestions]];
    [self.navigationItem setTitle:@"Quiz"];
}

- (void) setupTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector:@selector(onTick:)
                                                userInfo: nil repeats:YES];
    remainingTime = QUESTION_TIME;
}

- (void) setupNextButton
{
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:18.0f];
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
    [cell configureWithText:@"Next Question" andColor:nil];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView headerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
    
    UILabel* timerLabel = (UILabel*)[cell.contentView viewWithTag:1];
    [timerLabel setText:[NSString stringWithFormat:@"00:%@", remainingTime > 9 ? [NSString stringWithFormat:@"%d", remainingTime] : [NSString stringWithFormat:@"0%d",remainingTime]]];
    
    UILabel* percentageLabel = (UILabel*)[cell.contentView viewWithTag:2];
    [percentageLabel setText:[self.quizResults quizPercentageCorrect]];
    
    UILabel* questionLabel = (UILabel*)[cell.contentView viewWithTag:3];
    [questionLabel setText:[NSString stringWithFormat:@"%lu/%lu",  (unsigned long)self.questionsCompleted, (unsigned long)self.totalQuestions]];
    
    UIView *grayBackground = (UIView*)[cell viewWithTag:4];
    [grayBackground setBackgroundColor:PNGrey];
    
    CGFloat fontSize = 26.0f;
    
    CGFloat chartWidth = self.view.frame.size.width/3.0;
    CGFloat chartHeight = chartWidth;
    
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0 - chartWidth/2.0, cell.frame.size.height/2.0 - chartHeight/2.0, chartWidth, chartHeight) total:[NSNumber numberWithInt:QUESTION_TIME] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:PNGrey displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithInt:12]];
    circleChart.backgroundColor = [UIColor clearColor];
    [circleChart setStrokeColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0]];
    [circleChart strokeChart];
    [circleChart setTag:5];
    [cell addSubview:circleChart];

    UILabel* percentageTitle = (UILabel*)[cell.contentView viewWithTag:10];
    UILabel* questionTitle = (UILabel*)[cell.contentView viewWithTag:11];
    [percentageTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]];
    [questionTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]];
    [timerLabel setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:fontSize]];
    [percentageLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:fontSize]];
    [questionLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:fontSize]];
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
            NSLog(@"****** %lu", (unsigned long)self.quizResults.count);
            [self.tableView reloadData];
        } failure:nil];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"next"]) {
        [self.delegate updateQuizQuestions]; 
    }
}

- (NSInteger) pointsForRound
{
    return [self.delegate pointsForRound];
}

- (IBAction)nextAction:(id)sender
{
    [self.delegate updateQuizQuestions];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        if ([[UIScreen mainScreen] bounds].size.height < 500.0) { //4s & iPad
           return 110.0f;
        } else if ([[UIScreen mainScreen] bounds].size.height < 570.0) { //5s
            return 115.0f;
        } else { //6 & 6+
            return 180.0f;
        }
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answer"]) {
        return 44.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"next"]) {
        return 62.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"question"]) {
        return 20.0f + [self heightForText:[self.question questionText] width:(self.view.frame.size.width-32.0f) font:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0f]];
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
    VSQuizAnswerTableViewCell *correctCell = (VSQuizAnswerTableViewCell*)[self.tableView cellForRowAtIndexPath:[self indexPathOfCorrectAnswer]];
    VSQuizAnswerTableViewCell *chosenCell;
    if (NULL_TO_NIL(indexPath)) {
        chosenCell = (VSQuizAnswerTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        if (![chosenCell isEqual:correctCell]) {
            UIView *backgroundView = [(UIView*)chosenCell.contentView viewWithTag:1];
            [backgroundView setBackgroundColor:[UIColor grayColor]];
            UILabel *lbl = (UILabel*)[chosenCell.contentView viewWithTag:2];
            [lbl setTextColor:[UIColor whiteColor]];
            UIImageView *chosenImgView = (UIImageView*)[chosenCell.contentView viewWithTag:3];
            [chosenImgView setImage:[UIImage imageNamed:@"wrong_checkbox.png"]];
        }
    } else {
        [self showAlertWithText:@"You ran out of time!"];
    }
    UIView *correctView = (UIView*)[correctCell.contentView viewWithTag:1];
    [correctView setBackgroundColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0]];
    
    UILabel *correctLbl = (UILabel*)[correctCell.contentView viewWithTag:2];
    [correctLbl setTextColor:[UIColor whiteColor]];
    
    UIImageView *correctImgView = (UIImageView*)[correctCell.contentView viewWithTag:3];
    [correctImgView setImage:[UIImage imageNamed:@"correct_checkbox.png"]];
    
    successCallback(nil);
    
//    if (NULL_TO_NIL(indexPath) && chosenCell) {
//        if ([indexPath isEqual:[self indexPathOfCorrectAnswer]]) {
//            [self animateTopCell:YES];
//        } else {
//            [self animateTopCell:NO];
//        }
//    }
    
    [self showOrHideNextBar];
}
//
//- (void) animateTopCell:(BOOL)correct
//{
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    
//    UIImageView* headerBackground = (UIImageView*)[cell.contentView viewWithTag:21];
//    [headerBackground setImage:[UIImage imageNamed:@"question_header_transparent.png"]];
//    [headerBackground setBackgroundColor:[UIColor clearColor]];
//    
//    UILabel* questionLabel = (UILabel*)[cell.contentView viewWithTag:22];
//    [questionLabel setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:24.0f]];
//    [questionLabel setTextColor:[UIColor whiteColor]];
//    
//    [questionLabel setAlpha:1.0f];
//    
//    if (correct) {
//        [questionLabel setText:[NSString stringWithFormat:@"+%@", [self.question pointsForQuestion]]];
//        [questionLabel setBackgroundColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0]];
//    } else {
//        [questionLabel setText:@"+0"];
//        [questionLabel setBackgroundColor:[UIColor redColor]];
//    }
//    
//    UILabel* curLabel = (UILabel*)[cell.contentView viewWithTag:2];
//    
//    [curLabel setAlpha:0];
//    
//    [self performSelector:@selector(hideTopCellAnimation) withObject:nil afterDelay:1.0f];
//}
//
//- (void) hideTopCellAnimation
//{
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    
//    UILabel* questionLabel = (UILabel*)[cell.contentView viewWithTag:22];
//    UILabel* curLabel = (UILabel*)[cell.contentView viewWithTag:2];
//    
//    [UIView animateWithDuration:2.0f
//                     animations:^(void){
//                         [questionLabel setAlpha:0.0f];
//                     }
//                     completion:^(BOOL finished){
//                         [curLabel setAlpha:1.0f];
//                     }
//     ];
//}

- (NSIndexPath*) questionIndexPath
{
    NSInteger questionSectionIndex = [self.sections indexOfObject:@"question"];
    NSInteger firstRowIndex = 0;
    return [NSIndexPath indexPathForRow:firstRowIndex inSection:questionSectionIndex];
}

- (NSIndexPath*) headerIndexPath
{
    NSInteger headerSectionIndex = [self.sections indexOfObject:@"header"];
    NSInteger firstRowIndex = 0;
    return [NSIndexPath indexPathForRow:firstRowIndex inSection:headerSectionIndex];
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
        [self.nextButton setHidden:NO];
    } else {
        self.nextContainerHeightConstraint.constant = 0;
        [self.nextButton setHidden:YES]; 
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
        UITableViewCell *timerCell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:[self timerIndexPath]];
        UILabel *timerLabel = (UILabel*)[timerCell.contentView viewWithTag:1];
        [timerLabel setText:[NSString stringWithFormat:@"00:%@", remainingTime > 9 ? [NSString stringWithFormat:@"%d", remainingTime] : [NSString stringWithFormat:@"0%d",remainingTime]]];
        UITableViewCell *headerCell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:[self headerIndexPath]];
        PNCircleChart *chart = [headerCell viewWithTag:5];
        [chart setCurrent:[NSNumber numberWithInt:(QUESTION_TIME - remainingTime)]];
        [chart strokeChart];
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
