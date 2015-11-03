//
//  VSDeepDiveViewController.h
//  Versed
//
//  Created by Joseph Gill on 11/2/15.
//  Copyright © 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSDeepDiveViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableDictionary *track;
@end
