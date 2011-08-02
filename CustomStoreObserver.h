//
//  CustomStoreObserver.h
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 20/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "EvaluatorAppDelegate.h"

@interface CustomStoreObserver : NSObject<SKPaymentTransactionObserver>{

}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;

-(void) provideContent:(NSString *)productIdentifier;


@end
