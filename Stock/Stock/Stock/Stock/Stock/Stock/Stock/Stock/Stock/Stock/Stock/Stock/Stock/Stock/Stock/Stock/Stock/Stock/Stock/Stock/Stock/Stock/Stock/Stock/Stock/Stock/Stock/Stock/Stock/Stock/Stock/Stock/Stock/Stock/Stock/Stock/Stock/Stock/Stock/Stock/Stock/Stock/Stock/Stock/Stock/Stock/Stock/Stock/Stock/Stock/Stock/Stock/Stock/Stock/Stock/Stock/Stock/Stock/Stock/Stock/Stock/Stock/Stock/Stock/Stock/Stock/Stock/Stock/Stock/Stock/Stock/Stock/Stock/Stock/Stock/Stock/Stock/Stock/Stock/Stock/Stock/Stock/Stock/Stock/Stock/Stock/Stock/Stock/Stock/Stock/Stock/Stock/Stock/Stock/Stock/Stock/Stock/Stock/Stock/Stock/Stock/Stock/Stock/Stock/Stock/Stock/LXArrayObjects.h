//
//  LXArrayObjects.h
//  Versed
//
//  Created by Joseph McArthur Gill on 5/15/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Extensions)

// saving and syncing
- (void) saveLocalWithKey:(NSString*)key;
- (void) saveLocalWithKey:(NSString*)key success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback;
- (void) destroyLocalWithKey:(NSString*)key;
- (void) destroyLocalWithKey:(NSString*)key success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback;

@end
