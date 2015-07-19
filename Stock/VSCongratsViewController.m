//
//  VSCongratsViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/10/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSCongratsViewController.h"
#import "VSCongratsFeedbackTableViewCell.h"
#import "VSCongratsStatusTableViewCell.h"
#import "VSCongratsTracksTableViewCell.h"

@interface VSCongratsViewController ()

@end

@implementation VSCongratsViewController

@synthesize track, tableView, sections;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Feedback"]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    [self.sections addObject:@"status"];
    [self.sections addObject:@"tracks"];
    [self.sections addObject:@"feedback"];
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"status"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"tracks"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"feedback"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"status"]) {
        return [self tableView:self.tableView statusCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"tracks"]) {
        return [self tableView:self.tableView tracksCompletedCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"feedback"]) {
        return [self tableView:self.tableView feedbackCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView statusCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSCongratsStatusTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"congratsStatusCell" forIndexPath:indexPath];
    
    [cell configureWithTrack:self.track];
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView tracksCompletedCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSCongratsTracksTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"congratsTracksCell" forIndexPath:indexPath];
    
    [cell configure];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView feedbackCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSCongratsFeedbackTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"congratsFeedbackCell" forIndexPath:indexPath];
    
    [cell configure];
    [cell.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"status"]) {
        return 240;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"tracks"]) {
        return 80;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"feedback"]) {
        return 230;
    }
    return 100;
}


# pragma mark - Actions

- (IBAction)notNowAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil]; 
}

- (IBAction)submitFeedbackAction:(id)sender
{
    VSCongratsFeedbackTableViewCell *cell = (VSCongratsFeedbackTableViewCell*)[self.tableView cellForRowAtIndexPath:[self lastIndexPath]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSMutableDictionary *fb = [NSMutableDictionary create:@"feedback"];
        [fb setObject:cell.sliderValue forKey:@"rating"];
        [fb setObject:[self.track ID] forKey:@"track_id"];
        [fb setObject:[[[LXSession thisSession] user] ID] forKey:@"user_id"];
        [fb saveRemote];
    });

    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - Slider

- (IBAction)sliderValueChanged:(UISlider *)sender {
    VSCongratsFeedbackTableViewCell *cell = (VSCongratsFeedbackTableViewCell*)[self.tableView cellForRowAtIndexPath:[self lastIndexPath]];
    [cell sliderChanged]; 
}


# pragma mark - Helpers

- (NSIndexPath*) lastIndexPath
{
    NSInteger lastSectionIndex = [self.tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:lastSectionIndex] - 1;
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}
@end
