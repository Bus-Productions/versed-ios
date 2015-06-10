//
//  VSProfileViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSProfileViewController.h"
#import "SWRevealViewController.h"
#import "VSProfileProgressTableViewCell.h"
#import "VSProfileTopicsTableViewCell.h"
#import "VSProfileSettingsTableViewCell.h"

@interface VSProfileViewController ()

@end

@implementation VSProfileViewController

@synthesize sections, slideButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSidebar];
    [self reloadScreen];
    [self setupKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Setup

- (void) setupSidebar
{
    [self setTitle:@"Snapshot and Settings"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.slideButton setTarget: self.revealViewController];
        [self.slideButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void) setupKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) reloadScreen
{
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@.json", [[[LXSession thisSession] user] ID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
        [[LXSession thisSession] setUser:[[[responseObject objectForKey:@"user"] cleanDictionary] mutableCopy] success:^(id responseObject){
            [self.tableView reloadData];
        }failure:nil];
    }failure:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    
    [self.sections addObject:@"progress"];
    [self.sections addObject:@"topics"];
    [self.sections addObject:@"settings"];
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"progress"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"topics"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"settings"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"progress"]) {
        return [self tableView:self.tableView progressCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"topics"]) {
        return [self tableView:self.tableView topicsCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"settings"]) {
        return [self tableView:self.tableView settingsCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView progressCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSProfileProgressTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"progressCell" forIndexPath:indexPath];
    
    [cell configure];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView topicsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSProfileTopicsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"topicsCell" forIndexPath:indexPath];
    
    [cell configure];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView settingsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSProfileSettingsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"settingsCell" forIndexPath:indexPath];
    
    [cell configure];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
}

# pragma mark - Actions

- (IBAction)updateSettingsAction:(id)sender {
    
}


# pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"table = %f", self.tableHeight.constant);
//    self.tableHeight.constant = self.tableHeight.constant-frame.size.height;
    self.tableHeight.constant = -10000.0;
    [self.tableView setNeedsUpdateConstraints];

    [UIView animateWithDuration:animationDuration animations:^{
//        [self.tableView setContentInset:UIEdgeInsetsMake(0.f, 0.f, frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, 0.f)];
        [self.view layoutIfNeeded];
    }];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.tableHeight.constant = self.view.frame.size.height;
    [self.tableView setNeedsUpdateConstraints];

    [UIView animateWithDuration:animationDuration animations:^{
//        [self.tableView setContentInset:UIEdgeInsetsZero];
        [self.view layoutIfNeeded];
    }];
}

@end
