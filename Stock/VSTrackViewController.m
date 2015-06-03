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
#import "VSPollsTableViewCell.h"
#import "VSPollQuestionViewController.h"
#import "VSPollResultsViewController.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSTrackViewController ()

@end

@implementation VSTrackViewController

@synthesize track, tableView, sections, polls;

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
    self.polls = [[NSMutableArray alloc] init];
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
    requesting = YES;
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/tracks/%@/resources_for_user.json", [self.track ID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        completedPeople = [[responseObject objectForKey:@"completed_in_company"] mutableCopy];
        discussionPeople = [[responseObject objectForKey:@"discussing_track"] mutableCopy];
        [self setupBottomView];
        self.polls = [[responseObject objectForKey:@"polls"] mutableCopy];
        self.track = [[responseObject objectForKey:@"track"] mutableCopy];
        [self.track setObject:[responseObject resources] forKey:@"resources"];
        requesting = NO;
        [[self.track cleanDictionary] saveLocalWithKey:[self.track keyForTrack]
                             success:^(id responseObject) {
                                 [self.tableView reloadData];
                             }
                             failure:nil];
        
        NSMutableArray *myTracks = [[responseObject objectForKey:@"my_tracks"] mutableCopy];
        [[myTracks cleanArray] saveLocalWithKey:@"myTracks"];
    }failure:^(NSError *error){
        requesting = NO;
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    [self.sections addObject:@"resources"];
    if (!requesting && self.polls.count > 0) {
        [self.sections addObject:@"polls"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"resources"]) {
        return [[self.track resources] count];
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"polls"]) {
        return self.polls.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        return [self tableView:self.tableView resourcesCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"polls"]) {
        return [self tableView:self.tableView pollCellForRowAtIndexPath:indexPath];
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

- (UITableViewCell *)tableView:(UITableView *)tableView pollCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *poll = [[self.polls objectAtIndex:indexPath.row] mutableCopy];
    VSPollsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pollCell" forIndexPath:indexPath];
    
    [cell configureWithPoll:poll];
    
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
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"polls"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NSMutableDictionary *p = [self.polls objectAtIndex:indexPath.row];
        if (!NULL_TO_NIL([p objectForKey:@"user_answer"])) {
            VSPollQuestionViewController *vc = (VSPollQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollQuestionViewController"];
            [vc setPoll:p];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VSPollResultsViewController *vc = (VSPollQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollResultsViewController"];
            [vc setPoll:p];
            [self.navigationController pushViewController:vc animated:YES];
        }

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
    [vc setTrack:self.track];
    [vc setMyTracksIDs:myTracksIDs]; 
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
