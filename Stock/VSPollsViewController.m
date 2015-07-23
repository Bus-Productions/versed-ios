//
//  VSPollsViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 7/17/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPollsViewController.h"
#import "VSPollsTableViewCell.h"
#import "VSPollQuestionViewController.h"
#import "VSPollResultsViewController.h"
#import "VSEmptyTableViewCell.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSPollsViewController ()

@end

@implementation VSPollsViewController

@synthesize tableView, slideButton, polls, sections;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self setupData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadScreen];
}


# pragma mark - Setup

- (void) setupSidebar
{
    [self setTitle:@"Guesstimates"];
    
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
    self.polls = [[NSUserDefaults standardUserDefaults] objectForKey:@"polls"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"polls"] mutableCopy] : [[NSMutableArray alloc] init];
    pollKeys = [[NSMutableArray alloc] init];
    [self setupPollKeys];
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
    [[LXServer shared] requestPath:@"/polls.json" withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        [self handlePollsResponse:responseObject];
    }failure:nil];
}


- (void) handlePollsResponse:(NSDictionary *)responseObject
{
    self.polls = [[[responseObject objectForKey:@"polls"] cleanArray] mutableCopy];
    [self setupPollKeys];
    if (NULL_TO_NIL(self.polls)) {
        [self.polls saveLocalWithKey:@"polls" success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    } else {
        [[[NSMutableArray alloc] init] destroyLocalWithKey:@"polls" success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    }
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    if (self.polls.count < 1) {
        [self.sections addObject:@"empty"];
    } else {
        return pollKeys.count;
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sections.count > 0 && [[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 1;
    }
    return [[[self.polls objectAtIndex:section] objectForKey:[pollKeys objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sections.count > 0 && [[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return [self tableView:self.tableView emptyCellForRowAtIndexPath:indexPath];
    } else {
        return [self tableView:self.tableView pollsCellForRowAtIndexPath:indexPath];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView pollsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSPollsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pollCell" forIndexPath:indexPath];
    [cell configureWithPoll:[self getPollAtIndexPath:indexPath] andIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];

    [cell configureWithText:@"Sorry there are no guesstimates at this time!"];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sections.count == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NSMutableDictionary *p = [self getPollAtIndexPath:indexPath];
        if (!NULL_TO_NIL([p objectForKey:@"user_answer"])) {
            VSPollQuestionViewController *vc = (VSPollQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollQuestionViewController"];
            [vc setPoll:p];
            [vc setHideRightBarButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VSPollResultsViewController *vc = (VSPollResultsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollResultsViewController"];
            [vc setPoll:p];
            [vc setHideRightBarButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sections.count > 0 && [[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return 100.0f;
    }
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.sections.count > 0 && [[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 0;
    }
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.0f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.tableView.frame.size.width, 30.0f)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0f]];
    [label setText:[pollKeys objectAtIndex:section]];
    [label setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (NSMutableDictionary*) getPollAtIndexPath:(NSIndexPath*)indexPath
{
    return [[[[self.polls objectAtIndex:indexPath.section] objectForKey:[pollKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] mutableCopy];
}

- (void) setupPollKeys
{
    [pollKeys removeAllObjects];
    for (NSDictionary*dict in self.polls) {
        [pollKeys addObjectsFromArray:[dict allKeys]];
    }
}
@end
