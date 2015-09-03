//
//  VSPurchaseViewController.m
//  Versed
//
//  Created by Joseph Gill on 8/12/15.
//  Copyright (c) 2015 LXV. All rights reserved.
//

#import "VSPurchaseViewController.h"

#define kPurchasedProductIdentifier @"put your product id (the one that we just made in iTunesConnect) in here"

@interface VSPurchaseViewController ()

@end

@implementation VSPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Actions

- (IBAction)donePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)purchaseTapped:(id)sender
{
//    if([SKPaymentQueue canMakePayments]){
//        NSLog(@"User can make payments");
//        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kPurchasedProductIdentifier]];
//        productsRequest.delegate = self;
//        [productsRequest start];
//    }
//    else{
//        NSLog(@"User cannot make payments due to parental controls");
//    }
}

//
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
//    SKProduct *validProduct = nil;
//    int count = [response.products count];
//    if(count > 0){
//        validProduct = [response.products objectAtIndex:0];
//        NSLog(@"Products Available!");
//        [self purchase:validProduct];
//    }
//    else if(!validProduct){
//        NSLog(@"No products available");
//        //this is called if your product id is not valid, this shouldn't be called unless that happens.
//    }
//}

- (IBAction)purchase:(SKProduct *)product{
//    SKPayment *payment = [SKPayment paymentWithProduct:product];
//    
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

//- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
//{
//    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
//    for(SKPaymentTransaction *transaction in queue.transactions){
//        if(transaction.transactionState == SKPaymentTransactionStateRestored){
//            //called when the user successfully restores a purchase
//            NSLog(@"Transaction state -> Restored");
//            
//            [self setUserToPaid];
//            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//            break;
//        }
//    }
//}
//
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
//    for(SKPaymentTransaction *transaction in transactions){
//        switch(transaction.transactionState){
//            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
//                break;
//            case SKPaymentTransactionStatePurchased:
//                //this is called when the user has successfully purchased the package (Cha-Ching!)
//                [self setUserToPaid]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                NSLog(@"Transaction state -> Purchased");
//                break;
//            case SKPaymentTransactionStateRestored:
//                NSLog(@"Transaction state -> Restored");
//                [self setUserToPaid]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateFailed:
//                //called when the transaction does not finish
//                if(transaction.error.code == SKErrorPaymentCancelled){
//                    NSLog(@"Transaction state -> Cancelled");
//                    //the user cancelled the payment ;(
//                }
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                break;
//        }
//    }
//}

- (void)setUserToPaid
{
    NSMutableDictionary *user = [[LXSession thisSession] user];
    [user setObject:@"paid" forKey:@"tier"];
    [user removeObjectForKey:@"password"];
    [user removeObjectForKey:@"password_confirmation"];
    [user saveBoth:^(id responseObject){
        [self dismissViewControllerAnimated:YES completion:nil];
    }failure:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
