//
//  LXDate+RailsTimeConverter.h
//  Hippocampus
//
//  Created by Will Schreiber on 7/9/14.
//  Copyright (c) 2014 LXV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RailsTimeConverter)

+ (NSDate*) dateFromString:(NSString*)string;

+ (NSDate*) dateFromString:(NSString*)string withFormat:(NSString*)formatString;

- (NSString*) formattedDateStringWithFormat:(NSString*)string;

+ (NSString*) timeAgoInWords:(double)relativeTimestamp;

- (NSString*) timeAgoInWords;

- (NSString*) timeAgoActual;


+ (NSInteger) currentYearInteger;
+ (NSInteger) currentMonthInteger;
+ (NSInteger) currentDayInteger;

- (NSInteger) yearInteger;
- (NSInteger) monthInteger;
- (NSInteger) dayInteger;

- (NSInteger) yearIndex;
- (NSInteger) monthIndex;
- (NSInteger) dayIndex;

- (NSString*) dayOfWeek;
- (NSInteger) dayOfWeekIndex;

+ (NSString*) currentDateAsString;


@end
