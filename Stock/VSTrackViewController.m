//
//  VSTrackViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSTrackViewController.h"
#import "VSResourceTableViewCell.h"
#import "SVWebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VSCompletedTrackViewController.h"
#import "VSPollsTableViewCell.h"
#import "VSPollQuestionViewController.h"
#import "VSPollResultsViewController.h"
#import "VSMessagesViewController.h"
#import "VSCongratsViewController.h"
#import "VSTrackTitleTableViewCell.h"
#import "VSResourceViewController.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSTrackViewController ()

@end

@implementation VSTrackViewController

@synthesize track, tableView, sections, polls;
@synthesize bottomToolbarView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    if (showCongrats) {
        [self showCongratsScreen];
    }
    [self reloadScreen];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self hideNavBarOnSwipe:NO];
}


# pragma mark - Orientations

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return YES;
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
    completedResources = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    usersDiscussing = [[NSMutableArray alloc] init];
    self.polls = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[track keyForTrack]]) {
        self.track = [[[NSUserDefaults standardUserDefaults] objectForKey:[self.track keyForTrack]] mutableCopy];
    }
    myTracksIDs = [[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] ? [[[[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] mutableCopy] pluckIDs] : [[NSMutableArray alloc] init];
}

- (void) setupBottomView
{
    [self.joinDiscussionButton setTitle:@"" forState:UIControlStateNormal];
    [self.seeCompletedButton setTitle:@"" forState:UIControlStateNormal];
    
    UILabel* leftLabel = (UILabel*) [self.bottomToolbarView viewWithTag:1];
    [leftLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [leftLabel setText:[NSString stringWithFormat:@"%@ %@ completed this track", [completedPeople formattedPluralizationForSingular:@"person" orPlural:@"people"], ([completedPeople count] == 1 ? @"has" : @"have")]];
    
    UILabel* rightLabel = (UILabel*) [self.bottomToolbarView viewWithTag:2];
    [rightLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [rightLabel setText:[NSString stringWithFormat:@"%@ %@ discussing", [usersDiscussing formattedPluralizationForSingular:@"person" orPlural:@"people"], usersDiscussing.count == 1 ? @"is" : @"are"]];
}

# pragma mark - Reload/Request

- (void) reloadScreen
{
    requesting = YES;
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/tracks/%@/resources_for_user.json", [self.track ID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        completedPeople = [[responseObject objectForKey:@"completed_in_company"] mutableCopy];
        messages = [[responseObject objectForKey:@"messages"] mutableCopy];
        usersDiscussing = [[responseObject objectForKey:@"people_discussing"] mutableCopy];
        completedResources = [[responseObject objectForKey:@"completed_resources"] mutableCopy];
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
        
        NSMutableArray *myTracks = [[(NSArray*)[responseObject objectForKey:@"my_tracks"] cleanArray] mutableCopy];
        [myTracks saveLocalWithKey:@"myTracks"];
    }failure:^(NSError *error){
        requesting = NO;
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    [self.sections addObject:@"header"];
    
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
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"header"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        return [self tableView:self.tableView resourcesCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"polls"]) {
        return [self tableView:self.tableView pollCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return [self tableView:self.tableView headerCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView resourcesCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *resource = [self resourceAtIndexPath:indexPath];
    VSResourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"resourceCell" forIndexPath:indexPath];
    
    [cell configureWithResource:resource andCompletedResources:completedResources];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView pollCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *poll = [[self.polls objectAtIndex:indexPath.row] mutableCopy];
    VSPollsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pollCell" forIndexPath:indexPath];
    
    [cell configureWithPoll:poll];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView headerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSTrackTitleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"trackTitleCell" forIndexPath:indexPath];
    
    [cell configureWithTrack:self.track andIndexPath:indexPath];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [self createResourceUserPairAtIndexPath:indexPath];
        });
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSResourceViewController *webViewController = (VSResourceViewController*)[storyboard instantiateViewControllerWithIdentifier:@"resourceViewController"];
        [webViewController setResource:[[self.track resources] objectAtIndex:indexPath.row]];
        [webViewController setTrack:self.track];
        [self.navigationController pushViewController:webViewController animated:YES];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"polls"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NSMutableDictionary *p = [self.polls objectAtIndex:indexPath.row];
        if (!NULL_TO_NIL([p objectForKey:@"user_answer"])) {
            VSPollQuestionViewController *vc = (VSPollQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollQuestionViewController"];
            [vc setPoll:p];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VSPollResultsViewController *vc = (VSPollResultsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollResultsViewController"];
            [vc setPoll:p];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return 146.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        return 150.0f; //[(VSResourceTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath] heightForRow];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"polls"]) {
        NSString* pollQuestion = [[[self.polls objectAtIndex:indexPath.row] poll] pollQuestion];
        return 52.0f + [self heightForText:pollQuestion width:(self.view.frame.size.width-16.0f) font:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0f]]; //[(VSResourceTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath] heightForRow];
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

- (void) createResourceUserPairAtIndexPath:(NSIndexPath*)indexPath
{
    NSMutableDictionary *rup = [NSMutableDictionary create:@"resource_user_pair"];
    [rup setObject:[[self resourceAtIndexPath:indexPath] ID] forKey:@"resource_id"];
    [rup setObject:[[[LXSession thisSession] user] ID] forKey:@"user_id"];
    [rup setObject:@"completed" forKey:@"status"];
    showCongrats = completedResources.count == [[self.track resources] count] - 1;
    [rup saveRemote:^(id responseObject){
        if (![[responseObject objectForKey:@"new_record"] boolValue]) {
            showCongrats = NO;
        }
        [[LXSession thisSession] setUser:[[responseObject objectForKey:@"user"] cleanDictionary] success:^(id responseObject){
            [self reloadScreen];
        }failure:nil];
    }failure:nil];
}





#pragma mark - Helpers

- (NSMutableDictionary*) resourceAtIndexPath:(NSIndexPath*)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        return [[[self.track resources] objectAtIndex:indexPath.row] mutableCopy];
    }
    return nil;
}

- (void) hideNavBarOnSwipe:(BOOL)hide
{
    self.navigationController.hidesBarsOnSwipe = hide;
}

- (void) showCongratsScreen
{
    showCongrats = NO;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSCongratsViewController *vc = (VSCongratsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"congratsViewController"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [vc setTrack:self.track];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

# pragma mark - Actions

- (IBAction)seeCompletedAction:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSCompletedTrackViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"completedTrackViewController"];
    [vc setUsersCompleted:completedPeople];
    [vc setTrack:self.track];
    [vc setMyTracksIDs:myTracksIDs]; 
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)joinDiscussionAction:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSMessagesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"messagesViewController"];
    [vc setTrack:self.track];
    [vc setAllMessages:messages]; 
    [vc setMyTracksIDs:myTracksIDs];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) saveMyTrackButtonPressed
{
    [saveToMyTracksButton updateMyTracks]; 
}





# pragma mark - Alert

- (void) showAlertWithText:(NSString*)text
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}

@end
