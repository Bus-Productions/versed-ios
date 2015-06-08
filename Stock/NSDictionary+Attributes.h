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
- (NSMutableDictionary*) quizQuestion;
- (NSString*) questionText;
- (NSString*) correctAnswerID;
- (NSString*) quizQuestionID;
- (NSString*) quizAnswerID;
- (NSMutableArray*) questionAnswers;
- (NSString*) answerText;
- (NSString*) quizID;
- (NSMutableArray*) quizResults;
- (BOOL) quizResultIsCorrect;
- (NSNumber*) quizQuestionsCorrect;
- (NSNumber*) quizQuestionsTotal;
- (NSString*) overallQuizPercentage;
- (NSMutableDictionary*) track;
- (NSString*) quizName;

// users
- (NSString*) email;
- (NSString*) name;
- (NSString*) totalQuizzes;
- (NSString*) companyID;

// track user pairs
- (NSMutableArray *) trackUserPairs;
- (NSString*) completionDate;

// polls
- (NSString *) pollQuestion;
- (NSMutableArray *) pollAnswers;
- (NSMutableDictionary *) poll;
- (NSString *) percentage;
- (NSString*) pollAnswerID;

// messages
- (NSString*) message;
@end
