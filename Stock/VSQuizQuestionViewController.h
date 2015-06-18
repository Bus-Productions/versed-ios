//
//  VSQuizViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VSCreateQuizResultDelegate <NSObject>
- (void) createQuizResultWithQuestion:(NSMutableDictionary *)question andAnswer:(NSMutableDictionary *)answer success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback;
- (void) updateQuizQuestions;
@end

@interface VSQuizQuestionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSTimer *timer;
    int remainingTime;
    BOOL alreadyAnswered;
    BOOL requesting; 
}

@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *quizResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *question;
@property (nonatomic) NSUInteger totalQuestions;
@property (nonatomic) NSUInteger questionsCompleted;
@property (nonatomic,assign) id delegate;

@end
