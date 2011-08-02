//
//  QuestionItems.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 18/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "QuestionHeader.h"

//@class QuestionHeader;





@interface QuestionItems :  QuestionHeader  
{
}

@property (nonatomic, retain) NSString * Question;
@property (nonatomic, retain) NSNumber * RequireActivityMarker;
@property (nonatomic, retain) NSNumber * NegativeMarking;
@property (nonatomic, retain) NSNumber * AllocatedMark;
@property (nonatomic, retain) NSNumber * AccessLevel;
@property (nonatomic, retain) NSString * AttachmentFile;
@property (nonatomic, retain) NSNumber * Difficulty;
@property (nonatomic, retain) NSString * VideoLink;
@property (nonatomic, retain) NSString * AudioLink;
@property (nonatomic, retain) QuestionHeader * QuestionHeader1;
@property (nonatomic, retain) NSSet* Answers1;

@end


@interface QuestionItems (CoreDataGeneratedAccessors)
- (void)addAnswers1Object:(NSManagedObject *)value;
- (void)removeAnswers1Object:(NSManagedObject *)value;
- (void)addAnswers1:(NSSet *)value;
- (void)removeAnswers1:(NSSet *)value;

@end

