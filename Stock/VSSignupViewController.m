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
@import QuartzCore;

@interface VSSignupViewController ()

@end

@implementation VSSignupViewController

@synthesize nameField, emailField, passwordField, passwordConfirmationField;
@synthesize signUpButton, hasAccountButton;
@synthesize signingUpUser;
@synthesize infoLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.signingUpUser = [NSMutableDictionary create:@"user"];
    if ([[[LXSession thisSession] user] unconfirmed]) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
        VSTokenViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"tokenViewController"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else {
        [LXSession storeLocalUserKey:[self.signingUpUser localKey]];
    }
    
    [self setupGestureRecognizer];
    [self setupNavigationBar];
    [self setupTextFieldAppearances];
    [self setupButtonAppearances];
    [self setupInfoLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) setupInfoLabel
{
    [self.infoLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:13.0f]];
    //[self.infoLabel setText:@"*Only certain companies are able to use Versed.\nBy tapping Create Account, you agree to the\nTerms and Conditions and Privacy Policy."];
    [self.infoLabel setText:@"*Only certain companies are able to use Versed."];
}

- (void) setupButtonAppearances
{
    [[self.signUpButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    self.signUpButton.layer.cornerRadius = 4;
    self.signUpButton.clipsToBounds = YES;
    
    [[self.hasAccountButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0f]];
}

- (void) setupTextFieldAppearances
{
    [self addBottomBorderToField:self.nameField];
    [self addBottomBorderToField:self.emailField];
    [self addBottomBorderToField:self.passwordField];
    [self addBottomBorderToField:self.passwordConfirmationField];
    
    [self setTintForField:self.nameField withPlaceholder:@"Name"];
    [self setTintForField:self.emailField withPlaceholder:@"Company Email*"];
    [self setTintForField:self.passwordField withPlaceholder:@"Password"];
    [self setTintForField:self.passwordConfirmationField withPlaceholder:@"Confirm Password"];
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

# pragma mark - Actions

- (IBAction)signupAction:(id)sender
{
    if ([self inputsVerified]) {
        
        [self.signingUpUser setObject:self.nameField.text forKey:@"name"];
        [self.signingUpUser setObject:self.emailField.text forKey:@"email"];
        [self.signingUpUser setObject:self.passwordField.text forKey:@"password"];
        [self.signingUpUser setObject:self.passwordField.text forKey:@"password_confirmation"];
        
        [self showHUDWithMessage:@"Registering..."];
        
        [self.signingUpUser saveRemote:^(id responseObject){
            if ([responseObject objectForKey:@"user"]) {
                self.signingUpUser = [[[responseObject cleanDictionary] objectForKey:@"user"] mutableCopy];
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
            [self hideHUD];
        }failure:^(NSError *error) {
            [self hideHUD];
            [self showAlertWithText:[error localizedDescription] andTitle:@"Sorry!"];
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
    [self showAlertWithText:text andTitle:nil];
}

- (void) showAlertWithText:(NSString*)text andTitle:(NSString*)title
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}


# pragma mark text field delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag < 4) {
        NSInteger nextTag = textField.tag + 1;
        for (UITextField* field in [self.view subviews]) {
            if ([field isKindOfClass:[UITextField class]] && [field tag] == nextTag) {
                [field becomeFirstResponder];
            }
        }
    } else {
        [self signupAction:textField];
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
