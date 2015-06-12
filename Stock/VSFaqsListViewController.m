//
//  VSFaqsListViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSFaqsListViewController.h"
#import "VSFaqTitleTableViewCell.h"
#import "VSFaqShowViewController.h"

@interface VSFaqsListViewController ()

@end

@implementation VSFaqsListViewController

@synthesize faqCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupContactUsButton]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:[self.faqCategory categoryName]];
}

- (void) setupContactUsButton
{
    contactUsButton = [VSContactUsButton setup];
    [contactUsButton setTarget:self];
    [contactUsButton setAction:@selector(contactUsButtonPressed)];
    [self.navigationItem setRightBarButtonItem:contactUsButton];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    [self.sections addObject:@"faqCategory"];
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"faqCategory"]) {
        return [[self.faqCategory faqs] count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"faqCategory"]) {
        return [self tableView:self.tableView faqCategoriesCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView faqCategoriesCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSFaqTitleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"faqCategoryCell" forIndexPath:indexPath];
    
    [cell configureWithFaq:[[self.faqCategory faqs] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"faqCategory"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSFaqShowViewController *vc = (VSFaqShowViewController*)[storyboard instantiateViewControllerWithIdentifier:@"faqShowViewController"];
        [vc setFaq:[[self.faqCategory faqs] objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

# pragma mark - Contact Us

- (void) contactUsButtonPressed
{
    [contactUsButton pressedAction];
}

@end