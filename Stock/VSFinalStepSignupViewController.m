//
//  VSFinalStepSignupViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/22/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSFinalStepSignupViewController.h"

@interface VSFinalStepSignupViewController ()

@end

@implementation VSFinalStepSignupViewController

@synthesize nameField, passwordField, passwordConfirmationField;
@synthesize signUpButton;
@synthesize infoLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGestureRecognizer];
    [self setupNavigationBar];
    [self setupTextFieldAppearances];
    [self setupButtonAppearances];
    [self setupInfoLabel];
    [self prepopulateFields];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissKeyboard];
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

- (void) setupKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) prepopulateFields
{
    if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] name] && [[[LXSession thisSession] user] name].length > 0) {
        [self.nameField setText:[[[LXSession thisSession] user] name]]; 
    }
}

- (void) setupInfoLabel
{
    [self.infoLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:13.0f]];
    //[self.infoLabel setText:@"*Only certain companies are able to use Versed.\nBy tapping Create Account, you agree to the\nTerms and Conditions and Privacy Policy."];
//    [self.infoLabel setText:@"*Only certain companies are able to use Versed."];
    [self.infoLabel setText:@""];
}

- (void) setupButtonAppearances
{
    [[self.signUpButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    self.signUpButton.layer.cornerRadius = 4;
    self.signUpButton.clipsToBounds = YES;
}

- (void) setupTextFieldAppearances
{
    [self addBottomBorderToField:self.nameField];
    [self addBottomBorderToField:self.passwordField];
    [self addBottomBorderToField:self.passwordConfirmationField];
    
    [self setTintForField:self.nameField withPlaceholder:@"Name"];
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
    [self.passwordField resignFirstResponder];
    [self.passwordConfirmationField resignFirstResponder];
}


# pragma mark - Helpers

- (BOOL) inputsVerified
{
    return self.passwordField.text && self.passwordField.text.length > 0 && self.passwordConfirmationField.text && self.passwordConfirmationField.text.length > 0 && [self.passwordField.text isEqualToString:self.passwordConfirmationField.text] && self.nameField && self.nameField.text.length > 0;
}

- (NSString *) errorMessage
{
    if (!self.nameField.text || self.nameField.text.length < 1)
        return @"Your must enter your name!";
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
        NSMutableDictionary *user = [[[LXSession thisSession] user] mutableCopy];
        [user setObject:self.nameField.text forKey:@"name"];
        [user setObject:self.passwordField.text forKey:@"password"];
        [user setObject:self.passwordField.text forKey:@"password_confirmation"];
        
        [self showHUDWithMessage:@"Registering..."];
        
        [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/final_step_signup.json", [user ID]] withMethod:@"POST" withParamaters:@{@"user": user} success:^(id responseObject){
            if ([responseObject objectForKey:@"user"]) {
                [[LXSession thisSession] setUser:[[[responseObject cleanDictionary] objectForKey:@"user"] mutableCopy]];
                [[[LXSession thisSession] user] saveLocal];
            }
            if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] live]) {
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate setRootStoryboard:@"Main"];
            }
            [self dismissKeyboard]; 
            [self hideHUD];
        }failure:^(NSError *error){
            [self hideHUD];
            [self showAlertWithText:@"Sorry there was a problem"];
        }]; 
    } else {
        [self showAlertWithText:[self errorMessage]];
    }
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
