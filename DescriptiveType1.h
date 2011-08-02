//
//  DescriptiveType1.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 26/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lk_QuestionTemplate.h"
#import "Topics.h"
#import "QuestionHeader.h"
#import "QuestionItems.h"
#import "Answers.h"


@interface DescriptiveType1 : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate>{

	lk_QuestionTemplate *QuestionTemplate;
	Topics  *SelectedTopic;
	
	QuestionItems	*QItem_ForEdit;
	
	NSString *SFileNameValue;
	
	UITableView *DisplayTable;
	NSIndexPath *DisplayedIndexPath;
	UISwitch *RequireActivityMarker;
	
	UISwitch *Authorize;
	
	
/*	UITextField *Answer1;
	UITextField *Answer2;
	UITextField *Answer3;
	UITextField *Answer4;
	UITextField *Answer5;
	
	BOOL Answer1tick;
	BOOL Answer2tick;
	BOOL Answer3tick;
	BOOL Answer4tick;
	BOOL Answer5tick; 
	
	NSArray *AnswerControls; */
	NSMutableArray *AnswerObjects; 
	
	UITextView *Answer1;
	
@private
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
}

@property (nonatomic, retain) lk_QuestionTemplate *QuestionTemplate;
@property (nonatomic, retain) Topics  *SelectedTopic;
@property (nonatomic, retain) QuestionItems	*QItem_ForEdit;

@property (nonatomic, retain) NSString *SFileNameValue;
@property (nonatomic, retain)  UITableView *DisplayTable;
@property (nonatomic, retain) NSIndexPath *DisplayedIndexPath;
@property (nonatomic, retain) UISwitch *RequireActivityMarker;
@property (nonatomic, retain) UISwitch *Authorize;


@property (nonatomic, retain) UITextView *Answer1;
/*@property (nonatomic, retain) UITextField	*Answer2;
@property (nonatomic, retain) UITextField	*Answer3;
@property (nonatomic, retain) UITextField	*Answer4;
@property (nonatomic, retain) UITextField	*Answer5;

@property (nonatomic) BOOL Answer1tick;
@property (nonatomic) BOOL Answer2tick;
@property (nonatomic) BOOL Answer3tick;
@property (nonatomic) BOOL Answer4tick;
@property (nonatomic) BOOL Answer5tick;

@property (nonatomic, retain) NSArray *AnswerControls; */
@property (nonatomic, retain) NSMutableArray *AnswerObjects; 

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSManagedObjectContext *)ManagedObjectContext;
//-(int)CheckAnswers;


@end
