//
//  NSDictionary+Attributes.h
//  Hippocampus
//
//  Created by Will Schreiber on 2/17/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSDictionary (Attributes)

# pragma mark other dictionary helpers

- (NSMutableDictionary*) cleanDictionary;

# pragma mark - Added Getters
// tracks/resources
- (NSString*) status; 
- (BOOL) live;
- (BOOL) unconfirmed;
- (NSString*) headline;
- (NSString*) keyForTrack;
- (NSMutableArray*) resources;
- (NSString*) url;

// quizzes
- (NSMutableDictionary*) quiz;
- (NSMutableArray*) quizQuestions;
- (NSString*) questionText;
- (NSString*) correctAnswerID;
- (NSMutableArray*) questionAnswers;
- (NSString*) answerText;
@end
