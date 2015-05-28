//
//  VSSignupVIewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSSignupViewController.h"
#import "VSLoginViewController.h"
#import "VSAllTracksViewController.h"
#import "VSTokenViewController.h"
#import "AppDelegate.h"

@interface VSSignupViewController ()

@end

@implementation VSSignupViewController

@synthesize nameField, emailField, passwordField, passwordConfirmationField, signingUpUser;


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[LXSession thisSession] user] unconfirmed]) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
        VSTokenViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"tokenViewController"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else {
        self.signingUpUser = [NSMutableDictionary create:@"user"];
        [LXSession storeLocalUserKey:[self.signingUpUser localKey]];
    }
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
    [self.nameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.passwordConfirmationField resignFirstResponder];
}


# pragma mark - Helpers

- (BOOL) inputsVerified
{
    return self.passwordField.text && self.passwordField.text.length > 0 && self.passwordConfirmationField.text && self.passwordConfirmationField.text.length > 0 && [self.passwordField.text isEqualToString:self.passwordConfirmationField.text] && self.nameField && self.nameField.text.length > 0 && self.emailField && self.emailField.text.length > 0;
}

- (NSString *) errorMessage
{
    if (!self.nameField.text || self.nameField.text.length < 1)
        return @"Your must enter your name!";
    else if (!self.emailField.text || self.emailField.text.length < 1)
        return @"Your must enter your email!";
    else if (!self.passwordField.text || self.passwordField.text.length < 1)
        return @"You must enter a password!";
    else if (!self.passwordConfirmationField.text || self.passwordConfirmationField.text.length < 1)
        return @"You must confirm your password!";
    else if (![self.passwordField.text isEqualToString:self.passwordConfirmationField.text])
        return @"Your passwords must match!";
    
    return nil;
}

- (void) setAttributes
{
    [self.signingUpUser setObject:self.nameField.text forKey:@"name"];
    [self.signingUpUser setObject:self.emailField.text forKey:@"email"];
    [self.signingUpUser setObject:self.passwordField.text forKey:@"password"];
    [self.signingUpUser setObject:self.passwordField.text forKey:@"password_confirmation"];
}

# pragma mark - Actions

- (IBAction)signupAction:(id)sender
{
    if ([self inputsVerified]) {
        [self setAttributes];
        [self.signingUpUser saveRemote:^(id responseObject){
            if ([responseObject objectForKey:@"user"]) {
                self.signingUpUser = [[responseObject objectForKey:@"user"] cleanDictionary];
                [[LXSession thisSession] setUser:self.signingUpUser];
                [self.signingUpUser saveLocal];
            }
            if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] live]) {
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate setRootStoryboard:@"Main"];
            } else {
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
                VSTokenViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"tokenViewController"];
                [self.navigationController presentViewController:vc animated:YES completion:nil];
            }
        }failure:^(NSError *error) {
            [self showAlertWithText:@"Only certain companies are able to use Versed at this time. Contact your system administrator for more details." andTitle:@"Sorry, your company isn't using Versed."];
        }];
    } else {
        [self showAlertWithText:[self errorMessage]];
    }
}

- (IBAction)loginAction:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
    VSLoginViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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
@end
