//
//  VSQuizLandingViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSQuizLandingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *quizQuestions;
@property (strong, nonatomic) NSMutableArray *quizResults;
@property (strong, nonatomic) NSMutableArray *questionsToAsk;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
