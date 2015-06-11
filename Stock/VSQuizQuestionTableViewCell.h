//
//  VSQuizQuestionTableViewCell.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/19/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSQuizQuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

- (void) configureWithQuestion:(NSMutableDictionary*)question;
- (void) updateTimerLabel:(int)time;

@end
