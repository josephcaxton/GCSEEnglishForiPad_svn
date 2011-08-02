//
//  ClientEngine.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 06/11/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "stdlib.h"
#import "EvaluatorAppDelegate.h"
#import "Topics.h"
#import "lk_QuestionTemplate.h"
#import "QuestionItems.h"
#import "QuestionHeader.h"

@interface ClientEngine : UITableViewController <NSFetchedResultsControllerDelegate> {
	
	
	
@private
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	NSFetchedResultsController *fetchedResultsController_Topics;
	NSFetchedResultsController *fetchedResultsController_QT;
	
	NSNumber *Difficulty;
	Topics  *SelectedTopic;
	lk_QuestionTemplate *QuestionTemplate;
	
	NSArray *ListofQuestions;
	
	
	NSExpression *DifficultyColumn;
	NSExpression *DifficultyValue;
	
	NSPredicate *DifficultyPredicate;
	
	NSExpression *SelectedTopicColumn;
	NSExpression *SelectedTopicValue;
	
	NSPredicate *SelectedTopicPredicate;
	
	NSExpression *QuestionTemplateColumn;
	NSExpression *QuestionTemplateValue;
	
	NSPredicate *QuestionTemplatePredicate;
	
	NSExpression *AccessLevelColumn;
	NSExpression *AccessLevelValue;
	
	NSPredicate *AccessLevelPredicate;
	
	NSMutableArray *PopBox;
	NSArray *UnchangedArray;
	NSTimer	*timer;
	BOOL ExitFlag;
	NSMutableArray *NumberCounter;  // Just for numbering
	NSArray *CollectedObjects;
	NSMutableArray *SelectedArrays;
	
	

}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController_Topics;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController_QT;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) Topics  *SelectedTopic;
@property (nonatomic, retain) lk_QuestionTemplate *QuestionTemplate;
@property (nonatomic, retain) NSArray *ListofQuestions;

@property (nonatomic, retain) NSExpression *DifficultyColumn;
@property (nonatomic, retain) NSExpression *DifficultyValue;
@property (nonatomic, retain) NSPredicate *DifficultyPredicate;

@property (nonatomic, retain) NSExpression *SelectedTopicColumn;
@property (nonatomic, retain) NSExpression *SelectedTopicValue;
@property (nonatomic, retain) NSPredicate *SelectedTopicPredicate;

@property (nonatomic, retain) NSExpression *QuestionTemplateColumn;
@property (nonatomic, retain) NSExpression *QuestionTemplateValue;
@property (nonatomic, retain) NSPredicate *QuestionTemplatePredicate;

@property (nonatomic, retain) NSExpression *AccessLevelColumn;
@property (nonatomic, retain) NSExpression *AccessLevelValue;
@property (nonatomic, retain) NSPredicate *AccessLevelPredicate;

@property (nonatomic, retain) NSMutableArray *PopBox;
@property (nonatomic, retain) NSArray *UnchangedArray; 
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) BOOL ExitFlag;  // this flag is to fix a bug to clear the timer object hold on this controller
@property (nonatomic, retain) NSMutableArray *NumberCounter;
@property (nonatomic, retain) NSArray *CollectedObjects ;
@property (nonatomic, retain) NSMutableArray *SelectedArrays;

- (NSManagedObjectContext *)ManagedObjectContext;

-(NSNumber*) ConfigureDifficulty;
@end
