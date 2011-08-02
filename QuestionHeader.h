//
//  QuestionHeader.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 18/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <CoreData/CoreData.h>

@class lk_QuestionTemplate;
@class Topics;

@interface ImageToDataTransformer : NSValueTransformer{
	
}
@end


@interface QuestionHeader :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * LoggedDate;
@property (nonatomic, retain) NSDate * DateAutorized;
@property (nonatomic, retain) NSNumber * Autorize;
@property (nonatomic, retain) NSManagedObject * QuestionInfo;
@property (nonatomic, retain) NSManagedObject * QuestionTemplate;
@property (nonatomic, retain) NSManagedObject * QuestionHeader_Topic;
@property (nonatomic, retain) NSSet* QuestionItems;

@end


@interface QuestionHeader (CoreDataGeneratedAccessors)
- (void)addQuestionItemsObject:(NSManagedObject *)value;
- (void)removeQuestionItemsObject:(NSManagedObject *)value;
- (void)addQuestionItems:(NSSet *)value;
- (void)removeQuestionItems:(NSSet *)value;

@end

