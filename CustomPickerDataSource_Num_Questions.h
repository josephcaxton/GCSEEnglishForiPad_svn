//
//  CustomPickerDataSource_Num_Questions.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 02/11/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvaluatorAppDelegate.h"


@interface CustomPickerDataSource_Num_Questions : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>{
	
	NSMutableArray	*customPickerArray;
	
}

@property (nonatomic, retain) NSMutableArray *customPickerArray;


@end
