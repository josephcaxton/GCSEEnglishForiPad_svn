//
//  ClientAnswers.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 24/11/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionItems.h"
#import "MultipleChoiceSingleAnswer.h"
#import "DescriptiveType.h"
#import "TrueOrFalseYesOrNo.h"
#import	"FillTheBlanks.h"


@interface ClientAnswers : UITableViewController {

	
	NSArray *FullDataArray;
	NSMutableArray *PopBox;
	NSMutableArray *NumberCounter;  // Just for numbering
}
@property (nonatomic, retain) NSArray *FullDataArray; 
@property (nonatomic, retain) NSMutableArray *PopBox;
@property (nonatomic, retain) NSMutableArray *NumberCounter;

@end
