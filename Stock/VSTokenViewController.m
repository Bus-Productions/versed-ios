//
//  VSTokenViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/26/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSTokenViewController.h"
#import "AppDelegate.h"

@interface VSTokenViewController ()

@end

@implementation VSTokenViewController

@synthesize tokenField;

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
    [self.tokenField resignFirstResponder];
}

# pragma mark - Actions

- (IBAction)verifyAction:(id)sender {
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/confirm/%@.json", [[[LXSession thisSession] user] ID], self.tokenField.text] withMethod:@"POST" withParamaters:nil authType:@"none" success:^(id responseObject){
        [self dismissKeyboard];
        [[LXSession thisSession] setUser:[[responseObject objectForKey:@"user"] cleanDictionary]];
        [[[responseObject objectForKey:@"user"] cleanDictionary] saveLocal];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate setRootStoryboard:@"Main"];
    }failure:^(NSError *error){
        [self showAlertWithText:@"Your token was incorrect."];
    }];
}

- (IBAction)resendAction:(id)sender {
    [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@/resend_token.json", [[[LXSession thisSession] user] ID]] withMethod:@"POST" withParamaters:nil authType:@"none" success:^(id responseObject){
        [self showAlertWithText:[NSString stringWithFormat:@"Your token was sent to %@", [[[LXSession thisSession] user] email]]];
    }failure:nil];
}

- (IBAction)backToSignupAction:(id)sender {
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
