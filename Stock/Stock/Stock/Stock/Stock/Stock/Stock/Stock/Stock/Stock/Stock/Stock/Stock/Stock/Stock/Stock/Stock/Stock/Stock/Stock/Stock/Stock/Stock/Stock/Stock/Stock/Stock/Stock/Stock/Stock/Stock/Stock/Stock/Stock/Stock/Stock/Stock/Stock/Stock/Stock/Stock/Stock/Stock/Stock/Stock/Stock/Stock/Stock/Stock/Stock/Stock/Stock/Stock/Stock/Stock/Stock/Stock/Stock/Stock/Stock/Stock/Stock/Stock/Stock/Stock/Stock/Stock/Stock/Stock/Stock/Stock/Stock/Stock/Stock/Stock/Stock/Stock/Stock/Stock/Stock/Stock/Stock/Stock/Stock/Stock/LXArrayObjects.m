//
//  LXArrayObjects.m
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "LXArrayObjects.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation NSMutableArray (Extensions)


- (void) saveLocalWithKey:(NSString*)key
{
    [self saveLocalWithKey:key success:nil failure:nil];
}

- (void) saveLocalWithKey:(NSString*)key success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (successCallback) {
        successCallback(@{});
    }
}

- (void) destroyLocalWithKey:(NSString*)key
{
    [self destroyLocalWithKey:key success:nil failure:nil];
}

- (void) destroyLocalWithKey:(NSString*)key success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (successCallback) {
        successCallback(@{});
    }
}

@end
