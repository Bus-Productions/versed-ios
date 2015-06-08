//
//  VSMessagesViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/8/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSSaveToMyTracksButton.h"

@interface VSMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    CGFloat maxComposeTextViewSize;
    VSSaveToMyTracksButton *saveToMyTracksButton;
}

@property (strong, nonatomic) NSMutableDictionary *track;
@property (strong, nonatomic) NSMutableArray *myTracksIDs;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *composeView;
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;

@property int page;

@property (strong, nonatomic) NSMutableArray* sections;
@property (strong, nonatomic) NSMutableArray* allMessages;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomVerticalSpaceConstraint;

- (IBAction)addAction:(id)sender;

@end
