//
//  VSPollResultsViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPollResultsViewController.h"
#import "VSPollResultsTableViewCell.h"
#import "VSPieChartTableViewCell.h"

#define COLORS = [[NSArray alloc] initWithObjects:PNRed, PNGreen, PNBlue, PNLightBlue, PNLightGreen, PNYellow, PNPinkDark, PNBlack, nil];


@interface VSPollResultsViewController ()

@end

@implementation VSPollResultsViewController

@synthesize poll, sections, hideRightBarButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupColors];
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
    if (!self.hideRightBarButton) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(exit)];
    }
}

- (void) setupColors
{
   colors = [[NSArray alloc] initWithObjects:PNRed, PNGreen, PNBlue, PNLightBlue, PNLightGreen, PNYellow, PNPinkDark, PNBlack, nil];
}

- (void) exit
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    if (self.poll) {
        [self.sections addObject:@"header"];
        [self.sections addObject:@"chart"];
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
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"chart"]) {
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
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"chart"]) {
        return [self tableView:self.tableView chartCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView headerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
    
    NSMutableDictionary *currentPoll = [self.poll objectForKey:@"poll"];

    UILabel* headerLabel = (UILabel*)[cell.contentView viewWithTag:1];
    [headerLabel setText:[currentPoll pollQuestion]];
    [headerLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:28.0f]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView answerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSPollResultsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pollResultsCell" forIndexPath:indexPath];
    
    [cell configureWithPoll:self.poll andIndexPath:indexPath andColors:colors];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView chartCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSPieChartTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pieChartCell" forIndexPath:indexPath];
    
    [cell configureWithPoll:self.poll andColors:colors];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"answers"]) {
        return 80.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return 150.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"chart"]) {
        return 260.0f;
    }
    return 100.0f;
}


@end
