//
//  VSFaqShowViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSContactUsButton.h"

@interface VSFaqShowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    VSContactUsButton *contactUsButton; 
}
@property (strong, nonatomic) NSMutableDictionary *faq;
@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
