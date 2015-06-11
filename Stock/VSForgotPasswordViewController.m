//
//  VSForgotPasswordViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/28/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSForgotPasswordViewController.h"

@interface VSForgotPasswordViewController ()

@end

@implementation VSForgotPasswordViewController

@synthesize forgotPasswordTextField;
@synthesize resetPasswordButton, cancelButton;
@synthesize descriptionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGestureRecognizer];
    [self setupTextFieldAppearances];
    [self setupButtonAppearances];
    [self setupLabelAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupLabelAppearance
{
    [self.descriptionLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:24.0f]];
}

- (void) setupButtonAppearances
{
    [[self.resetPasswordButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    self.resetPasswordButton.layer.cornerRadius = 4;
    self.resetPasswordButton.clipsToBounds = YES;
    [self.resetPasswordButton setBackgroundColor:[UIColor whiteColor]];
    [[self.resetPasswordButton titleLabel] setTextColor:[UIColor blackColor]];
    
    [[self.cancelButton layer] setBorderWidth:1.0f];
    [[self.cancelButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[self.cancelButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f]];
    [[self.cancelButton titleLabel] setTextColor:[UIColor whiteColor]];
}

- (void) setupTextFieldAppearances
{
    [self addBottomBorderToField:self.forgotPasswordTextField];
    
    [self setTintForField:self.forgotPasswordTextField withPlaceholder:@"Company Email"];
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
    [self.forgotPasswordTextField resignFirstResponder];
}


# pragma mark - Actions

- (IBAction)resetPasswordAction:(id)sender
{
    if (self.forgotPasswordTextField.text && self.forgotPasswordTextField.text.length > 0) {
        [self dismissKeyboard];
        [[LXServer shared] requestPath:@"/forgot_password.json" withMethod:@"POST" withParamaters:@{@"email": self.forgotPasswordTextField.text} authType:@"none" success:nil failure:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self showAlertWithText:@"You must enter an email!"];
    }
}

- (IBAction)backToLoginAction:(id)sender
{
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - Alert

- (void) showAlertWithText:(NSString*)text
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}


# pragma mark text field delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self resetPasswordAction:textField];
    return NO;
}

@end
