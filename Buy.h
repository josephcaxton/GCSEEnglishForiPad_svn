//
//  Buy.h
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 15/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "EvaluatorAppDelegate.h"



@interface Buy : UITableViewController <SKProductsRequestDelegate>{

	
	NSArray *ProductFromIstore;
	NSMutableArray *ProductsToIstore;
	NSArray *ProductsToIStoreInArray;
	NSArray *SortedDisplayProducts;
	CustomStoreObserver *observer;
    UIButton *Restore;
}

@property (nonatomic, retain) NSArray *ProductFromIstore;
@property (nonatomic, retain) NSMutableArray *ProductsToIstore;
@property (nonatomic, retain) NSArray *ProductsToIStoreInArray;
@property (nonatomic, retain) NSArray *SortedDisplayProducts;
@property (nonatomic, retain) CustomStoreObserver *observer;
@property (nonatomic, retain) UIButton *Restore;

- (void)AddProgress;
- (BOOL)isDataSourceAvailable;

@end
