//
//  LXServer.m
//  CityApp
//
//  Created by Will Schreiber on 4/23/14.
//  Copyright (c) 2014 LXV. All rights reserved.
//

#import "LXServer.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation LXServer

+ (LXServer*) shared
{
    static LXServer* sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL* baseURL = [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APIRoot"]];
        NSLog(@"%@", [baseURL absoluteString]);
        sharedClient = [[LXServer alloc] initWithBaseURL:baseURL];
        sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return sharedClient;
}

- (void) requestPath:(NSString*)path withMethod:(NSString*)method withParamaters:params success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    [self requestPath:path withMethod:method withParamaters:params authType:@"none" constructingBodyWithBlock:nil success:successCallback failure:failureCallback];
}

- (void) requestPath:(NSString*)path withMethod:(NSString*)method withParamaters:params authType:(NSString*)authType success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    [self requestPath:path withMethod:method withParamaters:params authType:authType constructingBodyWithBlock:nil success:successCallback failure:failureCallback];
}

- (void) requestPath:(NSString*)path withMethod:(NSString*)method withParamaters:(NSDictionary*)p authType:(NSString*)authType constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    UIBackgroundTaskIdentifier bgt = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void){
    }];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:p];
    if ([authType isEqualToString:@"none"]) {
        NSMutableDictionary *aType = [[NSMutableDictionary alloc] initWithObjectsAndKeys:authType, @"auth_type", nil];
        [params setObject:aType forKey:@"auth"];
    }
    if ([[LXSession thisSession] user]) {
        if ([params objectForKey:@"auth"]) {
            [[params objectForKey:@"auth"] setObject:[[[LXSession thisSession] user] ID] forKey:@"uid"];
        }else {
            NSMutableDictionary *uid = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[LXSession thisSession] user] ID], @"uid", nil];
            [params setObject:uid forKey:@"auth"];
        }
    }
    
    if ([method.uppercaseString isEqualToString:@"GET"]) {
        [self GET:path parameters:params success:^(NSURLSessionDataTask* task, id responseObject) {
            //NSLog(@"%@", responseObject);
            if (successCallback)
                successCallback(responseObject);
            [[UIApplication sharedApplication] endBackgroundTask:bgt];
        } failure:^(NSURLSessionDataTask* task, NSError* error) {
            NSLog(@"ERROR! %@", [error localizedDescription]);
            if (failureCallback)
                failureCallback(error);
            [[UIApplication sharedApplication] endBackgroundTask:bgt];
        }];
    } else if ([method.uppercaseString isEqualToString:@"POST"]) {
        [self POST:path parameters:params constructingBodyWithBlock:block success:^(NSURLSessionDataTask* task, id responseObject) {
            //NSLog(@"%@", responseObject);
            if (successCallback)
                successCallback(responseObject);
            [[UIApplication sharedApplication] endBackgroundTask:bgt];
        } failure:^(NSURLSessionDataTask* task, NSError* error) {
            NSLog(@"ERROR! %@", [error localizedDescription]);
            if (failureCallback)
                failureCallback(error);
            [[UIApplication sharedApplication] endBackgroundTask:bgt];
        }];
    } else if ([method.uppercaseString isEqualToString:@"PUT"]) {
        [self PUT:path parameters:params success:^(NSURLSessionDataTask* task, id responseObject) {
            //NSLog(@"%@", responseObject);
            if (successCallback)
                successCallback(responseObject);
            [[UIApplication sharedApplication] endBackgroundTask:bgt];
        } failure:^(NSURLSessionDataTask* task, NSError* error) {
            NSLog(@"ERROR! %@", [error localizedDescription]);
            if (failureCallback)
                failureCallback(error);
            [[UIApplication sharedApplication] endBackgroundTask:bgt];
        }];
    } else if ([method.uppercaseString isEqualToString:@"DELETE"]) {
        [self DELETE:path parameters:params success:^(NSURLSessionDataTask* task, id responseObject) {
            //NSLog(@"%@", responseObject);
            if (successCallback)
                successCallback(responseObject);
            [[UIApplication sharedApplication] endBackgroundTask:bgt];
        } failure:^(NSURLSessionDataTask* task, NSError* error) {
            NSLog(@"ERROR! %@", [error localizedDescription]);
            if (failureCallback)
                failureCallback(error);
            [[UIApplication sharedApplication] endBackgroundTask:bgt];
        }];
    }
}


+ (NSMutableDictionary*) objectWithLocalKey:(NSString*)key
{
    if (key && key.length > 0) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil; 
}

@end
