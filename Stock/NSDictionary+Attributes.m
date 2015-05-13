//
//  NSDictionary+Attributes.m
//  Hippocampus
//
//  Created by Will Schreiber on 2/17/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "NSDictionary+Attributes.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation NSDictionary (Attributes)



- (NSMutableDictionary*) cleanDictionary
{
    NSMutableDictionary* tDict = [[NSMutableDictionary alloc] initWithDictionary:self];
    NSArray* keys = [tDict allKeys];
    for (NSString* k in keys) {
        if (!NULL_TO_NIL([tDict objectForKey:k])) {
            [tDict removeObjectForKey:k];
        }
        if ([[tDict objectForKey:k] isKindOfClass:[NSString class]]) {
            if (!NULL_TO_NIL([tDict objectForKey:k])) {
                [tDict removeObjectForKey:k];
            }
        } else if ([[tDict objectForKey:k] isKindOfClass:[NSArray class]] && [[tDict objectForKey:k] count] == 0) {
            [tDict removeObjectForKey:k];
        } else if ([[tDict objectForKey:k] isKindOfClass:[NSArray class]] || [[tDict objectForKey:k] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray* temporaryInnerArray = [[NSMutableArray alloc] init];
            for (id object in [tDict objectForKey:k]) {
                if ([object isKindOfClass:[NSString class]]) {
                    [temporaryInnerArray addObject:object];
                } else {
                    [temporaryInnerArray addObject:[object cleanDictionary]];
                }
            }
            [tDict setObject:temporaryInnerArray forKey:k];
        } else if ([[tDict objectForKey:k] isKindOfClass:[NSDictionary class]] || [[tDict objectForKey:k] isKindOfClass:[NSMutableDictionary class]]) {
            return [[tDict objectForKey:k] cleanDictionary];
        }
    }
    return tDict;
}


- (NSString*) status
{
    return [self objectForKey:@"status"]; 
}

- (BOOL) live
{
    return [[self status] isEqualToString:@"live"];
}

- (BOOL) unconfirmed
{
    return [[self status] isEqualToString:@"unconfirmed"];
}

- (NSMutableDictionary*) addAttributesFromDictionary:(NSMutableDictionary*)dict
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc] init];
    for (int i=0; i<[[dict allKeys] count]; i++) {
        NSString *key = [[dict allKeys] objectAtIndex:i];
        [returnDictionary setObject:[dict objectForKey:key] forKey:key];
    }
    return returnDictionary; 
}

@end
