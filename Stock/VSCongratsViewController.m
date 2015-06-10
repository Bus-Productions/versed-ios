//
//  VSCongratsViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/10/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSCongratsViewController.h"

@interface VSCongratsViewController ()

@end

@implementation VSCongratsViewController

@synthesize track; 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)notNowAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil]; 
}
@end
