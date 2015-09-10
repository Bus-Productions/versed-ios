//
//  LXString+NSString.m
//  Hippocampus
//
//  Created by Will Schreiber on 1/21/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "LXString+NSString.h"

@implementation NSString (LXString)

- (NSString*) truncated:(int)length
{
    NSLog(@"length = %lu", (unsigned long)[self length]);
    return length < [self length] ? [NSString stringWithFormat:@"%@ [...]", [self substringWithRange:NSMakeRange(0, length)]] : self;
}

- (NSString*) croppedCloudinaryImageURLToScreenWidth
{
    return [self stringByReplacingOccurrencesOfString:@"upload/" withString:[NSString stringWithFormat:@"upload/c_scale,w_%@/", [NSNumber numberWithInt:(int)[[UIScreen mainScreen] bounds].size.width*[UIScreen mainScreen].scale]]];
}

@end

