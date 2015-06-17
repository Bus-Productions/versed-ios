//
//  VSFaqCategoryViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "VSContactUsButton.h"

@interface VSFaqCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWRevealViewControllerDelegate>
{
    VSContactUsButton *contactUsButton;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideButton;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *faqCategories;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
