//
//  Uploads.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 20/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lk_Topics.h"
#import "lk_QuestionTemplate.h"
#import "EvaluatorAppDelegate.h"
#import "QuestionHeader.h"
#import "QuestionItems.h"
#import "Answers.h"
#import "DBVersion.h"

@interface Uploads : UITableViewController <NSFetchedResultsControllerDelegate,UIActionSheetDelegate,NSXMLParserDelegate>{
	
	NSString *FileName;
	UIButton  *Topicbutton;
	UIButton *QuestionTemplatebutton;
	UIButton *Databutton;
	NSArray *QTArray;  // array of Question templates
	NSArray *TopArray;   // array of topics
	UIButton *VersionButton;
	
	DBVersion *VerNumber;
		
@private
	//NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	NSFetchedResultsController *fetchedResultsController_QT;
	NSFetchedResultsController *fetchedResultsController_Topics;
	NSFetchedResultsController *fetchedResultsController_Version;
	
}
//@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController_QT;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController_Topics;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController_Version;

@property (nonatomic, retain) NSString *FileName;
@property (nonatomic, retain) UIButton  *Topicbutton;
@property (nonatomic, retain) UIButton *QuestionTemplatebutton;
@property (nonatomic, retain) UIButton *Databutton;
@property (nonatomic, retain) NSArray *QTArray;
@property (nonatomic, retain) NSArray *TopArray;
@property (nonatomic, retain) UIButton *VersionButton;

@property (nonatomic, retain) DBVersion *VerNumber;

- (NSManagedObjectContext *)ManagedObjectContext;
-(IBAction)StartUpload:(id)sender;
-(void)MyParser:(NSString *)FileLocation;
-(void)loadDataFromXML:(NSString *)FileLocation;
-(BOOL)DeleteFile:(NSString*)documentFullName;
-(IBAction)ChangeVersionNumber:(id)sender;
@end
