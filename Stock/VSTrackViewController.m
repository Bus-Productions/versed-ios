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
    [self setupFooter];
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
    saveToMyTracksButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveToMyTracksButton addTarget:self
               action:@selector(updateMyTracks)
     forControlEvents:UIControlEventTouchUpInside];
    [saveToMyTracksButton setTitle:[self saveToMyTracksButtonTitle] forState:UIControlStateNormal];
    [self.navigationItem setTitleView:saveToMyTracksButton];
}

- (void) setupFooter
{
//    UIView *footerView = [[UIView alloc] init];
//    [footerView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    footerView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:footerView];
//    
//    // Width constraint, half of parent view width
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:footerView
//                                                          attribute:NSLayoutAttributeWidth
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeWidth
//                                                         multiplier:1
//                                                           constant:0]];
//    
//    // Height constraint, half of parent view height
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:footerView
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeHeight
//                                                         multiplier:0.5
//                                                           constant:0]];
}

- (void) setupData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[track keyForTrack]]) {
        self.track = [[[NSUserDefaults standardUserDefaults] objectForKey:[self.track keyForTrack]] mutableCopy];
    }
    myTracksIDs = [[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] ? [[[[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] mutableCopy] pluckIDs] : [[NSMutableArray alloc] init];
}


# pragma mark - Reload/Request

- (void) reloadScreen
{
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/tracks/%@/resources_for_user.json", [self.track ID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        NSLog(@"completed_in_company = %@", [responseObject objectForKey:@"completed_in_company"]);
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

- (NSString*) saveToMyTracksButtonTitle
{
    if ([myTracksIDs containsObject:[self.track ID]]) {
        return REMOVE_FROM_MY_TRACKS_TEXT;
    }
    return SAVE_TO_MY_TRACKS_TEXT;
}

- (void) switchSaveTracksText
{
    if ([saveToMyTracksButton.currentTitle isEqualToString:SAVE_TO_MY_TRACKS_TEXT]) {
        [saveToMyTracksButton setTitle:REMOVE_FROM_MY_TRACKS_TEXT forState:UIControlStateNormal];
    } else {
        [saveToMyTracksButton setTitle:SAVE_TO_MY_TRACKS_TEXT forState:UIControlStateNormal];
    }
}


# pragma mark - Actions

- (void) updateMyTracks
{
    [self switchSaveTracksText];
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/update_my_tracks.json", [[[LXSession thisSession] user] ID]] withMethod:@"POST" withParamaters:@{@"track_id": [self.track ID]} authType:@"none" success:^(id responseObject){
        NSMutableArray *myTracks = [[responseObject objectForKey:@"my_tracks"] mutableCopy];
        [[myTracks cleanArray] saveLocalWithKey:@"myTracks"];
    }failure:nil];
}

@end
