//
//  VSSidebarViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSSidebarViewController.h"
#import "VSTracksViewController.h"
#import "VSQuizViewController.h"
#import "VSMainViewController.h"
#import "SWRevealViewController.h"

#define ALL_TRACKS_IDENTIFIER @"allTracks"
#define MY_TRACKS_IDENTIFIER @"myTracks"
#define QUIZ_IDENTIFIER @"quiz"

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


- (void) setupMenu
{
    self.menuOptions = [[NSMutableArray alloc] init];
    [self.menuOptions addObject:ALL_TRACKS_IDENTIFIER];
    [self.menuOptions addObject:MY_TRACKS_IDENTIFIER];
    [self.menuOptions addObject:QUIZ_IDENTIFIER];
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[self.menuOptions objectAtIndex:indexPath.row] forIndexPath:indexPath];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealViewController = self.revealViewController;
    UIViewController *vc;
    UINavigationController *nc;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:ALL_TRACKS_IDENTIFIER]) {
        vc = (VSMainViewController*)[storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    } else if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:MY_TRACKS_IDENTIFIER]) {
        vc = (VSTracksViewController*)[storyboard instantiateViewControllerWithIdentifier:@"myTracksViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"myTracksNavigationController"];
    } else if ([[self.menuOptions objectAtIndex:indexPath.row] isEqualToString:QUIZ_IDENTIFIER]) {
        vc = (VSQuizViewController*)[storyboard instantiateViewControllerWithIdentifier:@"quizViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"quizNavigationController"];
    }


    [nc setViewControllers:@[vc] animated:NO];
    
    [revealViewController setFrontViewController:nc];
    [revealViewController revealToggleAnimated:YES];
}


@end
