//
//  lk_QuestionTemplate.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 18/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface lk_QuestionTemplate :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * LoggedDate;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSSet* QuestionHeaders;

@end


@interface lk_QuestionTemplate (CoreDataGeneratedAccessors)
- (void)addQuestionHeadersObject:(NSManagedObject *)value;
- (void)removeQuestionHeadersObject:(NSManagedObject *)value;
- (void)addQuestionHeaders:(NSSet *)value;
- (void)removeQuestionHeaders:(NSSet *)value;

@end

