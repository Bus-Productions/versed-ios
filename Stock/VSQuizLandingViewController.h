//
//  VSQuizLandingViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSQuizLandingViewController : UIViewController
{
    int questionIndex;
}

@property (strong, nonatomic) NSMutableArray *quizQuestions;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;

- (IBAction)startQuiz:(id)sender;

@end
