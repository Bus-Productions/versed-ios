//
//  AppDelegate.m
//  Stock
//
//  Created by Will Schreiber on 4/3/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setInitialLoginTimestamp];
    [self setStyle];
    [self setShouldRotate:NO];
    
    if ([[LXSession thisSession] user] && [[[LXSession thisSession] user] live] && [[[LXSession thisSession] user] name] && [[[[LXSession thisSession] user] name] length] > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [[LXServer shared] requestPath:[NSString stringWithFormat:@"users/%@.json", [[[LXSession thisSession] user] ID]] withMethod:@"GET" withParamaters:nil authType:@"none" success:^(id responseObject){
                [[LXSession thisSession] setUser:[[[responseObject cleanDictionary] objectForKey:@"user"] mutableCopy]];
                //NSLog(@"user = %@", [[LXSession thisSession] user]);
            }failure:nil];
        });
        
        [self setRootStoryboard:@"Main"];
        
    } else {
        [self setRootStoryboard:@"MobileLogin"];
    }
    
    return YES;
}


- (void) goToOption:(NSNotification*) notification
{
    NSDictionary* optionsDictionary = [notification userInfo];
    
    SWRevealViewController *revealViewController = (SWRevealViewController*)self.window.rootViewController;
    
    [revealViewController revealToggleAnimated:NO];
    
    UIViewController *vc;
    UINavigationController *nc = [[UINavigationController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if ([[optionsDictionary objectForKey:@"to"] isEqualToString:@"allTracks"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    } else if ([[optionsDictionary objectForKey:@"to"] isEqualToString:@"quiz"]) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"quizLandingViewController"];
        nc = [storyboard instantiateViewControllerWithIdentifier:@"quizQuestionsNavigationViewController"];
    }
    
    [nc setViewControllers:@[vc] animated:NO];
    
    [revealViewController setFrontViewController:nc];
    [revealViewController revealToggleAnimated:NO];
}



- (void) setStyle
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0 green:0.5333 blue:0.345 alpha:1.0]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"SourceSansPro-Light" size:18.0], NSFontAttributeName, nil]];
    CGFloat verticalOffset = 0;
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"SourceSansPro-Light" size:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void) setInitialLoginTimestamp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"isInitialLogin"];
    [defaults synchronize];
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.shouldRotate)
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
    else
        return UIInterfaceOrientationMaskPortrait;
}

- (void) setRootStoryboard:(NSString*)name
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    if ([name isEqualToString:@"Main"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToOption:) name:@"goToOption" object:nil];
        [self.window.rootViewController presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"promptOptionsViewController"] animated:NO completion:^(void){}];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"initialLogin"];
    [defaults synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



# pragma mark - Notifications

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[LXNotifications thisNotification] updateDeviceToken:deviceToken success:^(id responseObject) {
                NSLog(@"My token is: %@", deviceToken);
            } failure:^(NSError *error){
                NSLog(@"Didn't successfully submit device token: %@", deviceToken);
            }
        ];
    });
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo = %@", userInfo);
}


@end
