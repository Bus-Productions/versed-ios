//
//  NSArray+Attributes.m
//  Hippocampus
//
//  Created by Will Schreiber on 2/17/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "NSMutableArray+Attributes.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation NSMutableArray (Attributes)

- (int) numberQuizResultsCorrect
{
    int count = 0;
    for (NSDictionary*qr in self) {
        if ([qr quizResultIsCorrect]) {
            count = count + 1;
        }
    }
    return count; 
}

@end
