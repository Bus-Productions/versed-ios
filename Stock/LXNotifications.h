//
//  LXNotifications.h
//  Versed
//
//  Created by Joseph Gill on 8/17/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXNotifications : NSObject

+(LXNotifications*) thisNotification;

+(BOOL)areNotificationsEnabled;

- (void) updateDeviceToken:(NSData *)token success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback;

- (void) askForDeviceToken;

@end
