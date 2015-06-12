//
//  VSDailyArticlesViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/18/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSDailyArticlesViewController.h"
#import "VSResourceTableViewCell.h"
#import "SWRevealViewController.h"
#import "VSEmptyTableViewCell.h"
#import "SVWebViewController.h"


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

- (void) viewDidAppear:(BOOL)animated
{
    [self hideNavBarOnSwipe:NO];
}

# pragma mark - Setup

- (void) setupData
{
    self.articles = [[NSUserDefaults standardUserDefaults] objectForKey:@"dailyArticles"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyArticles"] mutableCopy] : [[NSMutableArray alloc] init];
    completedResources = [[NSMutableArray alloc] init];
}

- (void) setupSidebar
{
    [self setTitle:@"Versed Daily"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    
}

# pragma mark - Request/Reload

- (void) reloadScreen
{
    [[LXServer shared] requestPath:@"/resources/daily.json" withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        self.articles = [[[responseObject cleanDictionary] objectForKey:@"resources"] mutableCopy];
        completedResources = [[responseObject objectForKey:@"completed_resources"] pluckIDs] ;
        if (NULL_TO_NIL(self.articles)) {
            [self.articles saveLocalWithKey:@"dailyArticles" success:^(id responseObject){
                [self.tableView reloadData];
            }failure:nil];
        } else {
            NSLog(@"not going to save");
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
    
    [self.sections addObject:@"header"];
    
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
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"header"]) {
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
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return [self tableView:self.tableView headerCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView articlesCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"resourceCell" forIndexPath:indexPath];
    
    NSMutableDictionary* article = [self.articles objectAtIndex:indexPath.row];
    
    UIView* container = (UIView*)[cell.contentView viewWithTag:10];
    
    UILabel* number = (UILabel*)[container viewWithTag:1];
    [number setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:32.0f]];
    [number setText:[NSString stringWithFormat:@"%li", indexPath.row+1]];
    
    UILabel* title = (UILabel*)[container viewWithTag:2];
    [title setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [title setText:[article headline]];
    
    UILabel* source = (UILabel*)[container viewWithTag:3];
    [source setTextColor:[UIColor grayColor]];
    [source setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [source setText:[article objectForKey:@"source"]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    
    [cell configureWithText:@"Sorry there are no daily articles at this time!"];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView headerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:1];
    [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [label setText:@"Stay versed with the top 5 need\nto know topics each day."];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"articles"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [self createResourceUserPairAtIndexPath:indexPath];
        });
        
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:(NSString*)[[self.articles objectAtIndex:indexPath.row] url]];
        [self hideNavBarOnSwipe:YES];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return 146.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"articles"]) {
        return 82.0f; //[(VSResourceTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath] heightForRow];
    }
    return 136.0f;
}

- (void) hideNavBarOnSwipe:(BOOL)hide
{
    self.navigationController.hidesBarsOnSwipe = hide;
}


- (void) createResourceUserPairAtIndexPath:(NSIndexPath*)indexPath
{
    NSMutableDictionary *rup = [NSMutableDictionary create:@"resource_user_pair"];
    [rup setObject:[[self.articles objectAtIndex:indexPath.row] ID] forKey:@"resource_id"];
    [rup setObject:[[[LXSession thisSession] user] ID] forKey:@"user_id"];
    [rup setObject:@"completed" forKey:@"status"];
    
    [rup saveRemote:^(id responseObject){
        [[LXSession thisSession] setUser:[[[responseObject objectForKey:@"user"] cleanDictionary] mutableCopy]];
        [self reloadScreen];
    }failure:nil];
}

@end
