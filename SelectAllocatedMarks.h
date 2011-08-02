//
//  SelectAllocatedMarks.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 12/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionItems.h"

@interface SelectAllocatedMarks : UITableViewController {

	QuestionItems	*QItem_ForEdit;
}
@property (nonatomic, retain) QuestionItems	*QItem_ForEdit;

@end
