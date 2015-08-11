//
//  VSTracksViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSMyTracksViewController.h"
#import "VSTrackTableViewCell.h"
#import "VSTrackViewController.h"
#import "VSEmptyTableViewCell.h"
#import "VSMessagesViewController.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSMyTracksViewController ()

@end

@implementation VSMyTracksViewController

@synthesize tableView, slideButton, myTracks, sections, bottomView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSidebar];
    [self setupData];
    [self setupNotifications];
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
    [revealViewController setDelegate:self];
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

- (void) setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"updatedMyTracks" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showDiscussion" object:nil];
}

#pragma mark - SWRevealViewController Delegate Methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}



# pragma mark - Request/Reload

- (void) reloadScreen
{
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/tracks.json", [[[LXSession thisSession] user] ID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        [self handleMyTracksResponse:responseObject];
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

    [cell configureWithTrack:track andIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    
    [cell configureWithTextsInArray:@[[NSString stringWithFormat:@"%@, you haven't saved any learning tracks.", [[[LXSession thisSession] user] firstName]], @"Saving learning tracks lets you easily come back later, and find out when new resources are added."]];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"tracks"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSTrackViewController *vc = (VSTrackViewController*)[storyboard instantiateViewControllerWithIdentifier:@"trackViewController"];
        [vc setTrack:[self.myTracks objectAtIndex:indexPath.row]];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"tracks"]) {
        NSMutableDictionary *track = [[self.myTracks objectAtIndex:indexPath.row] mutableCopy];
        return 175.0f + [self heightForText:[track objectForKey:@"description"] width:(self.view.frame.size.width-40.0f) font:[UIFont fontWithName:@"SourceSansPro-Regular" size:15.0f]];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return 400.0f;
    }
    return 100.0f;
}

- (CGFloat) heightForText:(NSString*)text width:(CGFloat)width font:(UIFont*)font
{
    if (!text || [text length] == 0) {
        return 0.0f;
    }
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 100000)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size.height;
}



# pragma mark - ACTIONS


- (void) handleNotification:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:@"showDiscussion"]) {
        [self handleShowDiscussionResponse:[notification userInfo]];
    } else if ([[notification name] isEqualToString:@"updatedMyTracks"]){
        [self handleMyTracksResponse:[notification userInfo]];
    }
}

- (void) handleMyTracksResponse:(NSDictionary*)notification
{
    self.myTracks = [[[notification objectForKey:@"my_tracks"] mutableCopy] cleanArray];
    if (NULL_TO_NIL(self.myTracks)) {
        [self.myTracks saveLocalWithKey:@"myTracks" success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    } else {
        [[[NSMutableArray alloc] init] destroyLocalWithKey:@"myTracks" success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    }
}

- (void) handleShowDiscussionResponse:(NSDictionary*)notification
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSMessagesViewController *vc = (VSMessagesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"messagesViewController"];
    [vc setTrack:[[notification objectForKey:@"track"] mutableCopy]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
