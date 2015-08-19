//
//  LXNotifications.m
//  Versed
//
//  Created by Joseph Gill on 8/17/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "LXNotifications.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

static LXNotifications* thisNotification = nil;

@implementation LXNotifications

//constructor
-(id) init
{
    if (thisNotification) {
        return thisNotification;
    }
    self = [super init];
    return self;
}


//singleton instance
+(LXNotifications*) thisNotification
{
    if (!thisNotification) {
        thisNotification = [[super allocWithZone:NULL] init];
    }
    return thisNotification;
}


//prevent creation of additional instances
+(id)allocWithZone:(NSZone *)zone
{
    return [self thisNotification];
}


# pragma mark - Push Notifications

+ (BOOL) areNotificationsEnabled
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){
        UIUserNotificationSettings *noticationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (!noticationSettings || (noticationSettings.types == UIUserNotificationTypeNone)) {
            return NO;
        }
        return YES;
    }
    
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    return (types & UIRemoteNotificationTypeAlert);
}

- (void) updateDeviceToken:(NSData *)token success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    NSString *tokenString = [[token description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[LXServer shared] requestPath:@"/device_tokens" withMethod:@"POST" withParamaters:@{@"device_token": @{@"ios_device_token": tokenString, @"environment": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ENVIRONMENT"], @"user_id": [[[LXSession thisSession] user] ID]}} success:^(id responseObject) {
        if (successCallback) {
            successCallback(responseObject);
        }
    } failure:^(NSError *error) {
        if (failureCallback) {
            failureCallback(error);
        }
    }
     ];
}

- (void) askForDeviceToken
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

@end
