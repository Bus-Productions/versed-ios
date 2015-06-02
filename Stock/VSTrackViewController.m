//
//  VSTrackViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSTrackViewController.h"
#import "VSResourceTableViewCell.h"
#import "DZNWebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VSCompletedTrackViewController.h"

#define SAVE_TO_MY_TRACKS_TEXT @"Save To My Tracks"
#define REMOVE_FROM_MY_TRACKS_TEXT @"Remove From My Tracks"

@interface VSTrackViewController ()

@end

@implementation VSTrackViewController

@synthesize track, tableView, sections;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupNavigationBar];
    [self setupBottomView];
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

- (void) viewDidAppear:(BOOL)animated
{
    self.navigationController.hidesBarsOnSwipe = NO;
    self.navigationController.hidesBarsWhenKeyboardAppears = NO;
    self.navigationController.hidesBarsWhenVerticallyCompact = NO;
    [self.navigationController setToolbarHidden:YES];
}


# pragma mark - Setup

- (void) setupNavigationBar
{
    saveToMyTracksButton = [VSSaveToMyTracksButton initWithTrack:self.track andMyTrackIDs:myTracksIDs];
    [saveToMyTracksButton addTarget:self action:@selector(saveMyTrackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:saveToMyTracksButton]; 
}

- (void) setupData
{
    completedPeople = [[NSMutableArray alloc] init];
    discussionPeople = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[track keyForTrack]]) {
        self.track = [[[NSUserDefaults standardUserDefaults] objectForKey:[self.track keyForTrack]] mutableCopy];
    }
    myTracksIDs = [[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] ? [[[[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] mutableCopy] pluckIDs] : [[NSMutableArray alloc] init];
}

- (void) setupBottomView
{
    [self.joinDiscussionButton setTitle:[NSString stringWithFormat:@"%@ are discussing", [discussionPeople formattedPluralizationForSingular:@"person" orPlural:@"people"]] forState:UIControlStateNormal];
    [self.seeCompletedButton setTitle:[NSString stringWithFormat:@"%@ completed", [completedPeople formattedPluralizationForSingular:@"person" orPlural:@"people"]] forState:UIControlStateNormal];
}

# pragma mark - Reload/Request

- (void) reloadScreen
{
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/tracks/%@/resources_for_user.json", [self.track ID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        completedPeople = [[responseObject objectForKey:@"completed_in_company"] mutableCopy];
        discussionPeople = [[responseObject objectForKey:@"discussing_track"] mutableCopy];
        [self setupBottomView];
        self.track = [[responseObject objectForKey:@"track"] mutableCopy];
        [self.track setObject:[responseObject resources] forKey:@"resources"];
        [[self.track cleanDictionary] saveLocalWithKey:[self.track keyForTrack]
                             success:^(id responseObject) {
                                 [self.tableView reloadData];
                             }
                             failure:nil];
        
        NSMutableArray *myTracks = [[responseObject objectForKey:@"my_tracks"] mutableCopy];
        [[myTracks cleanArray] saveLocalWithKey:@"myTracks"];
    }failure:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    [self.sections addObject:@"resources"];
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"resources"]) {
        return [[self.track resources] count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        return [self tableView:self.tableView resourcesCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView resourcesCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *resource = [self resourceAtIndexPath:indexPath];
    VSResourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"resourceCell" forIndexPath:indexPath];
    
    [cell configureWithResource:resource];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        NSURL *URL = [NSURL URLWithString:(NSString*)[[self resourceAtIndexPath:indexPath] url]];
        
        DZNWebViewController *vc = [[DZNWebViewController alloc] initWithURL:URL];
        [vc setToolbarBackgroundColor:[UIColor whiteColor]];
        [vc setToolbarTintColor:[UIColor blackColor]];
        self.navigationController.hidesBarsOnSwipe = YES;
        self.navigationController.hidesBarsWhenKeyboardAppears = YES;
        self.navigationController.hidesBarsWhenVerticallyCompact = YES;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - Helpers

- (NSMutableDictionary*) resourceAtIndexPath:(NSIndexPath*)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        return [[[self.track resources] objectAtIndex:indexPath.row] mutableCopy];
    }
    return nil;
}


# pragma mark - Actions

- (IBAction)seeCompletedAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSCompletedTrackViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"completedTrackViewController"];
    [vc setUsersCompleted:completedPeople];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)joinDiscussionAction:(id)sender {
        NSLog(@"join discussion");
}

- (void) saveMyTrackButtonPressed
{
    [saveToMyTracksButton updateMyTracks]; 
}
@end
