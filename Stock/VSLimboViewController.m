//
//  VSLimboViewController.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSLimboViewController.h"
#import "VSAllTracksViewController.h"

@interface VSLimboViewController ()

@end

@implementation VSLimboViewController

@synthesize requestTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestTimer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(requestUser) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.requestTimer forMode:NSDefaultRunLoopMode];
    [self.requestTimer fire];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (self.requestTimer) {
        [self.requestTimer invalidate];
        self.requestTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Requests

- (void) requestUser
{
    NSMutableDictionary *u = [[LXSession thisSession] userFromDefaults];
    if (u && [u live]) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        VSAllTracksViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else {
        NSLog(@"user = %@", u);
        if (u) {
            [[LXServer shared] requestPath:[NSString stringWithFormat:@"/users/%@.json", [u ID]] withMethod:@"GET" withParamaters:nil authType:@"user"
                                   success:^(id responseObject){
                                       NSLog(@"responseObject = %@", responseObject);
                                       if ([responseObject objectForKey:@"user"] && [[responseObject objectForKey:@"user"] live]) {
                                           [[responseObject objectForKey:@"user"] saveLocal];
                                           UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                           VSAllTracksViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
                                           [self.navigationController presentViewController:vc animated:YES completion:nil];
                                       }
                                   }failure:^(NSError* error) {
                                       NSLog(@"damn %@", error);
                                   }
             ];

        }
    }
}


@end
