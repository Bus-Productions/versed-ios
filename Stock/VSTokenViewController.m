//
//  VSTokenViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/26/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSTokenViewController.h"
#import "AppDelegate.h"
#import "VSFinalStepSignupViewController.h"

@interface VSTokenViewController ()

@end

@implementation VSTokenViewController

@synthesize tokenField;
@synthesize nameLabel, descriptionLabel, instructionsLabel;
@synthesize verifyButton, resendButton, cancelButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGestureRecognizer];
    [self setupNavigationBar];
    [self setupLabels];
    [self setupButtonAppearances];
    [self setupTextFieldAppearances];
    [self setupConstraints];
    [self setupKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissKeyboard];
}

# pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) setupConstraints
{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
}

- (void) setupKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) setupLabels
{
    [self.nameLabel setText:@"Welcome!"];
    [self.nameLabel setFont:[UIFont fontWithName:@"SourceSansPro-Black" size:24.0f]];
    [self.nameLabel setClipsToBounds:NO];
    [self.nameLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.descriptionLabel setText:@"We're excited for you to get started."];
    [self.descriptionLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    [self.descriptionLabel setClipsToBounds:NO];
    [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.instructionsLabel setText:@"One final thing: for security purposes, we sent a 4-digit authorization code to your email address. Type in the code below and you'll be all set."];
    [self.instructionsLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
}

- (void) setupButtonAppearances
{
    [[self.verifyButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    self.verifyButton.layer.cornerRadius = 4;
    self.verifyButton.clipsToBounds = YES;
    [self.verifyButton setBackgroundColor:[UIColor whiteColor]];
    [[self.verifyButton titleLabel] setTextColor:[UIColor blackColor]];
    
    [[self.cancelButton layer] setBorderWidth:1.0f];
    [[self.cancelButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[self.cancelButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [[self.cancelButton titleLabel] setTextColor:[UIColor whiteColor]];
    
    [[self.resendButton layer] setBorderWidth:1.0f];
    [[self.resendButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[self.resendButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    [[self.resendButton titleLabel] setTextColor:[UIColor whiteColor]];
}

- (void) setupTextFieldAppearances
{
    [self addBottomBorderToField:self.tokenField];
    
    [self setTintForField:self.tokenField withPlaceholder:@"0000"];
}

- (void) addBottomBorderToField:(UITextField*)field
{
    CGFloat borderHeight = 1.0f;
    
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0, field.frame.size.height-borderHeight, field.frame.size.width, 1.0f);
    bottomBorder1.backgroundColor = [UIColor whiteColor].CGColor;
    
    [field.layer addSublayer:bottomBorder1];
}

- (void) setTintForField:(UITextField*)field withPlaceholder:(NSString*)placeholderText
{
    [field setTintColor:[UIColor whiteColor]];
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5], NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:32.0f]}];
    [field setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:32.0f]];
}

# pragma mark - Gestures

- (void) setupGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void) dismissKeyboard
{
    [self.tokenField resignFirstResponder];
}

# pragma mark - Actions

- (IBAction)verifyAction:(id)sender {
    if (self.tokenField.text && self.tokenField.text.length > 0) {
        [self showHUDWithMessage:@"Verifying"];
        [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/confirm/%@.json", [[[LXSession thisSession] user] ID], self.tokenField.text] withMethod:@"POST" withParamaters:nil authType:@"none" success:^(id responseObject){
            [[LXSession thisSession] setUser:[[responseObject cleanDictionary] objectForKey:@"user"]];
            [self dismissKeyboard];
            [self hideHUD];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
            VSFinalStepSignupViewController *vc = (VSFinalStepSignupViewController*)[storyboard instantiateViewControllerWithIdentifier:@"finalStepSignupViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }failure:^(NSError *error){
            [self hideHUD]; 
            [self showAlertWithText:@"Your token was incorrect."];
        }];
    } else {
        [self showAlertWithText:@"You must enter a token!"];
    }
}

- (IBAction)resendAction:(id)sender {
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/resend_token.json", [[[LXSession thisSession] user] ID]] withMethod:@"POST" withParamaters:nil authType:@"none" success:^(id responseObject){
        [self showAlertWithText:[NSString stringWithFormat:@"Your token was sent to %@", [[[LXSession thisSession] user] email]] andTitle:@"Sent!"];
    }failure:nil];
}

- (IBAction)backToSignupAction:(id)sender
{
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Alert

- (void) showAlertWithText:(NSString*)text
{
    [self showAlertWithText:text andTitle:@"Whoops!"];
}

- (void) showAlertWithText:(NSString*)text andTitle:(NSString*)title
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}


# pragma mark text field delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self verifyAction:textField];
    return NO;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (value.length == 4 && range.length <= 0) { //adding, not deleting
        [self performSelector:@selector(verifyAction:) withObject:nil afterDelay:0.1];
    }
    return YES;
}

# pragma mark hud delegate

- (void) showHUDWithMessage:(NSString*) message
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
    [hud setColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:0.8]];
    [hud setLabelFont:[UIFont fontWithName:@"SourceSansPro-Light" size:14.0f]];
}

- (void) hideHUD
{
    if (hud) {
        [hud hide:YES];
    }
}


# pragma mark - Keyboard

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height+10.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    [self.scrollView scrollRectToVisible:self.verifyButton.frame animated:YES];
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
