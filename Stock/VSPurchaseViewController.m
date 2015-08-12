//
//  VSPurchaseViewController.m
//  Versed
//
//  Created by Joseph Gill on 8/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPurchaseViewController.h"

@interface VSPurchaseViewController ()

@end

@implementation VSPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Actions

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
