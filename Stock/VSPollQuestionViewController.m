//
//  VSPollQuestionViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPollQuestionViewController.h"
#import "VSPollQuestionTableViewCell.h"
#import "VSPollAnswerTableViewCell.h"
#import "VSButtonTableViewCell.h"
#import "VSPollResultsViewController.h"

@interface VSPollQuestionViewController ()

@end

@implementation VSPollQuestionViewController

@synthesize poll, tableView, sections;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:@"Guesstimates"];
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                      style:UIBarButtonItemStylePlain
                                     target:nil
                                     action:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    if (self.poll) {
        [self.sections addObject:@"question"];
        [self.sections addObject:@"answers"];
        [self.sections addObject:@"submit"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"question"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"answers"]) {
        return [[self.poll pollAnswers] count];
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"submit"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"question"]) {
        return [self tableView:self.tableView questionCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answers"]) {
        return [self tableView:self.tableView answerCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"submit"]) {
        return [self tableView:self.tableView submitCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView questionCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSPollQuestionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pollQuestionCell" forIndexPath:indexPath];
    
    [cell configureWithPoll:[self.poll objectForKey:@"poll"]];
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView answerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSPollAnswerTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pollAnswerCell" forIndexPath:indexPath];
    
    [cell configureWithPollAnswer:[[self.poll pollAnswers] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView submitCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"submitCell" forIndexPath:indexPath];
    
    [cell configureWithText:@"Submit Answer" andColor:[UIColor greenColor]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"submit"]) {
        [self updateWithAnswerAtIndexPath:indexPath success:^(id responseObject){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            VSPollResultsViewController *vc = (VSPollResultsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollResultsViewController"];
            [vc setPoll:self.poll];
            NSMutableArray *activeViewControllers=[[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers] ;
            [activeViewControllers removeLastObject];
            [activeViewControllers addObject:vc];
            [self.navigationController pushViewController:vc animated:YES];
            [self.navigationController setViewControllers:activeViewControllers];
        }failure:nil];
    }
}


# pragma mark - REQUESTS

- (void) updateWithAnswerAtIndexPath:(NSIndexPath*)indexPath success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    NSMutableDictionary *pr = [NSMutableDictionary create:@"poll_result"];
    [pr setObject:[[[self.poll pollAnswers] objectAtIndex:indexPath.row] ID] forKey:@"poll_answer_id"];
    [pr setObject:[[self.poll objectForKey:@"poll"] ID] forKey:@"poll_id"];
    [pr setObject:[[[LXSession thisSession] user] ID] forKey:@"user_id"];
    [pr saveRemote:^(id responseObject){
        self.poll = [responseObject objectForKey:@"poll"];
        successCallback(nil);
    }failure:nil];
}




@end
