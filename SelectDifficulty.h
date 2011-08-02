//
//  SelectDifficulty.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 13/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionItems.h"

@interface SelectDifficulty : UITableViewController {

	QuestionItems	*QItem_ForEdit;
	BOOL UserConfigure;
	
}
@property (nonatomic, retain) QuestionItems	*QItem_ForEdit;
@property (nonatomic) BOOL UserConfigure;

-(IBAction)Back:(id)sender;
@end
