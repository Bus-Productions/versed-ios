//
//  VSDailyArticlesViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/18/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSDailyArticlesViewController.h"
#import "VSResourceTableViewCell.h"
#import "VSResourceViewController.h"
#import "SWRevealViewController.h"
#import "VSEmptyTableViewCell.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSDailyArticlesViewController ()

@end

@implementation VSDailyArticlesViewController

@synthesize tableView, slideButton, articles, sections;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self setupData];
    [self reloadScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupData
{
    self.articles = [[NSUserDefaults standardUserDefaults] objectForKey:@"dailyArticles"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyArticles"] mutableCopy] : [[NSMutableArray alloc] init];
}

- (void) setupSidebar
{
    [self setTitle:@"Daily Articles"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}


# pragma mark - Request/Reload

- (void) reloadScreen
{
    [[LXServer shared] requestPath:@"/resources/daily.json" withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        self.articles = [[[responseObject cleanDictionary] objectForKey:@"resources"] mutableCopy];
        if (NULL_TO_NIL(self.articles)) {
            [self.articles saveLocalWithKey:@"dailyArticles" success:^(id responseObject){
                [self.tableView reloadData];
            }failure:nil];
        } else {
            [[[NSMutableArray alloc] init] destroyLocalWithKey:@"dailyArticles" success:^(id responseObject){
                [self.tableView reloadData];
            }failure:nil];
        }
    }failure:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    if (self.articles.count < 1) {
        [self.sections addObject:@"empty"];
    } else {
        [self.sections addObject:@"articles"];
    }
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"articles"]) {
        return self.articles.count;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 1; 
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"articles"]) {
        return [self tableView:self.tableView articlesCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return [self tableView:self.tableView emptyCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView articlesCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSResourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"resourceCell" forIndexPath:indexPath];
    
    [cell configureWithResource:[self.articles objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    
    [cell configureWithText:@"Sorry there are no daily articles at this time!"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"articles"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSResourceViewController *vc = (VSResourceViewController*)[storyboard instantiateViewControllerWithIdentifier:@"resourceViewController"];
        [vc setResource:[self.articles objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
