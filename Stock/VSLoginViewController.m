//
//  VSLoginViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSLoginViewController.h"
#import "VSSignupViewController.h"
#import "VSAllTracksViewController.h"
#import "VSTokenViewController.h"
#import "AppDelegate.h"
#import "VSForgotPasswordViewController.h"
@import QuartzCore;

@interface VSLoginViewController ()

@end

@implementation VSLoginViewController

@synthesize emailField, passwordField;
@synthesize signInButton;
@synthesize forgotPasswordButton;
@synthesize createAccountButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizer];
    [self setupNavigationBar];
    [self setupButtonAppearances];
    [self setupTextFieldAppearances];
}

- (void)didReceiveMemoryWarning
{
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


- (void) setupButtonAppearances
{
    [[self.signInButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    self.signInButton.layer.cornerRadius = 4;
    self.signInButton.clipsToBounds = YES;
    [self.signInButton setBackgroundColor:[UIColor whiteColor]];
    [[self.signInButton titleLabel] setTextColor:[UIColor blackColor]];
    
    [[self.forgotPasswordButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]];
    [[self.forgotPasswordButton titleLabel] setTextColor:[UIColor whiteColor]];
    
    [[self.createAccountButton layer] setBorderWidth:1.0f];
    [[self.createAccountButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[self.createAccountButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    [[self.createAccountButton titleLabel] setTextColor:[UIColor whiteColor]];
}

- (void) setupTextFieldAppearances
{
    [self addBottomBorderToField:self.emailField];
    [self addBottomBorderToField:self.passwordField];
    
    [self setTintForField:self.emailField withPlaceholder:@"Company Email"];
    [self setTintForField:self.passwordField withPlaceholder:@"Password"];
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
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5], NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]}];
    [field setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.5f]];
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
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

# pragma mark - Helpers

- (BOOL) inputsVerified
{
    return self.passwordField.text && self.passwordField.text.length > 0 && self.emailField && self.emailField.text.length > 0;
}

- (NSString *) errorMessage
{
    if (!self.emailField.text || self.emailField.text.length < 1)
        return @"Your must enter your email!";
    else if (!self.passwordField.text || self.passwordField.text.length < 1)
        return @"You must enter a password!";
    
    return nil;
}


# pragma mark - Actions

- (IBAction)loginAction:(id)sender
{
    if ([self inputsVerified]) {
        
        [self showHUDWithMessage:@"Logging in..."];
        
        [[LXServer shared] requestPath:@"/login.json" withMethod:@"POST" withParamaters:@{@"user": @{@"email": self.emailField.text, @"password": self.passwordField.text} } authType:@"user"
                      success:^(id responseObject){
                          NSMutableDictionary *u = [[[responseObject cleanDictionary] objectForKey:@"user"] mutableCopy];
                          if (u) {
                              [LXSession storeLocalUserKey:[u localKey]];
                              [[LXSession thisSession] setCachedUser:u];
                              [u saveLocal:^(id responseObject){
                                  if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] live]) {
                                      [self.emailField resignFirstResponder];
                                      [self.passwordField resignFirstResponder];
                                      AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                      [appDelegate setRootStoryboard:@"Main"];
                                  } else {
                                      UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
                                      VSTokenViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"tokenViewController"];
                                      [self.navigationController presentViewController:vc animated:YES completion:nil];
                                  }
                              }failure:nil];
                          }
                          [self hideHUD];
                      }failure:^(NSError* error) {
                          [self hideHUD];
                          [self showAlertWithText:@"Sorry your login information is incorrect!"];
                      }
         ];
    } else {
        [self showAlertWithText:[self errorMessage]];
    }
}

- (IBAction)signupAction:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
    VSSignupViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"signupViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)forgotPassword:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
    VSForgotPasswordViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"forgotPasswordViewController"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}



# pragma mark - Alert

- (void) showAlertWithText:(NSString*)text
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}



# pragma mark text field delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag < 2) {
        NSInteger nextTag = textField.tag + 1;
        for (UITextField* field in [self.view subviews]) {
            if ([field isKindOfClass:[UITextField class]] && [field tag] == nextTag) {
                [field becomeFirstResponder];
            }
        }
    } else {
        [self loginAction:textField];
    }
    return NO;
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


@end
