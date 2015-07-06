//
//  VSIntroViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 7/6/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSIntroViewController : UIViewController

@property (nonatomic) NSUInteger index;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) NSString* text;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) NSString *image; 

- (void) setMessage:(NSString*)message;

@end
