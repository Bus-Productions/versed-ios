//
//  VSResourceViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/20/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSResourceViewController.h"
#import "AppDelegate.h"

@interface VSResourceViewController ()

@end

@implementation VSResourceViewController

@synthesize track, resource, webView;

- (void)viewDidLoad
{
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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [progressBarTimer invalidate];
}

- (void) viewDidDisappear:(BOOL)animated
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
}

# pragma mark - Setup

- (void) setupNavigationBar
{
    if (self.track && [self.track respondsToSelector:@selector(headline)]) {
        [self.navigationItem setTitle:[track headline]];
    } else {
        [self.navigationItem setTitle:@"VersedToday"];
    }
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void) setupWebView
{
    self.webView.scrollView.delegate = self;
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


# pragma mark - UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    myProgressView.progress = 0;
    webViewFinishedLoading = false;
    progressBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webViewFinishedLoading = true;
}

- (void) updateProgressBar
{
    if (webViewFinishedLoading) {
        if (myProgressView.progress >= 1) {
            myProgressView.hidden = true;
            [self updateConstraints];
            [progressBarTimer invalidate];
        }
        else {
            myProgressView.progress += 0.1;
        }
    }
    else {
        myProgressView.progress += 0.02;
        if (myProgressView.progress >= 0.95) {
            myProgressView.progress = 0.95;
        }
    }
}


# pragma mark - ScrollView

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yVelocity = [scrollView.panGestureRecognizer velocityInView:scrollView].y;
    if (yVelocity < 0) {
        [self hideNavBarOnSwipe:YES];
    } else if (yVelocity > 0) {
        [self hideNavBarOnSwipe:NO];
    }
}

- (void) hideNavBarOnSwipe:(BOOL)hide
{
    self.navigationController.hidesBarsOnSwipe = hide;
    [[self navigationController] setNavigationBarHidden:hide animated:YES];
}


# pragma mark - Constraints

- (void) updateConstraints
{
    self.webViewTopConstraint.constant = self.progressBarHeightConstraint.constant*-1;
    [UIView animateWithDuration:1.0 animations:^(void) {
        [self.view layoutIfNeeded];
    }];
}

@end
