//
//  VSFinalStepSignupViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/22/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSAllTracksViewController.h"
#import "AppDelegate.h"
@import QuartzCore;

@interface VSFinalStepSignupViewController : UIViewController <UITextFieldDelegate>
{
    MBProgressHUD* hud;
}

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationField;

@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

- (IBAction)signupAction:(id)sender;

@end
