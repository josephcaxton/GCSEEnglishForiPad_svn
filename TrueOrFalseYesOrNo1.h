//
//  TrueOrFalseYesOrNo1.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 27/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lk_QuestionTemplate.h"
#import "Topics.h"
#import "QuestionHeader.h"
#import "QuestionItems.h"
#import "Answers.h"


@interface TrueOrFalseYesOrNo1 : UIViewController <UITableViewDataSource, UITableViewDelegate> {

	lk_QuestionTemplate *QuestionTemplate;
	Topics  *SelectedTopic;
	
	QuestionItems	*QItem_ForEdit;
	
	NSString *SFileNameValue;
	
	UITableView *DisplayTable;
	NSIndexPath *DisplayedIndexPath;
	UISwitch *RequireActivityMarker;
	
	UISwitch *Authorize;
	
	
	UILabel *True;
	UILabel *False;
	
	
	BOOL Truetick;
	
	
	
	NSArray *AnswerControls;
	NSMutableArray *AnswerObjects;
	
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


@property (nonatomic, retain) UILabel		*True;
@property (nonatomic, retain) UILabel		*False;


@property (nonatomic) BOOL Truetick;


@property (nonatomic, retain) NSArray *AnswerControls;
@property (nonatomic, retain) NSMutableArray *AnswerObjects;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSManagedObjectContext *)ManagedObjectContext;



@end
