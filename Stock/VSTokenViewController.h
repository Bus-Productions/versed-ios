//
//  VSTokenViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/26/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSTokenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tokenField;

- (IBAction)verifyAction:(id)sender;
- (IBAction)resendAction:(id)sender;

@end
