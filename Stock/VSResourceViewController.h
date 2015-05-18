//
//  VSResourceViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSResourceViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *resource;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void) setupWebView;

@end
