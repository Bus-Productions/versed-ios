//
//  VSQuizPreviewViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/26/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VSStartQuizDelegate <NSObject>
- (void) pushQuestionOnStack; 
@end

@interface VSQuizPreviewViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *quiz;
@property (nonatomic,assign) id delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

- (IBAction)cancelAction:(id)sender;
- (IBAction)takeQuizAction:(id)sender;

@end
