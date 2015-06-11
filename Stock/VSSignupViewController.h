//
//  VSSignupVIewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSSignupViewController : UIViewController <UITextFieldDelegate>
{
    MBProgressHUD* hud;
}

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationField;

@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *hasAccountButton;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) NSMutableDictionary *signingUpUser;

- (IBAction)signupAction:(id)sender;
- (IBAction)loginAction:(id)sender;

@end
