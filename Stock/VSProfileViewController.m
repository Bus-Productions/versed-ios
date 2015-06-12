//
//  VSProfileViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/9/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSProfileViewController.h"
#import "VSProfileProgressTableViewCell.h"
#import "VSProfileTopicsTableViewCell.h"
#import "VSProfileSettingsTableViewCell.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface VSProfileViewController ()

@end

@implementation VSProfileViewController

@synthesize sections, slideButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSidebar];
    [self reloadScreen];
    [self setupKeyboard];
    
    [[self.navigationController.navigationBar.topItem rightBarButtonItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
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
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"progress"]) {
        return 180.0f;
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"settings"]) {
        return 180.0f;
    }
    return 160.0f;
}

# pragma mark - Actions

- (IBAction)logoutAction:(id)sender
{
    [[[LXSession thisSession] user] destroyLocal:^(id responseObject){
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate setRootStoryboard:@"MobileLogin"];
    }failure:nil];
}

- (IBAction)updateSettingsAction:(id)sender {
    NSString *name = [((UITextField*)[[sender superview] viewWithTag:4]) text];
    NSString *email = [((UITextField*)[[sender superview] viewWithTag:5]) text];
    NSString *password = [((UITextField*)[[sender superview] viewWithTag:6]) text];
    [self showHUDWithMessage:@"Saving"];
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@.json", [[[LXSession thisSession] user] ID]] withMethod:@"PUT" withParamaters:@{@"user": @{@"name": name, @"email": email, @"password": password}} authType:@"none" success:^(id responseObject){
        [self hideHUD]; 
        [self showHUDWithMessage:@"Saved!"];
        [hud hide:YES afterDelay:1.0];
        [self reloadScreen];
    }failure:^(NSError *error){
        [self hideHUD];
        [self showHUDWithMessage:@"Didn't save!"];
        [hud hide:YES afterDelay:1.0];
    }];
}


# pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = CGRectGetHeight(self.view.frame) + self.navigationController.navigationBar.frame.size.height - frame.origin.y + 20.0;
    self.tableViewBottomConstraint.constant = height;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
        [self scrollToBottom];
    }];
}

- (void) keyboardDidShow:(NSNotification*)notification
{
    [self scrollToBottom];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.tableViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}


# pragma mark - Scrolling

- (NSIndexPath*) lastIndexPath
{
    NSInteger lastSectionIndex = [self.tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:lastSectionIndex] - 1;
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}

- (void) scrollToBottom
{
    [self.tableView scrollToRowAtIndexPath:[self lastIndexPath] atScrollPosition: UITableViewScrollPositionBottom animated: YES];
}


# pragma mark - HUDs

- (void) showHUDWithMessage:(NSString*) message
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
}

- (void) hideHUD
{
    [hud hide:YES];
}


@end
