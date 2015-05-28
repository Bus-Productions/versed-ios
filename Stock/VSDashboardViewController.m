//
//  VSDashboardViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/27/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSDashboardViewController.h"
#import "VSLeaderTableViewCell.h"
#import "VSEmptyTableViewCell.h"

@interface VSDashboardViewController ()

@end

@implementation VSDashboardViewController

@synthesize tableView, sections, leaders;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self reloadScreen];
}

# pragma mark - Request/Reload
- (void) reloadScreen
{
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/companies/%@/leaderboard.json", [[[LXSession thisSession] user] companyID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        NSLog(@"response = %@", responseObject);
        self.leaders = [[responseObject cleanDictionary] objectForKey:@"leaders"];
        [self.leaders saveLocalWithKey:@"leaders"];
        NSLog(@"self.leaders = %@", self.leaders);
        [self.tableView reloadData];
    }failure:nil];
}


# pragma mark - Setup 

- (void) setupData
{
    self.leaders = [[NSUserDefaults standardUserDefaults] objectForKey:@"leaders"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"leaders"] mutableCopy] : [[NSMutableArray alloc] init];
}

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:@"Leaderboard"]; 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    [self.sections addObject:@"title"];
    if (self.leaders.count > 0) {
        [self.sections addObject:@"leaders"];
    } else {
        [self.sections addObject:@"empty"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"title"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"leaders"]) {
        return self.leaders.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"title"]) {
        return [self tableView:self.tableView leaderboardTitleCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return [self tableView:self.tableView emptyCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"leaders"]) {
        return [self tableView:self.tableView leadersCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView leaderboardTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
    UILabel *lbl = (UILabel*)[cell viewWithTag:1];
    [lbl setText:@"The Leaderboard"];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView leadersCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSLeaderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"leaderCell" forIndexPath:indexPath];
    [cell configureWithUser:[self.leaders objectAtIndex:indexPath.row] andLeaders:self.leaders];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    [cell configureWithText:@"Nobody is on the leaderboard"];
    return cell;
}




@end
