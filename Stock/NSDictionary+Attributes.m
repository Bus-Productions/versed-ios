//
//  NSDictionary+Attributes.m
//  Hippocampus
//
//  Created by Will Schreiber on 2/17/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "NSDictionary+Attributes.h"
#import "Math.h"
#import "NSArray+Attributes.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation NSDictionary (Attributes)



- (NSMutableDictionary*) cleanDictionary
{
    NSMutableDictionary* tDict = [[NSMutableDictionary alloc] init];
    
    NSArray* keys = [self allKeys];
    
    for (NSString* k in keys) {
        
        if (NULL_TO_NIL([self objectForKey:k])) {
            if ([[self objectForKey:k] isKindOfClass:[NSArray class]] || [[self objectForKey:k] isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray* temporaryInnerArray = [[self objectForKey:k] cleanArray];
                if (temporaryInnerArray) {
                    [tDict setObject:temporaryInnerArray forKey:k];
                }
                
            } else if ([[self objectForKey:k] isKindOfClass:[NSDictionary class]] || [[self objectForKey:k] isKindOfClass:[NSMutableDictionary class]]) {
                NSMutableDictionary* temp = [[self objectForKey:k] cleanDictionary];
                if (temp) {
                    [tDict setObject:temp forKey:k];
                }
                
            } else if ([[self objectForKey:k] isKindOfClass:[NSString class]] || [[self objectForKey:k] isKindOfClass:[NSNumber class]]) {
                if (NULL_TO_NIL([self objectForKey:k])) {
                    [tDict setObject:[self objectForKey:k] forKey:k];
                }
                
            }
        }
        
    }
    return tDict;
}


# pragma mark - Added getters

- (NSString*) status
{
    return [self objectForKey:@"status"];
}

- (NSString*) level
{
    return [self objectForKey:@"level"];
}

- (NSString*) numberTracksToNextLevel
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"number_tracks_to_next_level"]];
}

- (NSString*) completedTracksCount
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[[self objectForKey:@"completed_tracks"] count]];
}

- (NSString*) liveTracksCount
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[[self objectForKey:@"live_tracks"] count]];
}

- (NSString*) ID
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"id"]];
}

- (NSString*) url
{
    return (NSString*)[self objectForKey:@"url"];
}

- (NSString*) mediaURL
{
    return [self objectForKey:@"media_url"];
}

- (NSString*) resourceType
{
    return [self objectForKey:@"resource_type"] && NULL_TO_NIL([self objectForKey:@"resource_type"]) ? [self objectForKey:@"resource_type"] : @"Article";
}

- (BOOL) live
{
    return [[self status] isEqualToString:@"live"];
}

- (BOOL) unconfirmed
{
    return [[self status] isEqualToString:@"unconfirmed"];
}

- (BOOL) deleted
{
    return [[self status] isEqualToString:@"deleted"];
}

- (NSString*) headline
{
    return [self objectForKey:@"headline"];
}

- (NSString*) keyForTrack
{
    return [NSString stringWithFormat:@"track_%@", [self ID]];
}

- (NSMutableDictionary*) track
{
    return [[self objectForKey:@"track"] mutableCopy];
}

- (NSMutableArray*) resources
{
    return [self objectForKey:@"resources"] ? [[self objectForKey:@"resources"] mutableCopy] : [[NSMutableArray alloc] init];;
}

- (NSString*) numberResourcesRead
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"number_resources_read"]];
}

- (NSString*) minutesRemaining
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"minutes_remaining"]];
}

- (NSMutableArray*) questionAnswers
{
    return [[self objectForKey:@"quiz_answers"] mutableCopy];
}

- (NSMutableDictionary*) quizQuestion
{
    return [[self objectForKey:@"quiz_question"] mutableCopy];   
}

- (NSMutableArray*) quizQuestions
{
    return [[self objectForKey:@"quiz_questions"] mutableCopy];
}

- (NSMutableDictionary*) quiz
{
    return [[self objectForKey:@"quiz"] mutableCopy];
}

- (NSString*) quizName
{
    return [self objectForKey:@"quiz_name"];
}

- (NSString*) email
{
    return [self objectForKey:@"email"];
}

- (NSString*) tier
{
    return [self objectForKey:@"tier"];
}

- (BOOL) paid
{
    return [[self tier] isEqualToString:@"paid"];
}

- (BOOL) free
{
    return [[self tier] isEqualToString:@"free"];
}

- (NSString*) name
{
    return [self objectForKey:@"name"];
}

- (NSString*) nameOrYou
{
    return [self objectForKey:@"name"] ? [self objectForKey:@"name"] : @"You";
}

- (NSString*) nameOrYour
{
    return [self objectForKey:@"name"] ? [self objectForKey:@"name"] : @"You";
}

- (NSString*) firstName
{
    if ([self name]) {
        NSCharacterSet *delimiterCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        return [[[self name] componentsSeparatedByCharactersInSet:delimiterCharacterSet] firstObject];
    }
    return nil;
}

- (NSString*) totalQuizzes
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"total_quizzes"]];
}

- (NSString*) companyID
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"company_id"]];
}

- (NSString*) answerText
{
    return [self objectForKey:@"answer_text"];
}

- (NSString*) questionText
{
    return [self objectForKey:@"question_text"];
}

- (NSString*) message
{
    return [self objectForKey:@"message_text"];
}

- (NSString*) quizAnswerID
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"quiz_answer_id"]];
}

- (NSString*) quizQuestionID
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"quiz_question_id"]];
}

- (NSString*) quizID
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"quiz_id"]];
}

- (NSMutableArray*) quizResults
{
    return [[self objectForKey:@"quiz_results"] mutableCopy];
}

- (NSString*) correctAnswerID
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"correct_answer_id"]];
}

- (BOOL) quizResultIsCorrect
{
    return [[self correctAnswerID] isEqualToString:[self quizAnswerID]];
}

- (NSNumber *) quizQuestionsCorrect
{
    return (NSNumber*)[self objectForKey:@"quiz_questions_correct"];
}

- (NSNumber *) quizQuestionsTotal
{
    return (NSNumber*)[self objectForKey:@"quiz_questions_total"];
}

- (NSMutableArray *) trackUserPairs
{
    return [[self objectForKey:@"track_user_pairs"] mutableCopy];
}

- (NSString *) pollQuestion
{
    return [[self objectForKey:@"poll_question"] mutableCopy];
}

- (NSMutableArray *) pollAnswers
{
    return [[self objectForKey:@"poll_answers"] mutableCopy];
}

- (NSMutableDictionary *) poll
{
    return [[self objectForKey:@"poll"] mutableCopy];
}

- (NSMutableArray *) polls
{
    return [[self objectForKey:@"polls"] mutableCopy];
}

- (NSMutableDictionary *) userAnswer
{
    if (NULL_TO_NIL([self objectForKey:@"user_answer"])) {
        return [[self objectForKey:@"user_answer"] mutableCopy];
    }
    return nil;
}

- (NSMutableDictionary *) company
{
    if (NULL_TO_NIL([self objectForKey:@"company"])) {
        return [[self objectForKey:@"company"] mutableCopy];
    }
    return nil;
}

- (BOOL) shouldShowLeaderboard
{
    return [[NSString stringWithFormat:@"%@", [self objectForKey:@"leaderboard"]] isEqualToString:@"1"];
}

- (NSString*) percentage
{
    return [NSString stringWithFormat:@"%.00f%%", [[self objectForKey:@"percentage"] floatValue]];
}

- (float) percentageAsFloat
{
    return [[self objectForKey:@"percentage"] floatValue];
}

- (NSString*) categoryName
{
    return [self objectForKey:@"category_name"];
}

- (NSString*) editorsNote
{
    return [self objectForKey:@"editors_note"];
}

- (NSString*) faqQuestion
{
    return [self objectForKey:@"faq_question"];
}

- (NSString*) faqResponse
{
    return [self objectForKey:@"faq_response"];
}

- (BOOL) completed
{
    return [[NSString stringWithFormat:@"%@", [self objectForKey:@"completed"]] isEqualToString:@"1"];
}

- (NSString*) resourceDate
{
    return [self objectForKey:@"resource_date"] && NULL_TO_NIL([self objectForKey:@"resource_date"]) ? [self objectForKey:@"resource_date"] : [[NSDate dateFromString:[self objectForKey:@"created_at"]] timeAgoActual];
}

- (NSMutableArray*) faqs
{
    return [[self objectForKey:@"faqs"] mutableCopy];
}

- (NSMutableArray*) strengthTitles
{
    NSMutableArray *strengthTitles = [[NSMutableArray alloc] init];
    for (NSDictionary *track in self) {
        [strengthTitles addObject:[track headline]];
    }
    return strengthTitles;
}

- (NSMutableArray*) strengths
{
    return [[self objectForKey:@"strengths"] mutableCopy];
}

- (NSMutableArray*) weaknessesTitles
{
    NSMutableArray *weaknessesTitles = [[NSMutableArray alloc] init];
    for (NSDictionary *track in self) {
        [weaknessesTitles addObject:[track headline]];
    }
    return weaknessesTitles;
}

- (NSMutableArray*) weaknesses
{
    return [[self objectForKey:@"weaknesses"] mutableCopy];
}

- (NSMutableArray*) deepDives
{
    return [[self objectForKey:@"longforms"] mutableCopy];
}

- (NSString*) estimatedTime
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"estimated_time"]];
}

- (NSString*) source
{
    return [self objectForKey:@"source"];
}

- (NSString*) updatedAtFormatted
{
    return [NSString stringWithFormat:@"Updated %@", [[NSDate dateFromString:[self objectForKey:@"updated_at"]] timeAgoActualWithFormat:@"MMM. d, yyyy"]];
}

- (NSString*) completionDateFormatted
{
    return NULL_TO_NIL([self objectForKey:@"completion_date"]) ? [NSString stringWithFormat:@"%@", [[NSDate dateFromString:[self objectForKey:@"completion_date"]] timeAgoActualWithFormat:@"MMM. d, yyyy"]] : @"";
}

- (NSString*) numberResources
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"number_resources"]];
}

- (NSString*) numberChosen
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"number_chosen"]];
}

- (NSString*) numberTaken
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"number_taken"]];
}

- (NSString*) seen
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"seen"]];
}

- (NSString*) pointsToNextLevel
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"points_to_next_level"]];
}


- (void) incrementQuizzesTaken
{
    NSNumber* taken = [self valueForKey:@"quizzes_taken"];
    int newCount = [taken intValue] + 1;
    [self setValue:[NSNumber numberWithInt:newCount] forKey:@"quizzes_taken"];
}

- (NSString*) quizzesTaken
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"quizzes_taken"]];
}

- (NSString*) pointsForQuestion
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"points_for_question"]];
}

- (NSString*) score
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"score"]];
}

- (NSString*) pollAnswerID
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"poll_answer_id"]];
}

- (NSString*) completionDate
{
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate dateFromString:[self objectForKey:@"completion_date"]]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    return dateString;
}

- (NSString*) creationDate
{
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate dateFromString:[self objectForKey:@"created_at"]]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    return dateString;
}

- (NSString*) overallQuizPercentage
{
    NSNumber* c = [self quizQuestionsCorrect];
    NSNumber* t = [self quizQuestionsTotal];
    float avg = ([c floatValue]/[t floatValue])*100.0;
    return [NSString stringWithFormat:@"%d%%", (int)roundf(avg)];
}

- (CGFloat) alphaForImage
{
    return [self completed] ? 1.0f : 1.0f;
}

@end
