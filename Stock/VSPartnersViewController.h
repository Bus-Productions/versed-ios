//
//  VSPartnersViewController.h
//  Versed
//
//  Created by Joseph Gill on 10/28/15.
//  Copyright © 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface VSPartnersViewController : UIViewController <SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *companyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;

@end
