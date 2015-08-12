//
//  LXPurchase.h
//  Versed
//
//  Created by Joseph Gill on 8/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXPurchase : NSObject

+(LXPurchase*) thisPurchase;

- (BOOL) shouldPromptToBuy;

@end
