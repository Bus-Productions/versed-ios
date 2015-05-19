//
//  VSTracksViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSMyTracksViewController.h"
#import "SWRevealViewController.h"
#import "VSTrackTableViewCell.h"
#import "VSTrackViewController.h"
#import "VSEmptyTableViewCell.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSMyTracksViewController ()

@end

@implementation VSMyTracksViewController

@synthesize tableView, slideButton, myTracks, sections;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self setupData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupSidebar
{
    [self setTitle:@"My Tracks"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void) setupData
{
    self.myTracks = [[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] mutableCopy] : [[NSMutableArray alloc] init];
}


# pragma mark - Request/Reload

- (void) reloadScreen
{
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/tracks.json", [[[LXSession thisSession] user] ID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        self.myTracks = [[[responseObject cleanDictionary] objectForKey:@"my_tracks"] mutableCopy];
        if (NULL_TO_NIL(self.myTracks)) {
            [self.myTracks saveLocalWithKey:@"myTracks" success:^(id responseObject){
                [self.tableView reloadData];
            }failure:nil];
        } else {
            [[[NSMutableArray alloc] init] destroyLocalWithKey:@"myTracks" success:^(id responseObject){
                [self.tableView reloadData];
            }failure:nil];
        }
    }failure:nil];
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];

    if (self.myTracks.count < 1) {
        [self.sections addObject:@"empty"];
    } else {
        [self.sections addObject:@"tracks"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"tracks"]) {
        return self.myTracks.count;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"tracks"]) {
        return [self tableView:self.tableView tracksCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return [self tableView:self.tableView emptyCellForRowAtIndexPath:indexPath]; 
    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView tracksCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *track = [[self.myTracks objectAtIndex:indexPath.row] mutableCopy];
    VSTrackTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
    
    [cell configureWithTrack:track];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    
    [cell configureWithText:@"You can save learning tracks that you want to reference and they will show up here!"];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"tracks"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSTrackViewController *vc = (VSTrackViewController*)[storyboard instantiateViewControllerWithIdentifier:@"trackViewController"];
        [vc setTrack:[self.myTracks objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
