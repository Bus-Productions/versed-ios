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
#import "VSFaqCategoryViewController.h"
#import "VSPollsViewController.h"
#import <QuartzCore/QuartzCore.h>

#define ALL_TRACKS_IDENTIFIER @"allTracks"
#define MY_TRACKS_IDENTIFIER @"myTracks"
#define QUIZ_IDENTIFIER @"quiz"
#define PROFILE_IDENTIFIER @"profile"
#define DAILY_ARTICLES_IDENTIFIER @"dailyArticles"
#define FAQ_IDENTIFIER @"faq"
#define POLLS_IDENTIFIER @"polls"
#define CONTACT_US_IDENTIFIER @"contactUs"


@interface VSSidebarViewController ()

@end

@implementation VSSidebarViewController

@synthesize tableView, menuOptions, menuIdentifiers;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMenu];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self addSwipeGestureRecognizer];
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
    [self.menuOptions addObject:DAILY_ARTICLES_IDENTIFIER];
    [self.menuOptions addObject:QUIZ_IDENTIFIER];
    [self.menuOptions addObject:POLLS_IDENTIFIER];
    
    self.bottomOptions = [[NSMutableArray alloc] init];
    [self.bottomOptions addObject:FAQ_IDENTIFIER];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    [self.sections addObject:@"mainMenu"];
    [self.sections addObject:@"bottom"];
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"mainMenu"]) {
        return self.menuOptions.count;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"bottom"]) {
        return self.bottomOptions.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"mainMenu"]) {
        if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:PROFILE_IDENTIFIER]) {
            return [self tableView:self.tableView profileCellForRowAtIndexPath:indexPath];
        } else {
            return [self tableView:self.tableView basicMenuCellForRowAtIndexPath:indexPath];
        }
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"bottom"]) {
        return [self tableView:self.tableView basicMenuCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView profileCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSProfileTableViewCell *profileCell = [self.tableView dequeueReusableCellWithIdentifier:PROFILE_IDENTIFIER forIndexPath:indexPath];
    [profileCell configure];
    return profileCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView basicMenuCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"mainMenu"]) {
        identifier = [self.menuOptions objectAtIndex:indexPath.row];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"bottom"]) {
        identifier = [self.bottomOptions objectAtIndex:indexPath.row];
    }
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    UILabel* label = (UILabel*) [cell.contentView viewWithTag:1];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0];
    cell.selectedBackgroundView = selectionColor;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealViewController = self.revealViewController;

    UIViewController *vc;
    UINavigationController *nc = [[UINavigationController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"mainMenu"]) {
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
        } else if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:POLLS_IDENTIFIER]) {
            vc = (VSPollsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pollsViewController"];
            nc = [storyboard instantiateViewControllerWithIdentifier:@"pollsNavigationController"];
        }
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"bottom"]) {
        if ([[self.bottomOptions objectAtIndex:indexPath.row] isEqualToString:FAQ_IDENTIFIER]) {
            vc = (VSFaqCategoryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"faqCategoryViewController"];
            nc = [storyboard instantiateViewControllerWithIdentifier:@"faqNavigationController"];
        }
    }
    
    [nc setViewControllers:@[vc] animated:NO];

    [revealViewController setFrontViewController:nc];
    [revealViewController revealToggleAnimated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"mainMenu"]) {
        if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:PROFILE_IDENTIFIER]) {
            return 80.0f;
        }
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"bottom"]) {
        if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:PROFILE_IDENTIFIER]) {
            return 70.0f;
        }
    }
    return 52.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"mainMenu"]) {
        return 0.0;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"bottom"]) {
        return self.tableView.frame.size.height - 80.0f - (52.0*(self.menuOptions.count-1)) - (70.0*self.bottomOptions.count) - 20.0f; //20.0f for status bar, 80.0f for profile, 52.0 for basic cells
    }
    return 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"mainMenu"]) {
        return nil;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"bottom"]) {
        UIView *header = [[UIView alloc] init];
        [header setBackgroundColor:[UIColor clearColor]];
        return header;
    }
    return nil;
}

# pragma mark - other

- (void) addSwipeGestureRecognizer
{
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    [self.revealViewController revealToggle:nil];
}
@end
