//
//  AdminDashBoard.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 18/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class lk_QuestionTemplate;
@class QuestionHeader;
@class QuestionItems;
@class Answers;

@interface AdminDashBoard : UITableViewController {
	
	
	
	NSMutableArray *listofItems;

}

@property (nonatomic, retain) NSMutableArray *listofItems;


@end
