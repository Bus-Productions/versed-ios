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
#import "VSEditorsNoteTableViewCell.h"
#import "VSButtonTableViewCell.h"
#import "VSDeepDiveViewController.h"
#import "VSPurchaseViewController.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSTrackViewController ()

@end

@implementation VSTrackViewController

@synthesize track, tableView, sections;
@synthesize bottomToolbarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
    [self setupBottomView];
    [self setupNotifications];
    [self setupEditorsNote];
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
    } else if (NULL_TO_NIL(pollToShow)) {
        [self showPollScreen];
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
    [self.navigationItem setTitle:[self.track headline]];
}

- (void) setupData
{
    completedPeople = [[NSMutableArray alloc] init];
    completedResources = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    usersDiscussing = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[track keyForTrack]]) {
        self.track = [[[NSUserDefaults standardUserDefaults] objectForKey:[self.track keyForTrack]] mutableCopy];
    }
    myTracksIDs = [[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] ? [[[[NSUserDefaults standardUserDefaults] objectForKey:@"myTracks"] mutableCopy] pluckIDs] : [[NSMutableArray alloc] init];
    expandedCells = [[NSMutableSet alloc] init];
}

- (void) setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"updatedMyTracks" object:nil];
}

- (void) setupBottomView
{
    [self.joinDiscussionButton setTitle:@"" forState:UIControlStateNormal];
    [self.seeCompletedButton setTitle:@"" forState:UIControlStateNormal];
    
    UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 10, 1, self.joinDiscussionButton.frame.size.height - 20)];
    leftBorder.backgroundColor = [UIColor whiteColor];
    [leftBorder setAlpha:0.1];
    [self.joinDiscussionButton addSubview:leftBorder];
    
    UILabel* leftLabel = (UILabel*) [self.bottomToolbarView viewWithTag:1];
    [leftLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [leftLabel setText:[NSString stringWithFormat:@"%@ %@ completed this track", [completedPeople formattedPluralizationForSingular:@"person" orPlural:@"people"], ([completedPeople count] == 1 ? @"has" : @"have")]];
    
    UILabel* rightLabel = (UILabel*) [self.bottomToolbarView viewWithTag:2];
    [rightLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    [rightLabel setText:[NSString stringWithFormat:@"%@ %@ discussing this track", [usersDiscussing formattedPluralizationForSingular:@"person" orPlural:@"people"], usersDiscussing.count == 1 ? @"is" : @"are"]];
}

- (void) setupEditorsNote
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tracksSeen = [[NSMutableArray alloc] initWithArray:[[defaults objectForKey:@"tracksSeen"] mutableCopy]];
    if (![tracksSeen containsObject:[self.track ID]]) {
        [expandedCells addObject:@"editorsNote"];
        [tracksSeen addObject:[self.track ID]];
        [defaults setObject:tracksSeen forKey:@"tracksSeen"];
        [defaults synchronize];
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
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
        self.track = [[responseObject objectForKey:@"track"] mutableCopy];
        [self.track setObject:[responseObject resources] forKey:@"resources"];
        requesting = NO;
        [[self.track cleanDictionary] saveLocalWithKey:[self.track keyForTrack]
                             success:^(id responseObject) {
                                 [self.tableView reloadData];
                                 [self.tableView beginUpdates];
                                 [self.tableView endUpdates];
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
    
    if ([self.track resources] && [[self.track resources] count] > 0) {
        [self.sections addObject:@"editorsNote"];
        [self.sections addObject:@"resources"];
        [self.sections addObject:@"learnMore"];
    }
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"resources"]) {
        return [[self.track resources] count];
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"header"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"editorsNote"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"learnMore"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        return [self tableView:self.tableView resourcesCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return [self tableView:self.tableView headerCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"editorsNote"]) {
        return [self tableView:self.tableView editorsNoteCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"learnMore"]) {
        return [self tableView:self.tableView learnMoreCellForRowAtIndexPath:indexPath];
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

- (UITableViewCell *)tableView:(UITableView *)tableView headerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSTrackTitleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"trackTitleCell" forIndexPath:indexPath];
    
    [cell configureWithTrack:self.track andIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView editorsNoteCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEditorsNoteTableViewCell *cell = (VSEditorsNoteTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"editorsNoteCell"];
    
    [cell setTrack:self.track];
    [cell configureAndHide:![expandedCells containsObject:@"editorsNote"]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView learnMoreCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSButtonTableViewCell *cell = (VSButtonTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"learnMoreCell"];
    [cell configureWithText:@"Learn More" andColor:[UIColor clearColor] andBorder:YES andTextColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0]];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
//        if ([[LXPurchase thisPurchase] shouldPromptToBuy]) {
//            [self showPurchaseScreen];
//        } else {
            [self showResourceAtIndexPath:indexPath];
//        }
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"editorsNote"]) {
        VSEditorsNoteTableViewCell *cell = (VSEditorsNoteTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([expandedCells containsObject:@"editorsNote"]) {
            [expandedCells removeObject:@"editorsNote"];
            [cell contract];
        } else {
            [expandedCells addObject:@"editorsNote"];
            [cell expand];
        }
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"learnMore"]) {
        [self showDeepDiveScreen];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return 146.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"resources"]) {
        NSMutableDictionary *res = [[self.track resources] objectAtIndex:indexPath.row];
        return 117.0f + ([completedResources containsObject:[NSNumber numberWithInt:[[res ID] intValue]]] ? -10.0 : [self heightForText:[res objectForKey:@"description"] width:(self.view.frame.size.width-30.0f) font:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]]);
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"editorsNote"]) {
        float heightOfTitle = 16.0f + [self heightForText:@"Introduction" width:(self.view.frame.size.width-30.0f) font:[UIFont fontWithName:@"SourceSansPro-Bold" size:13.0f]];
        if ([expandedCells containsObject:@"editorsNote"]) {
            return [self heightForText:[self.track editorsNote] width:(self.view.frame.size.width-30.0f) font:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]] + heightOfTitle;
        } else {
            return heightOfTitle;
        }
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"learnMore"]) {
        return 80.0f;
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
    pollToShow = [[[self resourceAtIndexPath:indexPath] polls] pollToShow];
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

- (void) showPollScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSPollQuestionViewController *vc = (VSPollQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollQuestionViewController"];
    [vc setPoll:pollToShow];
    pollToShow = nil;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)joinDiscussionAction:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSMessagesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"messagesViewController"];
    [vc setTrack:self.track];
    [vc setAllMessages:messages]; 
    [vc setMyTracksIDs:myTracksIDs];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) showPurchaseScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSPurchaseViewController *vc = (VSPurchaseViewController*)[storyboard instantiateViewControllerWithIdentifier:@"purchaseViewController"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void) showResourceAtIndexPath:(NSIndexPath*)indexPath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self createResourceUserPairAtIndexPath:indexPath];
    });
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSResourceViewController *webViewController = (VSResourceViewController*)[storyboard instantiateViewControllerWithIdentifier:@"resourceViewController"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [webViewController setResource:[[self.track resources] objectAtIndex:indexPath.row]];
    [webViewController setTrack:self.track];
    [self.navigationController pushViewController:webViewController animated:YES];

}

- (void) handleNotification:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:@"updatedMyTracks"]){
        [self handleMyTracksResponse:[notification userInfo]];
    }
}

- (void) handleMyTracksResponse:(NSDictionary*)notification
{
    NSMutableArray *myTracks = [[[notification objectForKey:@"my_tracks"] mutableCopy] cleanArray];
    if (NULL_TO_NIL(myTracks)) {
        [myTracks saveLocalWithKey:@"myTracks"];
    } else {
        [[[NSMutableArray alloc] init] destroyLocalWithKey:@"myTracks"];
    }
}

- (void) showDeepDiveScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSDeepDiveViewController *vc = (VSDeepDiveViewController*)[storyboard instantiateViewControllerWithIdentifier:@"deepDiveViewController"];
    [vc setTrack:self.track];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}



# pragma mark - Alert

- (void) showAlertWithText:(NSString*)text
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}


@end
