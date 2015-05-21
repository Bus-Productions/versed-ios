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


# pragma mark - Added getters
- (NSString*) status
{
    return [self objectForKey:@"status"];
}

- (NSString*) ID
{
    return [NSString stringWithFormat:@"%@", [self objectForKey:@"id"]];
}

- (NSString*) url
{
    return [self objectForKey:@"url"];
}

- (BOOL) live
{
    return [[self status] isEqualToString:@"live"];
}

- (BOOL) unconfirmed
{
    return [[self status] isEqualToString:@"unconfirmed"];
}

- (NSString*) headline
{
    return [self objectForKey:@"headline"];
}

- (NSString*) keyForTrack
{
    return [NSString stringWithFormat:@"track_%@", [self ID]];
}

- (NSMutableArray*) resources
{
    return [[self objectForKey:@"resources"] mutableCopy];
}

- (NSMutableArray*) questionAnswers
{
    return [[self objectForKey:@"quiz_answers"] mutableCopy];
}

- (NSMutableArray*) quizQuestions
{
    return [[self objectForKey:@"quiz_questions"] mutableCopy];
}

- (NSMutableDictionary*) quiz
{
    return [[self objectForKey:@"quiz"] mutableCopy];
}

- (NSString*) answerText
{
    return [self objectForKey:@"answer_text"];
}

- (NSString*) questionText
{
    return [self objectForKey:@"question_text"];
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

- (NSString*) overallQuizPercentage
{
    NSNumber* c = [self quizQuestionsCorrect];
    NSNumber* t = [self quizQuestionsTotal];
    float avg = ([c floatValue]/[t floatValue])*100.0;
    return [NSString stringWithFormat:@"%f%%", avg];
}
@end
