//
//  VSQuizResultsViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/20/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSQuizResultsViewController.h"
#import "VSOverallResultsTableViewCell.h"

@interface VSQuizResultsViewController ()

@end

@implementation VSQuizResultsViewController

@synthesize quizResults, tableView, sections, totalQuestions, questionsCompleted;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    if (self.quizResults.count > 0) {
        [self.sections addObject:@"showResults"];
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"showResults"]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"showResults"]) {
        return [self tableView:self.tableView showResultsCellForRowAtIndexPath:indexPath];
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView showResultsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSOverallResultsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"overallResultsCell" forIndexPath:indexPath];
    [cell configureWithQuizResult:self.quizResults];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



@end
