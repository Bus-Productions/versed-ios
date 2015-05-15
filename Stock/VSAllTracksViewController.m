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

- (void) setupSidebar
{
    [self setTitle:@"All Learning Tracks"];
    
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

- (void) reloadScreen
{
    [[LXServer shared] requestPath:@"/categories.json" withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        self.categoriesWithTracks = [[[responseObject cleanDictionary] objectForKey:@"categories"] mutableCopy];
        [self.categoriesWithTracks saveLocalWithKey:@"categories"];
        [self.tableView reloadData];
    }failure:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoriesWithTracks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.categoriesWithTracks objectAtIndex:section] objectForKey:@"tracks"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *track = [[[[self.categoriesWithTracks objectAtIndex:indexPath.section] objectForKey:@"tracks"] objectAtIndex:indexPath.row] mutableCopy];
    VSTrackTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
    
    [cell configureWithTrack:track];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.categoriesWithTracks.count > 0) {
        return [[self.categoriesWithTracks objectAtIndex:section] objectForKey:@"category_name"];
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSTrackViewController *vc = (VSTrackViewController*)[storyboard instantiateViewControllerWithIdentifier:@"trackViewController"];
    [vc setTrack:[[[self.categoriesWithTracks objectAtIndex:indexPath.section] objectForKey:@"tracks"] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES]; 
}

@end
