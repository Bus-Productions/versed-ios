//
//  VSPurchaseViewController.h
//  Versed
//
//  Created by Joseph Gill on 8/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface VSPurchaseViewController : UIViewController// <SKProductsRequestDelegate, SKPaymentTransactionObserver>

- (IBAction)restore;
- (IBAction)purchaseTapped:(id)sender;
@end
