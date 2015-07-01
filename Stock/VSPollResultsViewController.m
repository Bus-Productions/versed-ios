//
//  VSPollResultsViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPollResultsViewController.h"
#import "VSPollResultsTableViewCell.h"

@interface VSPollResultsViewController ()

@end

@implementation VSPollResultsViewController

@synthesize poll, sections;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    NSLog(@"poll = %@", self.poll);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:@"Results"];
}

- (void) backToRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    if (self.poll) {
        [self.sections addObject:@"header"];
        [self.sections addObject:@"answers"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"answers"]) {
        return [[self.poll pollAnswers] count];
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"header"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answers"]) {
        return [self tableView:self.tableView answerCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return [self tableView:self.tableView headerCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView headerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
    
    UILabel* headerLabel = (UILabel*)[cell.contentView viewWithTag:1];
    [headerLabel setText:[NSString stringWithFormat:@"Thank you for giving us your guesstimate, %@.", [[[LXSession thisSession] user] firstName]]];
    [headerLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:28.0f]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView answerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSPollResultsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pollResultsCell" forIndexPath:indexPath];
    
    [cell configureWithPollResult:[[self.poll pollAnswers] objectAtIndex:indexPath.row] andUserAnswer:[self.poll objectForKey:@"user_answer"]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answers"]) {
        return 120.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return 200.0f;
    }
    return 100.0f;
}


@end
