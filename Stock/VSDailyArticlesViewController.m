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

@interface VSDailyArticlesViewController ()

@end

@implementation VSDailyArticlesViewController

@synthesize tableView, slideButton, articles;

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
        [self.articles saveLocalWithKey:@"dailyArticles"
                             success:^(id responseObject) {
                                 [self.tableView reloadData];
                             }
                             failure:nil];
    }failure:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSResourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"resourceCell" forIndexPath:indexPath];
    
    [cell configureWithResource:[self.articles objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSResourceViewController *vc = (VSResourceViewController*)[storyboard instantiateViewControllerWithIdentifier:@"resourceViewController"];
    [vc setResource:[self.articles objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
