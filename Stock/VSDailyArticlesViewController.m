//
//  VSDailyArticlesViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/18/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSDailyArticlesViewController.h"
#import "VSResourceTableViewCell.h"
#import "VSEmptyTableViewCell.h"
#import "VSPurchaseViewController.h"
#import "VSResourceViewController.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface VSDailyArticlesViewController ()

@end

@implementation VSDailyArticlesViewController

@synthesize tableView, slideButton, articles, sections;

- (void)viewDidLoad
{
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


# pragma mark - Orientations

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return YES;
}


# pragma mark - Setup

- (void) setupData
{
    self.articles = [[NSUserDefaults standardUserDefaults] objectForKey:@"dailyArticles"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyArticles"] mutableCopy] : [[NSMutableArray alloc] init];
    completedResources = [[NSMutableArray alloc] init];
}

- (void) setupSidebar
{
    [self setTitle:@"Versed Today"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    [revealViewController setDelegate:self]; 
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
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
    VSResourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"resourceCell" forIndexPath:indexPath];
    
    [cell configureWithResource:[self.articles objectAtIndex:indexPath.row] andCompletedResources:completedResources];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    
    [cell configureWithText:@"Sorry there are no daily articles at this time!" andBackgroundColor:nil];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView headerCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:1];
    [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [label setText:@"Check out the five resources \nmost recently added to Versed"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"articles"]) {
//        if ([[LXPurchase thisPurchase] shouldPromptToBuy]) {
//            [self showPurchaseScreen];
//        } else {
            [self showResourceAtIndexPath:indexPath];
//        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"header"]) {
        return 130.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"articles"]) {
        NSMutableDictionary *res = [self.articles objectAtIndex:indexPath.row];
        return 117.0f + ([completedResources containsObject:[NSNumber numberWithInt:[[res ID] intValue]]] ? -10.0 : [self heightForText:[res objectForKey:@"description"] width:(self.view.frame.size.width-30.0f) font:[UIFont fontWithName:@"SourceSansPro-Regular" size:13.0f]]);
    }
    return 80.0f;
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


# pragma mark - Actions

- (void) showResourceAtIndexPath:(NSIndexPath*)indexPath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self createResourceUserPairAtIndexPath:indexPath];
    });
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSResourceViewController *webViewController = (VSResourceViewController*)[storyboard instantiateViewControllerWithIdentifier:@"resourceViewController"];
    [webViewController setResource:[self.articles objectAtIndex:indexPath.row]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:webViewController animated:YES];
}


- (void) showPurchaseScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VSPurchaseViewController *vc = (VSPurchaseViewController*)[storyboard instantiateViewControllerWithIdentifier:@"purchaseViewController"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
@end
