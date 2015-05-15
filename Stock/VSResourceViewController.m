//
//  VSResourceViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSResourceViewController.h"

@interface VSResourceViewController ()

@end

@implementation VSResourceViewController

@synthesize resource, webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[self.resource headline]];
    [self setupWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupWebView
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: [self.resource url]] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 20.0];
    [self.webView loadRequest: request];
}
@end
