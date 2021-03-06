//
//  NSArray+Attributes.m
//  Hippocampus
//
//  Created by Will Schreiber on 6/10/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "NSArray+Attributes.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation NSArray (Attributes)

- (NSMutableArray*) cleanArray
{
    NSMutableArray* temporaryInnerArray = [[NSMutableArray alloc] init];
    
    for (id object in self) {
        
        if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
            if (NULL_TO_NIL(object)) {
                [temporaryInnerArray addObject:object];
            }
        
        } else if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
            NSMutableDictionary* temp = [object cleanDictionary];
            if (temp) {
                [temporaryInnerArray addObject:temp];
            }
        
        } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray* temp = [object cleanArray];
            if (temp) {
                [temporaryInnerArray addObject:temp];
            }
        }
    }
    
    if ([self count] == 0) {
        return nil;
    }
    
    return temporaryInnerArray;
}

- (NSString*) quizPercentageCorrect
{
    if (self.count == 0)
        return @"0%";
    
    int correct = 0;
    for (NSDictionary *qr in self) {
        if ([qr quizResultIsCorrect]) {
            correct = correct + 1;
        }
    }
    NSNumber *total = [NSNumber numberWithInt:self.count];
    NSNumber *correctCount = [NSNumber numberWithInt:correct];
    float avg = ([correctCount floatValue]/[total floatValue])*100.0;
    return [NSString stringWithFormat:@"%d%%", (int)roundf(avg)];
}

@end
