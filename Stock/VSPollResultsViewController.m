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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    NSLog(@"poll = %@", poll);
}

- (void)didReceiveMemoryWarning {
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
        [self.sections addObject:@"answers"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"answers"]) {
        return [[self.poll pollAnswers] count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answers"]) {
        return [self tableView:self.tableView answerCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView answerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSPollResultsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pollResultsCell" forIndexPath:indexPath];
    
    [cell configureWithPollResult:[[self.poll pollAnswers] objectAtIndex:indexPath.row] andUserAnswer:[self.poll objectForKey:@"user_answer"]];
    
    return cell;
}



@end
