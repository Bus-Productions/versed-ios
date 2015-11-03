//
//  VSDeepDiveViewController.m
//  Versed
//
//  Created by Joseph Gill on 11/2/15.
//  Copyright © 2015 LXV. All rights reserved.
//

#import "VSDeepDiveViewController.h"
#import "VSTrackTitleTableViewCell.h"
#import "VSDeepDiveTableViewCell.h"
#import "VSEmptyTableViewCell.h"
#import "VSDeepDiveTitleTableViewCell.h"
#import "VSResourceViewController.h"

@interface VSDeepDiveViewController ()

@end

@implementation VSDeepDiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:[self.track headline]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    [self.sections addObject:@"header"];
    if (self.track && [[self.track deepDives] count] > 0) {
        [self.sections addObject:@"deepDiveTitle"];
        [self.sections addObject:@"deepDive"];
    } else {
        [self.sections addObject:@"empty"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"header"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"deepDive"]) {
        return [[self.track deepDives] count];
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"deepDiveTitle"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return [self tableView:self.tableView headerCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"deepDiveTitle"]) {
        return [self tableView:self.tableView deepDiveTitleCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"deepDive"]) {
        return [self tableView:self.tableView deepDiveCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return [self tableView:self.tableView emptyCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView headerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSTrackTitleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"trackTitleCell" forIndexPath:indexPath];
    
    [cell configureWithTrack:self.track andIndexPath:indexPath];
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView deepDiveCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSDeepDiveTableViewCell *cell = (VSDeepDiveTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"deepDiveCell" forIndexPath:indexPath];
    
    [cell configureWithDeepDive:[[self.track deepDives] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView deepDiveTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSDeepDiveTitleTableViewCell *cell = (VSDeepDiveTitleTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"deepDiveTitleCell" forIndexPath:indexPath];
    
    [cell configure];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    
    [cell configureWithText:@"There are no deep dives for this track at this time. Come back later!" andBackgroundColor:nil];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return 146.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"deepDive"]) {
        return 45.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return 100.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"deepDiveTitle"]) {
        return 35.0f;
    }
    return 100.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"deepDive"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSResourceViewController *webViewController = (VSResourceViewController*)[storyboard instantiateViewControllerWithIdentifier:@"resourceViewController"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        [webViewController setResource:[[self.track deepDives] objectAtIndex:indexPath.row]];
        [webViewController setTrack:self.track];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}


@end
