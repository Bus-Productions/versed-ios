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
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
        NSLog(@"faqs = %@", self.faqCategories);
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

# pragma mark - Contact Us

- (void) contactUsButtonPressed
{
    [contactUsButton pressedAction];
}

@end
