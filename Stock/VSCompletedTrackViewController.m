//
//  VSCompletedTrackViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/2/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSCompletedTrackViewController.h"
#import "VSUsersCompletedTrackTableViewCell.h"
#import "VSEmptyTableViewCell.h"
#import "VSCompletedTrackTitleTableViewCell.h"

#define SAVE_TO_MY_TRACKS_TEXT @"Save To My Tracks"
#define REMOVE_FROM_MY_TRACKS_TEXT @"Remove From My Tracks"

@interface VSCompletedTrackViewController ()

@end

@implementation VSCompletedTrackViewController

@synthesize usersCompleted, sections, myTracksIDs, track;

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
    saveToMyTracksButton = [VSSaveToMyTracksButton initWithTrack:self.track andMyTrackIDs:myTracksIDs];
    [saveToMyTracksButton addTarget:self action:@selector(saveMyTrackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:saveToMyTracksButton];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    [self.sections addObject:@"title"];
    if (usersCompleted.count > 0) {
        [self.sections addObject:@"usersCompleted"];
    } else {
        [self.sections addObject:@"empty"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"title"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"usersCompleted"]) {
        return self.usersCompleted.count;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"title"]) {
        return [self tableView:self.tableView titleCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"usersCompleted"]) {
        return [self tableView:self.tableView usersCompletedCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return [self tableView:self.tableView emptyCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView titleCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSCompletedTrackTitleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"completedTrackTitleCell" forIndexPath:indexPath];
    
    [cell configureWithTrack:self.track andUsers:self.usersCompleted];
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView usersCompletedCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSUsersCompletedTrackTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"usersCompletedCell" forIndexPath:indexPath];
    
    [cell configure:[self.usersCompleted objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    
    [cell configureWithText:@"Nobody has completed this track yet. Be the first!"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


# pragma mark - Actions

- (void) saveMyTrackButtonPressed
{
    [saveToMyTracksButton updateMyTracks];
}
@end
