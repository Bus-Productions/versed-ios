//
//  VSFaqsListViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSContactUsButton.h"

@interface VSFaqsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    VSContactUsButton *contactUsButton; 
}
@property (strong, nonatomic) NSMutableDictionary *faqCategory;
@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
