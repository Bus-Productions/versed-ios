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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSMutableDictionary *quiz;
@property (nonatomic,assign) id delegate;

- (IBAction)takeQuizAction:(id)sender;

@end
