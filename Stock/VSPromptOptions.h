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

- (IBAction)topAction:(id)sender;
- (IBAction)bottomAction:(id)sender;

@end
