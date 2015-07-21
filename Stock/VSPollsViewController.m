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
        NSLog(@"responseObject = %@", responseObject);
        [self handlePollsResponse:responseObject];
    }failure:nil];
}


- (void) handlePollsResponse:(NSDictionary *)responseObject
{
    self.polls = [[[responseObject objectForKey:@"polls"] cleanArray] mutableCopy] ;
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
        [self.sections addObject:@"polls"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"polls"]) {
        return self.polls.count;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"polls"]) {
        return [self tableView:self.tableView pollsCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return [self tableView:self.tableView emptyCellForRowAtIndexPath:indexPath];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView pollsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSPollsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pollCell" forIndexPath:indexPath];
    [cell configureWithPoll:[[self.polls objectAtIndex:indexPath.row] mutableCopy]];
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
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"polls"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NSMutableDictionary *p = [[self.polls objectAtIndex:indexPath.row] mutableCopy];
        if (!NULL_TO_NIL([p objectForKey:@"user_answer"])) {
            VSPollQuestionViewController *vc = (VSPollQuestionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollQuestionViewController"];
            [vc setPoll:p];
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
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"polls"]) {
        return 100.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return 100.0f;
    }
    return 100.0f;
}


@end
