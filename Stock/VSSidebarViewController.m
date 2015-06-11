//
//  VSSidebarViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSSidebarViewController.h"
#import "VSMyTracksViewController.h"
#import "VSQuizQuestionViewController.h"
#import "VSAllTracksViewController.h"
#import "SWRevealViewController.h"
#import "VSDailyArticlesViewController.h"
#import "VSQuizLandingViewController.h"
#import "VSProfileViewController.h"
#import "VSProfileTableViewCell.h"

#define ALL_TRACKS_IDENTIFIER @"allTracks"
#define MY_TRACKS_IDENTIFIER @"myTracks"
#define QUIZ_IDENTIFIER @"quiz"
#define PROFILE_IDENTIFIER @"profile"
#define DAILY_ARTICLES_IDENTIFIER @"dailyArticles"


@interface VSSidebarViewController ()

@end

@implementation VSSidebarViewController

@synthesize tableView, menuOptions, menuIdentifiers;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenu];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void) setupMenu
{
    self.menuOptions = [[NSMutableArray alloc] init];
    [self.menuOptions addObject:PROFILE_IDENTIFIER];
    [self.menuOptions addObject:ALL_TRACKS_IDENTIFIER];
    [self.menuOptions addObject:MY_TRACKS_IDENTIFIER];
    [self.menuOptions addObject:QUIZ_IDENTIFIER];
    [self.menuOptions addObject:DAILY_ARTICLES_IDENTIFIER];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuOptions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:PROFILE_IDENTIFIER]) {
        return [self tableView:self.tableView profileCellForRowAtIndexPath:indexPath];
    } else {
        return [self tableView:self.tableView basicMenuCellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView profileCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSProfileTableViewCell *profileCell = [self.tableView dequeueReusableCellWithIdentifier:PROFILE_IDENTIFIER forIndexPath:indexPath];
    [profileCell configure];
    return profileCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView basicMenuCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[self.menuOptions objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
    UILabel* label = (UILabel*) [cell.contentView viewWithTag:1];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealViewController = self.revealViewController;

    UIViewController *vc;
    UINavigationController *nc = [[UINavigationController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:ALL_TRACKS_IDENTIFIER]) {
        vc = (VSAllTracksViewController*)[storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    } else if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:MY_TRACKS_IDENTIFIER]) {
        vc = (VSMyTracksViewController*)[storyboard instantiateViewControllerWithIdentifier:@"myTracksViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"myTracksNavigationController"];
    } else if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:QUIZ_IDENTIFIER]) {
        vc = (VSQuizLandingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizLandingViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"quizQuestionsNavigationViewController"];
    } else if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:DAILY_ARTICLES_IDENTIFIER]) {
        vc = (VSDailyArticlesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"dailyArticlesViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"dailyArticlesNavigationController"];
    } else if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:PROFILE_IDENTIFIER]) {
        vc = (VSProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"profileNavigationController"];
    }
    
    [nc setViewControllers:@[vc] animated:NO];

    [revealViewController setFrontViewController:nc];
    [revealViewController revealToggleAnimated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:PROFILE_IDENTIFIER]) {
        return 80.0f;
    }
    return 52.0f;
}

@end
