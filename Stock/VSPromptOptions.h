//
//  VSPromptOptions.h
//  Versed
//
//  Created by Will Schreiber on 7/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSPromptOptions : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *topButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomButton;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIImageView *versedImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoToTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)topAction:(id)sender;
- (IBAction)bottomAction:(id)sender;

@end
