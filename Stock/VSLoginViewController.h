//
//  VSLoginViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginAction:(id)sender;
- (IBAction)signupAction:(id)sender;
- (IBAction)forgotPassword:(id)sender;

@end
