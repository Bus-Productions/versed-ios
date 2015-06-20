//
//  VSResourceViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/20/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSResourceViewController.h"

@interface VSResourceViewController ()

@end

@implementation VSResourceViewController

@synthesize track, resource, webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


# pragma mark - Setup

- (void) setupNavigationBar
{
    [self.navigationItem setTitle:[track headline]];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void) setupWebView
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: [resource url]] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 15.0];
    [self.webView loadRequest: request];
}


# pragma mark - Actions

- (void) shareAction:(id)sender
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    [sharingItems addObject:@"Found in Versed:\n"];
    if ([self.resource url]) {
        [sharingItems addObject:[self.resource url]];
    }
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}


@end
