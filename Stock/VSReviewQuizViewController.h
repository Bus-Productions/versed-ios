//
//  VSReviewQuizViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 7/14/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSReviewQuizViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *quizResults;
@property (strong, nonatomic) NSMutableArray *missedQuestions;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (nonatomic) NSInteger pointsThatRound;

@end
