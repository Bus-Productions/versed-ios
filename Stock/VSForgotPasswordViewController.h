//
//  VSForgotPasswordViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/28/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSForgotPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *forgotPasswordTextField;

- (IBAction)resetPasswordAction:(id)sender;
- (IBAction)backToLoginAction:(id)sender;

@end
