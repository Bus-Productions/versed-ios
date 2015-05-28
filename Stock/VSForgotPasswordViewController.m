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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextField];
    [self setupGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupTextField
{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, self.forgotPasswordTextField.frame.size.height - borderWidth, self.forgotPasswordTextField.frame.size.width, self.forgotPasswordTextField.frame.size.height);
    border.borderWidth = borderWidth;
    [self.forgotPasswordTextField.layer addSublayer:border];
    self.forgotPasswordTextField.layer.masksToBounds = YES;
    
    if ([self.forgotPasswordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        self.forgotPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    }
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

- (IBAction)backToLoginAction:(id)sender {
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - Alert

- (void) showAlertWithText:(NSString*)text
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:text delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [av show];
}

@end
