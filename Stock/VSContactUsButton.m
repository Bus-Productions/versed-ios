//
//  VSContactUsButton.m
//  Versed
//
//  Created by Joseph McArthur Gill on 6/11/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSContactUsButton.h"

@implementation VSContactUsButton

+ (VSContactUsButton*) setup
{
    VSContactUsButton *btn = [[VSContactUsButton alloc] init];
    [btn setTitle:@"Contact Us"];
    [btn setTintColor:[UIColor blueColor]];
    return btn;
}

- (void) pressedAction
{
    NSString *url = [@"mailto:m@lxv.io?subject=Versed iOS Questions/Comments" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
}

@end
