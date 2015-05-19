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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Setup

- (void) setupWebView
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: [self.resource url]] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 15.0];
    [self.webView loadRequest: request];
}


#pragma mark - Optional UIWebViewDelegate delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
