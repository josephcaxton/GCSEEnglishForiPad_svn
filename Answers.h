//
//  Answers.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 18/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "QuestionItems.h"


@interface Answers :  QuestionItems  
{
}

@property (nonatomic, retain) NSString * Reason;
@property (nonatomic, retain) NSNumber * Correct;
@property (nonatomic, retain) NSString * AnswerText;
@property (nonatomic, retain) NSString * PictureAnnotation;
@property (nonatomic, retain) NSManagedObject * QuestionItem;

@end



