//
//  VSTokenViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/26/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSTokenViewController : UIViewController <UITextFieldDelegate>
{
    MBProgressHUD* hud;
}

@property (weak, nonatomic) IBOutlet UITextField *tokenField;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;

@property (strong, nonatomic) IBOutlet UIButton *verifyButton;
@property (strong, nonatomic) IBOutlet UIButton *resendButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)verifyAction:(id)sender;
- (IBAction)resendAction:(id)sender;
- (IBAction)backToSignupAction:(id)sender;

@end
