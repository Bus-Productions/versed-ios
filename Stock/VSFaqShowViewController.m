//
//  VSFaqShowViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSFaqShowViewController.h"
#import "VSFaqQuestionTableViewCell.h"
#import "VSFaqResponseTableViewCell.h"

@interface VSFaqShowViewController ()

@end

@implementation VSFaqShowViewController

@synthesize faq;

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
    [self.navigationItem setTitle:@"Question"];
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
    
    [self.sections addObject:@"faqQuestion"];
    [self.sections addObject:@"faqResponse"];
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"faqQuestion"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"faqResponse"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"faqQuestion"]) {
        return [self tableView:self.tableView faqQuestionCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"faqResponse"]) {
        return [self tableView:self.tableView faqResponseCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView faqQuestionCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSFaqQuestionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"faqQuestionCell" forIndexPath:indexPath];
    
    [cell configureWithFaq:self.faq];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView faqResponseCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSFaqResponseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"faqResponseCell" forIndexPath:indexPath];
    
    [cell configureWithFaq:self.faq];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

# pragma mark - Contact Us

- (void) contactUsButtonPressed
{
    [contactUsButton pressedAction];
}
@end
