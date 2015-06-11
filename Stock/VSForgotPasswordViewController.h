//
//  VSForgotPasswordViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/28/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSForgotPasswordViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *forgotPasswordTextField;

@property (strong, nonatomic) IBOutlet UIButton *resetPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

- (IBAction)resetPasswordAction:(id)sender;
- (IBAction)backToLoginAction:(id)sender;

@end
