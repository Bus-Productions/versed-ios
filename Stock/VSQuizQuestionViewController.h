//
//  VSQuizViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/13/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSQuizQuestionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL alreadyAnswered; 
}

@property (strong, nonatomic) NSMutableArray *sections; 
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *question; 

@end
