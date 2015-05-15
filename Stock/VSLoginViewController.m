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
#import "VSLimboViewController.h"

@interface VSLoginViewController ()

@end

@implementation VSLoginViewController

@synthesize emailField, passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                          NSLog(@"loginAction response = %@", responseObject);
                          NSMutableDictionary *u = [[responseObject objectForKey:@"user"] mutableCopy];
                          if (u) {
                              [LXSession storeLocalUserKey:[u localKey]];

                              [u saveLocal:^(id responseObject){
                                  NSLog(@"***local = %@", [LXServer objectWithLocalKey:[u localKey]]);
                                  if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] live]) {
                                      UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                      VSAllTracksViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
                                      [self.navigationController presentViewController:vc animated:YES completion:nil];
                                  } else {
                                      UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
                                      VSLimboViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"limboViewController"];
                                      [self.navigationController presentViewController:vc animated:YES completion:nil];
                                  }
                              }failure:^(NSError *error) {
                                  
                              }];
                          }
                      }failure:^(NSError* error) {
                          NSLog(@"damn %@", error);
                      }
         ];
    } else {
        NSLog(@"error = %@", [self errorMessage]);
    }
}

- (IBAction)signupAction:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MobileLogin" bundle:[NSBundle mainBundle]];
    VSSignupViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"signupViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
