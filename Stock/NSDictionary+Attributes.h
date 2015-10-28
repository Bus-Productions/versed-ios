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
- (BOOL) deleted;
- (NSString*) headline;
- (NSString*) keyForTrack;
- (NSMutableArray*) resources;
- (NSString*) url;
- (NSString*) mediaURL;
- (NSString*) resourceType;
- (NSString*) estimatedTime;
- (NSString*) numberResources;
- (BOOL) completed;
- (NSString*) resourceDate;
- (CGFloat) alphaForImage;
- (NSString*) editorsNote;
- (NSString*) updatedAtFormatted;
- (NSString*) completionDateFormatted;

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
- (NSString*) seen;
- (NSString*) pointsForQuestion; 

// users
- (NSString*) email;
- (NSString*) name;
- (NSString*) firstName;
- (NSString*) totalQuizzes;
- (NSString*) companyID;
- (NSString*) level;
- (NSString*) score;
- (NSString*) numberTracksToNextLevel;
- (NSString*) completedTracksCount;
- (NSString*) liveTracksCount;
- (NSMutableArray*) strengths;
- (NSMutableArray*) strengthsTitles;
- (NSMutableArray*) weaknesses;
- (NSMutableArray*) weaknessesTitles;
- (void) incrementQuizzesTaken; 
- (NSString*) quizzesTaken;
- (NSString*) pointsToNextLevel;
- (NSString*) tier;
- (BOOL) paid;
- (BOOL) free;
- (BOOL) atResourceLimit;
- (NSMutableDictionary *) company;
- (BOOL) shouldShowLeaderboard;

// track user pairs
- (NSMutableArray *) trackUserPairs;
- (NSString*) completionDate;

// polls
- (NSString *) pollQuestion;
- (NSMutableArray *) pollAnswers;
- (NSMutableDictionary *) poll;
- (NSMutableArray *) polls;
- (NSString *) percentage;
- (NSString*) pollAnswerID;
- (NSString*) numberChosen;
- (NSString*) numberTaken;
- (NSMutableDictionary *) userAnswer;
- (float) percentageAsFloat; 

// messages
- (NSString*) message;
- (NSString*) creationDate;

// faq
- (NSString*) categoryName; 
- (NSString*) faqQuestion;
- (NSString*) faqResponse;
- (NSMutableArray*) faqs;

@end
