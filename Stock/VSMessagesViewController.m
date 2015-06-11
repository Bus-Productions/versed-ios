//
//  VSMessagesViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/8/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSMessagesViewController.h"
#import "VSCompletedTrackTitleTableViewCell.h"
#import "VSMessageTableViewCell.h"
#import "VSEmptyTableViewCell.h"

@interface VSMessagesViewController ()

@end

@implementation VSMessagesViewController

@synthesize sections;
@synthesize allMessages;
@synthesize tableView;
@synthesize composeTextView;
@synthesize composeView;
@synthesize saveButton;
@synthesize bottomConstraint;
@synthesize tableviewHeightConstraint;
@synthesize textViewHeightConstraint;
@synthesize textViewBottomVerticalSpaceConstraint;
@synthesize textViewTopVerticalSpaceConstraint;
@synthesize page;
@synthesize track;
@synthesize myTracksIDs; 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setupProperties];
    [self setNavTitle];
    
    [self setupConstraints];
    [self observeKeyboard];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.composeTextView resignFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self toggleSaveButton];
    [self setTableScrollToIndex:self.allMessages.count animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Setup

- (void) setupProperties
{
    [composeTextView setScrollEnabled:NO];
    [composeTextView.layer setCornerRadius:4.0f];
    [self setPage:0];
    
    maxComposeTextViewSize = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - ([UIApplication sharedApplication].statusBarFrame.size.height-20.0) - (self.composeView.frame.size.height - self.composeTextView.frame.size.height);
}

- (void) setNavTitle
{
    saveToMyTracksButton = [VSSaveToMyTracksButton initWithTrack:self.track andMyTrackIDs:myTracksIDs];
    [saveToMyTracksButton addTarget:self action:@selector(saveMyTrackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:saveToMyTracksButton];
}

-(void) setupConstraints
{
    self.composeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.composeView];
    
    NSDictionary *views = @{@"view": self.composeView,
                            @"top": self.topLayoutGuide };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[top][view]" options:0 metrics:nil views:views]];
    
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self.composeView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:self.bottomConstraint];
}



# pragma mark - Actions

- (void) saveMyTrackButtonPressed
{
    [saveToMyTracksButton updateMyTracks];
}


- (void) toggleSaveButton
{
    if (self.composeTextView.text && self.composeTextView.text.length > 0 && [self.composeTextView.textColor isEqual:[UIColor blackColor]]) {
        [self.saveButton setEnabled:YES];
    } else {
        [self.saveButton setEnabled:NO];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.sections = [[NSMutableArray alloc] init];
    [self.sections addObject:@"title"];
    if (self.allMessages.count > 0) {
        [self.sections addObject:@"messages"];
    } else {
        [self.sections addObject:@"empty"];
    }
    return self.sections.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] isEqualToString:@"title"]) {
        return 1;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"messages"]) {
        return self.allMessages.count;
    } else if ([[self.sections objectAtIndex:section] isEqualToString:@"empty"]) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"title"]) {
        return [self tableView:self.tableView titleCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"messages"]) {
        return [self tableView:self.tableView messageCellForRowAtIndexPath:indexPath];
    } else if ([[self.sections objectAtIndex:indexPath.section] isEqualToString:@"empty"]) {
        return [self tableView:self.tableView emptyCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView titleCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSCompletedTrackTitleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];

    [cell configureForDiscussionWithTrack:self.track];

    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView messageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSMessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    [cell configureWithMessage:[self.allMessages objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView emptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSEmptyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
    
    [cell configureWithText:@"Nobody has completed this track yet. Be the first!"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



# pragma mark Keyboard Notifications

- (void) observeKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void) keyboardWillShow:(NSNotification *)sender
{
    [self setTableScrollToIndex:self.allMessages.count animated:YES];
    
    NSDictionary *info = [sender userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomConstraint.constant = frame.origin.y - (CGRectGetHeight(self.view.frame) + self.navigationController.navigationBar.frame.size.height)-([UIApplication sharedApplication].statusBarFrame.size.height);
    
    self.tableviewHeightConstraint.constant = self.tableviewHeightConstraint.constant - frame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) keyboardWillHide:(NSNotification *)sender
{
    NSDictionary *info = [sender userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = 0;
    
    self.tableviewHeightConstraint.constant = self.view.frame.size.height - self.saveButton.frame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) keyboardWillChangeFrame:(NSNotification *)sender
{
    CGRect frame = [self.view convertRect:[[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    maxComposeTextViewSize = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - ([UIApplication sharedApplication].statusBarFrame.size.height) - (self.composeView.frame.size.height - self.composeTextView.frame.size.height) - frame.size.height;
}



# pragma mark Textview

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self setTableScrollToIndex:self.allMessages.count animated:YES];
    
    if ([textView.text isEqualToString:@"Write a comment..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self updateConstraintsForTextView:textView];
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a comment...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (void) textViewDidChange:(UITextView *)textView
{
    [self toggleSaveButton];
    if (textView.text.length == 0) {
        [textView setText:@""];
        [textView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    } else {
        textView.textColor = [UIColor blackColor];
    }
    [self updateConstraintsForTextView:textView];
}

- (void) updateConstraintsForTextView:(UITextView *)textView
{
    CGFloat contentSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, 10000.0f)].height;
    CGFloat newSize = MIN(maxComposeTextViewSize, contentSize);
    CGFloat curSize = self.textViewHeightConstraint.constant;
    CGFloat difference = newSize-curSize;
    
    if (contentSize > newSize) {
        [textView setScrollEnabled:YES];
    } else {
        [textView setScrollEnabled:NO];
    }
    
    if (difference!=0.0f) {
        self.textViewHeightConstraint.constant = newSize;
        self.tableviewHeightConstraint.constant = self.tableviewHeightConstraint.constant - difference - self.textViewTopVerticalSpaceConstraint.constant - self.textViewBottomVerticalSpaceConstraint.constant;
        
        [UIView animateWithDuration:0.0
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                         }
         ];
        [self setTableScrollToIndex:self.allMessages.count animated:YES];
    }
}


- (void) clearTextField:(BOOL)dismissKeyboard
{
    self.textViewHeightConstraint.constant = self.saveButton.frame.size.height - self.textViewTopVerticalSpaceConstraint.constant - self.textViewBottomVerticalSpaceConstraint.constant;
    
    if ([self.composeTextView attributedText] && [[self.composeTextView attributedText] length] > 0) {
        [self.composeTextView setAttributedText:[[NSAttributedString alloc] initWithString:@""]];
        [self.composeTextView setText:@""];
        [self.composeTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    }
    
    if (!dismissKeyboard && [self.composeTextView isFirstResponder]) {
        self.composeTextView.text = @"";
        self.composeTextView.textColor = [UIColor blackColor];
    } else {
        self.composeTextView.text = @"Write a comment...";
        self.composeTextView.textColor = [UIColor lightGrayColor];
        [self.composeTextView resignFirstResponder];
    }
}

- (void) setTableScrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    index = index - 1;
    if (self.allMessages.count > 0 && index < self.allMessages.count) {
        NSIndexPath *ipath = [NSIndexPath indexPathForRow:index inSection:[self.sections indexOfObject:@"messages"]];
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: animated];
    }
}

# pragma mark - Actions

- (void) addAction:(id)sender
{
    NSMutableDictionary *mess = [NSMutableDictionary create:@"message"];
    [mess setObject:self.composeTextView.text forKey:@"message_text"];
    [mess setObject:[self.track ID] forKey:@"track_id"];
    [mess setObject:[[[LXSession thisSession] user] ID] forKey:@"user_id"];
    [self.allMessages addObject:mess];
    [self.tableView reloadData];
    [self updateConstraintsForTextView:self.composeTextView];
    [self clearTextField:YES];
    [mess saveRemote:^(id responseObject){
        self.allMessages = [[responseObject objectForKey:@"messages"] mutableCopy];
        [self.tableView reloadData];
        [self updateConstraintsForTextView:self.composeTextView];
    }failure:^(NSError *error){
        [self showAlertWithText:@"Your message did not get sent!"];
    }];
}

# pragma mark - Alert

- (void) showAlertWithText:(NSString*)text
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}
@end
