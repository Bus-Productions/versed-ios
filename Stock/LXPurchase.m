//
//  LXPurchase.m
//  Versed
//
//  Created by Joseph Gill on 8/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "LXPurchase.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#define FREE_RESOURCE_LIMIT 3
#define CONSUMED_RESOURCE_KEY @"consumedResourceCount"
#define NUMBER_CONSUMED_KEY @"numberConsumed"
#define DATE_CONSUMED_KEY @"dateConsumed"

static LXPurchase* thisPurchase = nil;

@implementation LXPurchase

//constructor
-(id) init
{
    if (thisPurchase) {
        return thisPurchase;
    }
    self = [super init];
    return self;
}


//singleton instance
+(LXPurchase*) thisPurchase
{
    if (!thisPurchase) {
        thisPurchase = [[super allocWithZone:NULL] init];
    }
    return thisPurchase;
}


//prevent creation of additional instances
+(id)allocWithZone:(NSZone *)zone
{
    return [self thisPurchase];
}



- (BOOL) shouldPromptToBuy
{
    if ([[[LXSession thisSession] user] free]) {
        return [self didUpdateConsumedResources];
    }
    return NO;
}

- (BOOL) didUpdateConsumedResources
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:CONSUMED_RESOURCE_KEY]) {
        if ([[[defaults objectForKey:CONSUMED_RESOURCE_KEY] objectForKey:DATE_CONSUMED_KEY] isEqualToString:[NSDate currentDateAsString]]) {
            NSNumber *resourceCount = [self incrementConsumedResourcesWithDefaults:defaults];
            return [resourceCount intValue] > FREE_RESOURCE_LIMIT;
        } else {
            [self resetConsumedResourcesWithDefaults:defaults];
            return NO;
        }
    } else {
        [self resetConsumedResourcesWithDefaults:defaults];
        return NO;
    }
}

- (NSNumber*) incrementConsumedResourcesWithDefaults:(NSUserDefaults*)defaults
{
    NSNumber *newCount = [NSNumber numberWithInt:[[[defaults objectForKey:CONSUMED_RESOURCE_KEY] objectForKey:NUMBER_CONSUMED_KEY] intValue] + 1];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSDate currentDateAsString] forKey:DATE_CONSUMED_KEY];
    [dict setObject:newCount forKey:NUMBER_CONSUMED_KEY];
    [defaults setObject:dict forKey:CONSUMED_RESOURCE_KEY];
    [defaults synchronize];
    return newCount;
}

- (void) resetConsumedResourcesWithDefaults:(NSUserDefaults*)defaults
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSDate currentDateAsString] forKey:DATE_CONSUMED_KEY];
    [dict setObject:[NSNumber numberWithInt:1] forKey:NUMBER_CONSUMED_KEY];
    [defaults setObject:dict forKey:CONSUMED_RESOURCE_KEY];
    [defaults synchronize];
}


@end
