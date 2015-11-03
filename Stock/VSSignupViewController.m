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
#import "VSFinalStepSignupViewController.h"

@import QuartzCore;

@interface VSSignupViewController ()

@end

@implementation VSSignupViewController

@synthesize emailField;
@synthesize signUpButton, hasAccountButton;
@synthesize signingUpUser;
@synthesize infoLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizer];
    [self setupNavigationBar];
    [self setupTextFieldAppearances];
    [self setupButtonAppearances];
    [self setupInfoLabel];
    if ([[[LXSession thisSession] user] unconfirmed]) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
        VSTokenViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"tokenViewController"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
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

- (void) viewWillAppear:(BOOL)animated
{
    self.signingUpUser = [NSMutableDictionary create:@"user"];
    if ([[[LXSession thisSession] user] live] && ![[[LXSession thisSession] user] name]) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
        VSFinalStepSignupViewController* vc = (VSFinalStepSignupViewController*)[storyboard instantiateViewControllerWithIdentifier:@"finalStepSignupViewController"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else {
        [LXSession storeLocalUserKey:[self.signingUpUser localKey]];
    }
}


# pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) setupKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) setupInfoLabel
{
    [self.infoLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:13.0f]];
    //[self.infoLabel setText:@"*Only certain companies are able to use Versed.\nBy tapping Create Account, you agree to the\nTerms and Conditions and Privacy Policy."];
    [self.infoLabel setText:@""];
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
    [self addBottomBorderToField:self.emailField];
    [self setTintForField:self.emailField withPlaceholder:@"Company Email*"];
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
}


# pragma mark - Helpers

- (BOOL) inputsVerified
{
    return self.emailField && self.emailField.text.length > 0 && [self.emailField.text rangeOfString:@"@"].location != NSNotFound;
}

- (NSString *) errorMessage
{
    if (!self.emailField.text || self.emailField.text.length < 1 || [self.emailField.text rangeOfString:@"@"].location == NSNotFound)
        return @"Your must enter your email!";
    
    return nil;
}

# pragma mark - Actions

- (IBAction)signupAction:(id)sender
{
    if ([self inputsVerified]) {
        
        [self.signingUpUser setObject:self.emailField.text forKey:@"email"];
        
        [self showHUDWithMessage:@"Registering..."];
        [self.signingUpUser removeObjectForKey:@"password"];
        [self.signingUpUser removeObjectForKey:@"password_confirmation"]; 
        [self.signingUpUser saveRemote:^(id responseObject){
            NSLog(@"****");
            NSLog(@"%@", responseObject);
            NSLog(@"****");
            if ([responseObject objectForKey:@"user"]) {
                self.signingUpUser = [[[responseObject cleanDictionary] objectForKey:@"user"] mutableCopy];
                [[LXSession thisSession] setUser:self.signingUpUser];
                [self.signingUpUser saveLocal:nil failure:nil];
                if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] live]) {
                    [self loginAction:nil];
                } else if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] unconfirmed]) {
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
                    VSTokenViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"tokenViewController"];
                    [self.navigationController presentViewController:vc animated:YES completion:nil];
                } else if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] deleted]) {
                    [self showAlertWithText:@"Your account has been deleted. Contact your company!"];
                }
            }
            [self hideHUD];
        }failure:^(NSError *error) {
            [self hideHUD];
            [self showAlertWithText:@"There was a problem with your sign in. Try again!" andTitle:@"Sorry!"];
        }];
        
    } else {
        [self showAlertWithText:[self errorMessage]];
    }
}

- (IBAction)loginAction:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
    VSLoginViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    if (self.emailField.text && self.emailField.text.length > 0) {
        [vc setEmailText:self.emailField.text];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)privacyPolicyAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://versed-app.herokuapp.com/privacy"]];
}

- (IBAction)tocAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://versed-app.herokuapp.com/terms"]];
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
    [self signupAction:textField];
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
