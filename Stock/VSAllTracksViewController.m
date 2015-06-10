//
//  VSMainViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSAllTracksViewController.h"
#import "VSTrackTableViewCell.h"
#import "VSTrackViewController.h"

#define SAVE_TO_MY_TRACKS_TEXT @"Save To My Tracks"
#define REMOVE_FROM_MY_TRACKS_TEXT @"Remove From My Tracks"

@interface VSAllTracksViewController ()

@end

@implementation VSAllTracksViewController

@synthesize categoriesWithTracks, tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadScreen];
}


# pragma mark - Setup

- (void) setupSidebar
{
    [self setTitle:@"All Tracks"];
    
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
    self.categoriesWithTracks = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] mutableCopy] : [[NSMutableArray alloc] init];
}


# pragma mark - Request/Reload

- (void) reloadScreen
{
    [[LXServer shared] requestPath:@"/categories.json" withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        self.categoriesWithTracks = [[[responseObject cleanDictionary] objectForKey:@"categories"] mutableCopy];
        [self.categoriesWithTracks saveLocalWithKey:@"categories" success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    }failure:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoriesWithTracks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[self.categoriesWithTracks objectAtIndex:section] objectForKey:@"category"] objectForKey:@"tracks"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *track = [[[[[self.categoriesWithTracks objectAtIndex:indexPath.section] objectForKey:@"category"] objectForKey:@"tracks"] objectAtIndex:indexPath.row] mutableCopy];
    VSTrackTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
    [cell.saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell configureWithTrack:track andIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.categoriesWithTracks.count > 0) {
        return [[[self.categoriesWithTracks objectAtIndex:section] objectForKey:@"category"] objectForKey:@"category_name"];
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSTrackViewController *vc = (VSTrackViewController*)[storyboard instantiateViewControllerWithIdentifier:@"trackViewController"];
    [vc setTrack:[[[[self.categoriesWithTracks objectAtIndex:indexPath.section] objectForKey:@"category"] objectForKey:@"tracks"] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES]; 
}


# pragma mark - ACTIONS
- (void) saveButtonTapped:(UIButton*)sender
{
    VSTrackTableViewCell *selectedCell = (VSTrackTableViewCell *)sender.superview.superview;
    
    if (selectedCell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        [self switchSaveToTracksText:(UIButton*)sender];
        [self updateMyTracks:[[[[self.categoriesWithTracks objectAtIndex:indexPath.section] objectForKey:@"category"] objectForKey:@"tracks"] objectAtIndex:indexPath.row]];
    }
}

- (void) updateMyTracks:(NSMutableDictionary*)t
{
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/update_my_tracks.json", [[[LXSession thisSession] user] ID]] withMethod:@"POST" withParamaters:@{@"track_id": [t ID]} authType:@"none" success:^(id responseObject){
        [[[(NSArray*)[responseObject objectForKey:@"my_tracks"] cleanArray] mutableCopy] saveLocalWithKey:@"myTracks"];
    }failure:nil];
}

- (void) switchSaveToTracksText:(UIButton*)btn
{
    if ([btn.currentTitle isEqualToString:SAVE_TO_MY_TRACKS_TEXT]) {
        [btn setTitle:REMOVE_FROM_MY_TRACKS_TEXT forState:UIControlStateNormal];
    } else {
        [btn setTitle:SAVE_TO_MY_TRACKS_TEXT forState:UIControlStateNormal];
    }
}

@end
