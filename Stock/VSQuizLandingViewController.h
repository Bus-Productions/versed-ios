//
//  VSQuizLandingViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSQuizLandingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int questionIndex;
}

@property (strong, nonatomic) NSMutableArray *quizQuestions;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
