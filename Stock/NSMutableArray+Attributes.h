//
//  NSArray+Attributes.h
//  Hippocampus
//
//  Created by Will Schreiber on 2/17/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Attributes)

# pragma mark other array helpers
- (int) numberQuizResultsCorrect;

- (NSMutableArray*) cleanArray;

@end
