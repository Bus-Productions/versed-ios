//
//  VSFaqCategoryViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSFaqCategoryViewController.h"
#import "VSFaqTitleTableViewCell.h"
#import "VSFaqsListViewController.h"

@interface VSFaqCategoryViewController ()

@end

@implementation VSFaqCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self setupData];
    [self setupContactUsButton];
    [self reloadScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupSidebar
{
    [self setTitle:@"FAQ"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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


- (void) setupContactUsButton
{
    contactUsButton = [VSContactUsButton setup];
    [contactUsButton setTarget:self];
    [contactUsButton setAction:@selector(contactUsButtonPressed)]; 
    [self.navigationItem setRightBarButtonItem:contactUsButton];
}

- (void) setupData
{
    self.faqCategories = [[NSUserDefaults standardUserDefaults] objectForKey:@"faqCategories"] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"faqCategories"] mutableCopy] : [[NSMutableArray alloc] init];
}

- (void) reloadScreen
{
    [[LXServer shared] requestPath:@"/faq_categories.json" withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        self.faqCategories = [[[responseObject cleanDictionary] objectForKey:@"faq_categories"] mutableCopy];
        [self.tableView reloadData];
    }failure:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    [self.sections addObject:@"faqCategories"];
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"faqCategories"]) {
        return self.faqCategories.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"faqCategories"]) {
        return [self tableView:self.tableView faqCategoriesCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView faqCategoriesCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSFaqTitleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"faqCategoryCell" forIndexPath:indexPath];
    
    [cell configureWithFaq:[self.faqCategories objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"faqCategories"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSFaqsListViewController *vc = (VSFaqsListViewController*)[storyboard instantiateViewControllerWithIdentifier:@"faqsListViewController"];
        [vc setFaqCategory:[self.faqCategories objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES]; 
    }
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text;
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"faqCategories"]) {
        text = [[self.faqCategories objectAtIndex:indexPath.row] categoryName];
    }
    return [self heightForText:text width:(self.view.frame.size.width-40.0f) font:[UIFont fontWithName:@"SourceSansPro-Light" size:18.0]] + 40.0f;
}

# pragma mark - Contact Us

- (void) contactUsButtonPressed
{
    [contactUsButton pressedAction];
}

@end
