//
//  VSQuizResultsViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/20/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSWeaknessesTableViewCell.h"

@protocol VSRefreshQuizLandingVC <NSObject>
- (void) reloadScreen;
- (NSInteger) pointsForRound;
@end

@interface VSQuizResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL isRequesting;
    NSInteger pointsThatRound; 
}
@property (strong, nonatomic) NSMutableArray *quizResults;
@property (strong, nonatomic) NSMutableArray *missedQuestions;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (nonatomic,assign) id delegate;

@end
