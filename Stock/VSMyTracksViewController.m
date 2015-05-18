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

@interface VSMyTracksViewController ()

@end

@implementation VSMyTracksViewController

@synthesize tableView, slideButton, myTracks;

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
        [self.myTracks saveLocalWithKey:@"myTracks" success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    }failure:nil];
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myTracks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *track = [[self.myTracks objectAtIndex:indexPath.row] mutableCopy];
    VSTrackTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
    
    [cell configureWithTrack:track];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSTrackViewController *vc = (VSTrackViewController*)[storyboard instantiateViewControllerWithIdentifier:@"trackViewController"];
    [vc setTrack:[self.myTracks objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
