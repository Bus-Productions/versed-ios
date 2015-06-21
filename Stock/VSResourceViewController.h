//
//  VSResourceViewController.h
//  Versed
//
//  Created by Joseph McArthur Gill on 6/20/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSResourceViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>
{
    BOOL webViewFinishedLoading;
    IBOutlet UIProgressView* myProgressView;
    NSTimer *progressBarTimer;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSMutableDictionary *resource;
@property (strong, nonatomic) NSMutableDictionary *track;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBarHeightConstraint;

@end
