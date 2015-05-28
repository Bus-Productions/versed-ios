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

@interface VSLoginViewController ()

@end

@implementation VSLoginViewController

@synthesize emailField, passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGestureRecognizer];
    [self setupNavigationBar]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
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
        [[LXServer shared] requestPath:@"/login.json" withMethod:@"POST" withParamaters:@{@"user": @{@"email": self.emailField.text, @"password": self.passwordField.text} } authType:@"user"
                      success:^(id responseObject){
                          NSMutableDictionary *u = [[responseObject objectForKey:@"user"] mutableCopy];
                          if (u) {
                              [LXSession storeLocalUserKey:[u localKey]];
                              [u saveLocal:^(id responseObject){
                                  if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] live]) {
                                      AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                      [appDelegate setRootStoryboard:@"Main"];
                                  } else {
                                      UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
                                      VSTokenViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"tokenViewController"];
                                      [self.navigationController presentViewController:vc animated:YES completion:nil];
                                  }
                              }failure:nil];
                          }
                      }failure:^(NSError* error) {
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
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}
@end
