//
//  Topics.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 29/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <CoreData/CoreData.h>

@class QuestionHeader;

@interface Topics :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * TopicName;
@property (nonatomic, retain) NSSet* Topic_QuestionHeader;

@end


@interface Topics (CoreDataGeneratedAccessors)
- (void)addTopic_QuestionHeaderObject:(QuestionHeader *)value;
- (void)removeTopic_QuestionHeaderObject:(QuestionHeader *)value;
- (void)addTopic_QuestionHeader:(NSSet *)value;
- (void)removeTopic_QuestionHeader:(NSSet *)value;

@end

