//
//  VSQuizPreviewViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/26/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSQuizPreviewViewController.h"

@interface VSQuizPreviewViewController ()

@end

@implementation VSQuizPreviewViewController

@synthesize titleLabel, quiz, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:[self.quiz quizName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Actions

- (IBAction)takeQuizAction:(id)sender {
    [self.delegate pushQuestionOnStack];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
