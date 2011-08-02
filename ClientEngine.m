//
//  ClientEngine.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 06/11/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "ClientEngine.h"
#import "EvaluatorAppDelegate.h"
#import "MultipleChoiceSingleAnswer.h"
#import "DescriptiveType.h"
#import "TrueOrFalseYesOrNo.h"
#import	"FillTheBlanks.h"
#import	"ClientAnswers.h"

@implementation ClientEngine

@synthesize managedObjectContext, fetchedResultsController,fetchedResultsController_Topics,fetchedResultsController_QT;
@synthesize SelectedTopic,QuestionTemplate,ListofQuestions;
@synthesize DifficultyColumn,DifficultyValue,DifficultyPredicate,SelectedTopicColumn,SelectedTopicValue,SelectedTopicPredicate,AccessLevelColumn,AccessLevelValue,AccessLevelPredicate;
@synthesize QuestionTemplateColumn,QuestionTemplateValue,QuestionTemplatePredicate,PopBox,UnchangedArray,timer,ExitFlag,NumberCounter,CollectedObjects,SelectedArrays ;

int Hours = 0;
int mins = 0;
int seconds = 0;
int ToReviewQuestions = 0;
   
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	ToReviewQuestions = 0;
	self.navigationItem.title = @"Questions";
	
	
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	
	Difficulty = [self ConfigureDifficulty];
	
	if ([[appDelegate PossibleScores]intValue] > 0) {
		
		appDelegate.PossibleScores = [NSNumber numberWithInt:0];
		appDelegate.ClientScores = [NSNumber numberWithInt:0];
	}
	
	//**************************************
	// Get Topic Object
	
	self.fetchedResultsController_Topics = nil;
	self.managedObjectContext = [self ManagedObjectContext];
	
	NSError *error = nil;
	if (![[self fetchedResultsController_Topics] performFetch:&error]) {
		
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On Topics" 
															message: @"Error getting data from Topics Table contact support" delegate: self 
												  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[DataError show];
		
		[DataError release];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		
		
	}
	
	
	for (Topics *T in [self.fetchedResultsController_Topics fetchedObjects] ) {
		
		 
		
		if ([appDelegate.Topic isEqualToString:[NSString stringWithFormat:@"%@", T.TopicName]] ) {
			
			SelectedTopic = T;
			
			
		}
		
	}
	
	//***************************************
	//Get Question template to specify type of question
	
	
	
	self.fetchedResultsController_QT = nil;
	self.managedObjectContext = [self ManagedObjectContext];
	
	//NSError *error = nil;
	if (![[self fetchedResultsController_QT] performFetch:&error]) {
		
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On Question Template" 
															message: @"Error getting data from Question Template Table contact support" delegate: self 
												  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[DataError show];
		
		[DataError release];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		
		
	}
	
	
	
	for (lk_QuestionTemplate *Temp in [self.fetchedResultsController_QT fetchedObjects] ) {
		
		
		
		if ([appDelegate.TypeOfQuestion isEqualToString: Temp.Description] ) {
			
			QuestionTemplate = Temp;
			
			
			
		}
		
	}
	
	
	// Setup the predicates for search
	
	if (Difficulty !=  [NSNumber numberWithInt:0]) {
		
		DifficultyColumn = [NSExpression expressionForKeyPath:@"Difficulty"];
		DifficultyValue = [NSExpression expressionForConstantValue:Difficulty];
		DifficultyPredicate = [NSComparisonPredicate predicateWithLeftExpression:DifficultyColumn rightExpression:DifficultyValue modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];
		
		
	}
	else {
		DifficultyColumn = [NSExpression expressionForKeyPath:@"Difficulty"];
		DifficultyValue = [NSExpression expressionForConstantValue:Difficulty];
		DifficultyPredicate = [NSComparisonPredicate predicateWithLeftExpression:DifficultyColumn rightExpression:DifficultyValue modifier:NSDirectPredicateModifier type:NSGreaterThanPredicateOperatorType options:0];
		
	}

	
	
	if (SelectedTopic) {
		SelectedTopicColumn = [NSExpression expressionForKeyPath:@"QuestionHeader1.QuestionHeader_Topic"];
		SelectedTopicValue = [NSExpression expressionForConstantValue:SelectedTopic];
		SelectedTopicPredicate = [NSComparisonPredicate predicateWithLeftExpression:SelectedTopicColumn rightExpression:SelectedTopicValue modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];
	}
	
	else {

	SelectedTopicColumn = [NSExpression expressionForKeyPath:@"QuestionHeader1.QuestionHeader_Topic"];
	SelectedTopicValue = [NSExpression expressionForConstantValue:SelectedTopic];
	SelectedTopicPredicate = [NSComparisonPredicate predicateWithLeftExpression:SelectedTopicColumn rightExpression:SelectedTopicValue modifier:NSDirectPredicateModifier type:NSNotEqualToPredicateOperatorType options:0];
}	
	
	if (QuestionTemplate) {
		QuestionTemplateColumn = [NSExpression expressionForKeyPath:@"QuestionHeader1.QuestionTemplate"];
		QuestionTemplateValue = [NSExpression expressionForConstantValue:QuestionTemplate];
		QuestionTemplatePredicate = [NSComparisonPredicate predicateWithLeftExpression:QuestionTemplateColumn rightExpression:QuestionTemplateValue modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];
		
	}
	
	else {
		QuestionTemplateColumn = [NSExpression expressionForKeyPath:@"QuestionHeader1.QuestionTemplate"];
		QuestionTemplateValue = [NSExpression expressionForConstantValue:QuestionTemplate];
		QuestionTemplatePredicate = [NSComparisonPredicate predicateWithLeftExpression:QuestionTemplateColumn rightExpression:QuestionTemplateValue modifier:NSDirectPredicateModifier type:NSNotEqualToPredicateOperatorType options:0];
		
	}

	NSString* Accesslevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessLevel"];
	// Note here we are using less than sign so increase the value by 1.
	NSNumber* value =[NSNumber numberWithInt:[Accesslevel intValue] + 1];
	AccessLevelColumn = [NSExpression expressionForKeyPath:@"AccessLevel"];
	AccessLevelValue = [NSExpression expressionForConstantValue:value];
	AccessLevelPredicate = [NSComparisonPredicate predicateWithLeftExpression:AccessLevelColumn rightExpression:AccessLevelValue modifier:NSDirectPredicateModifier type:NSLessThanPredicateOperatorType options:0];
	
	
	


	
	
	// Run With Predicate 
	
	self.fetchedResultsController = nil;
	self.managedObjectContext = [self ManagedObjectContext];
	
	
	if (![[self fetchedResultsController] performFetch:&error]) {
		
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On QuestionItems" 
															message: @"Error getting data from Question Items Table contact support" delegate: self 
												  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[DataError show];
		
		[DataError release];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		
		
	}
	
	// Core data madness. You cannot get random entities using coredata so... here we go
	// So how did i deal with this.
	// 1, Put all the fetchobjects into an array, 2, Use the number of question user choose to create a random number of object
	// 3, add the objects into a new NSMutableArray called Selected Arrays.
	// 4, guess what ... it works
	// Another Problem though, is that Multiple Questions are coming up on the array.
	// Solution is to make a mutable array (Basket) and remove object already selected.
	// Then recount the objects in the Basket and randomly pick another one and so on.
	// Not if item in the basket is zero you better break if not you will need a crash element.
	
	
	CollectedObjects = [fetchedResultsController fetchedObjects];
	SelectedArrays = [[NSMutableArray alloc]init];
	NSMutableArray *Basket = [[CollectedObjects mutableCopy]autorelease];
	
	
	
	  int EntityCount = [[fetchedResultsController fetchedObjects]count];
	
	 if (EntityCount > 0) {
	
	  int RequestedNumber = appDelegate.NumberOfQuestions.intValue;
	
	  for (int i = 0; i< RequestedNumber ; i++) {
		  
		
		  NSObject *obj = [Basket objectAtIndex:arc4random() % EntityCount];
		  [SelectedArrays addObject:obj];
		  [Basket removeObject:obj];
		  EntityCount = [Basket count];
		  if (EntityCount == 0) {
			  //[Basket release];
			  break;
		  }
		
		  
		
	 }
	 }
	
		 UnchangedArray = SelectedArrays;
	
		 
		 //UnchangedArray  = [fetchedResultsController fetchedObjects];
	
	PopBox = [UnchangedArray mutableCopy];
	NumberCounter = [[NSMutableArray alloc]init];
	
	NSInteger Counter = [[appDelegate PossibleScores]intValue];
	
	for (int i = 0; i <[PopBox count]; i++) {
		
		QuestionItems *QI = (QuestionItems *)[PopBox objectAtIndex:i];
		
		//NSLog(@"Object %i to Index %i", i+1, i);
		[NumberCounter insertObject: [NSNumber numberWithInt:i+1] atIndex:i];  // this is just for numbering 
		
		//Exclude Descriptive Question Marks
		NSString *Desc = [NSString stringWithFormat:@"%@",[QI.QuestionHeader1.QuestionTemplate valueForKey:@"Description"]];
		if(![Desc isEqualToString:@"Descriptive Type"]){
		
		Counter	+= [[QI AllocatedMark]intValue];
			
		
		}
	}
	
	appDelegate.PossibleScores = [NSNumber numberWithInt:Counter];
	appDelegate.NumberOfQuestionsDisplayed = [NSNumber numberWithInt:[PopBox count]];
	
	//Start the timer
	if([self.timer isValid]){
		
		[timer invalidate];
		timer = nil;
		
	}
	
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
	Hours = 0;
	mins = 0;
	seconds = 0;
	
}

- (void)timerFired:(NSTimer *)timer{
	
	
	seconds ++;
	
	if (seconds	> 59) {
		
		seconds = 0;
		mins ++;
	}
	
	if (mins > 59) {
		mins = 0;
		Hours ++;
	}
	
	UIBarButtonItem *time = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%i h : %i m : %i s",Hours,mins,seconds] style:UIBarButtonItemStylePlain target:nil action:nil  ];
	self.navigationItem.rightBarButtonItem =time;
	[time release];
	//self.navigationItem.title = [NSString stringWithFormat:@"%i h : %i m : %i s",Hours,mins,seconds];
	
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self setExitFlag:NO];
	
	
	if ([PopBox count]== 0  && [UnchangedArray count] > 0 && ToReviewQuestions == 0) {
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		// Stop the timer and make sure you nil it out if not app will leak
		 
		if([self.timer isValid]){
			
		[timer invalidate];
			
			timer = nil;
		
		}
		
		//User has finished answering questions so record to xmlfile
		
		NSArray *DirDomain = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *DocumentsDirectory = [DirDomain objectAtIndex:0];
		NSString *ResultXmlFileLocation = [DocumentsDirectory stringByAppendingString:@"/Results.xml"];
		
		// Get the Date 
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		//[formatter setTimeStyle:NSDateFormatterFullStyle];
		NSString *now = [formatter stringFromDate:[NSDate date]];
		[formatter release];
		
		
		NSString *TextStart = @"<Result Date = ";
		NSString *Date = [NSString stringWithFormat:@"\"%@\"" ,now];
		//NSString *DateEnd =@">";
		
		// scores
		
		NSString *ScoresTextStart = @" Total = ";
		NSString *ScoresTextData = [NSString stringWithFormat:@"\"%@\" ", appDelegate.PossibleScores];
		NSString *AwardTextStart = @"Award = ";
		NSString *AwardTextData = [NSString stringWithFormat:@"\"%@\" ", appDelegate.ClientScores];
		NSString *NumQuestionTextStart = @"NumQuestion = ";
		NSString *NumQuestionTextData = [NSString stringWithFormat:@"\"%@\">", appDelegate.NumberOfQuestionsDisplayed];
		NSString *ScoresTextEnd =@"</Result>";
		//NSString *TextEnd = @"\n\t</Result>";
		NSString *CloseResultsData = @"</DATA>﻿﻿";
		//NSLog(@"%@%@%@%@%@%@%@%@%@%@%@%@",TextStart,Date,DateEnd,ScoresTextStart,ScoresTextData,AwardTextStart,AwardTextData,NumQuestionTextStart,NumQuestionTextData,ScoresTextEnd,TextEnd,CloseResultsData);
		
		NSString *FinalText = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",TextStart,Date,ScoresTextStart,ScoresTextData,AwardTextStart,AwardTextData,NumQuestionTextStart,NumQuestionTextData,ScoresTextEnd,CloseResultsData];
		
		
		// Write to file
		NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath: ResultXmlFileLocation];
		NSData *Str = [FinalText dataUsingEncoding:NSUTF8StringEncoding];
		
		// Locate a position before </ResultsData>
		unsigned long long Location = [fileHandle seekToEndOfFile];
		signed long long NewLocation = Location - 13;
		[fileHandle seekToFileOffset:NewLocation];
		
		//Write to the file and close	
		[fileHandle writeData:Str];
		[fileHandle closeFile];
		
		
		
		
		UIAlertView *Finished = [[UIAlertView alloc] initWithTitle: @"Test Completed" 
														  message: [NSString stringWithFormat:@"Your result is = %@ / %@. Questions with descriptive answers do not get a mark",appDelegate.ClientScores ,appDelegate.PossibleScores] delegate: self 
												  cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		
		
		[Finished  show];
		
		[Finished  release];
		
		ToReviewQuestions = 1;
		
		//[self.navigationController popToRootViewControllerAnimated:YES];
		
		
		
	}
	
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	if (ExitFlag == NO ) {
		
		if([self.timer isValid]){
			
			[timer invalidate];
			
			timer = nil;
			
		}
		
		
	}

}

-(NSNumber*) ConfigureDifficulty{
	
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if ([appDelegate.Difficulty  isEqualToString:@"Foundation" ] ) {
		return [NSNumber numberWithInt:1];
	}	
	
	else if ([appDelegate.Difficulty isEqualToString:@"Foundation & Higher"]){
		
		return [NSNumber numberWithInt:0];
	}
	
	else if([appDelegate.Difficulty isEqualToString:@"Higher"]){
		
		return [NSNumber numberWithInt:3];
		
	}
	else{
		
		return [NSNumber numberWithInt:0];
	}
	

	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /*NSInteger count = [[fetchedResultsController sections] count];
    
	if (count == 0) {
		count = 1;
	}
	*/
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
	if (section == 0)
		numberOfRows = 1;
	
	else {
		
		numberOfRows =   [PopBox count];     //[[fetchedResultsController fetchedObjects]count];
	}

	
	
	return numberOfRows;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	
	
	if (indexPath.section == 0 && indexPath.row == 0) {
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		cell.textLabel.text =@""; // Don't take this off it is to fix a bug, trust me.
		cell.detailTextLabel.text = @"Review Questions with Answers";
		
		// Total Marks --only show when user is finished;
		if ([PopBox count]== 0) {
			
			cell.textLabel.text = [NSString stringWithFormat:@"Your Marks = %@ / %@",appDelegate.ClientScores ,appDelegate.PossibleScores];
		}
	}
	
	
 /*	else if (indexPath.section == 0 && indexPath.row == 1){
				
		//cell.textLabel.text =@"Time ="; // [NSString stringWithFormat:@"Time = %.02f ", lblTime.text];
		
		
	} */
	
	
	else if (indexPath.section == 1){
		
	
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	
		if ([PopBox count] < 1) {
		
			cell.textLabel.text = [NSString stringWithFormat:@"No questions in criteria"];  
		}
		else {
		
			QuestionItems *QI = (QuestionItems *)[PopBox objectAtIndex:indexPath.row];
			//Show only the Filename without extension.
			//NSString *FullFileName = [NSString stringWithFormat:@"%@",[QI Question]];
			//NSArray *FileName = [FullFileName componentsSeparatedByString:@"."];
			
			cell.textLabel.text = [NSString stringWithFormat:@"Question   %@", [QI Question]];      //indexPath.row +1];     //[FileName objectAtIndex:0]];  //indexPath.row +1]; //[QI Question];
			
			//cell.textLabel.text = [NSString stringWithFormat:@"Question %i",[[NumberCounter objectAtIndex:indexPath.row]intValue]]; // Just numbering here
			
			// it was suggested we remove the marks as all marks at the moment is 1 for each question.
			// But a problem was created. When you scroll down some of the cells come up with text from 
			// section 0. So lets set this to empty text to fix the problem
			cell.detailTextLabel.text =@""; //[NSString stringWithFormat:@"Mark(s): %@", QI.AllocatedMark];
		}
	}
	
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ExitFlag = YES;
	
	if (indexPath.section != 0) {
		
	
	QuestionItems *SelectedItem = (QuestionItems *)[PopBox objectAtIndex:indexPath.row];
	
	NSString *TemplateType = [NSString stringWithFormat:@"%@", [SelectedItem.QuestionHeader1.QuestionTemplate valueForKey:@"Description"]];
	
	if ([TemplateType isEqualToString:@"Multiple Choice Single Answer"] ) {
		
		MultipleChoiceSingleAnswer *M_view = [[MultipleChoiceSingleAnswer alloc] initWithNibName:nil bundle:nil];
		M_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		M_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		M_view.QItem_View = SelectedItem;
		
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:M_view animated:YES];
		[M_view release];
	}
	else if([TemplateType isEqualToString:@"Multiple Choice Multiple Answer"]){
		
		MultipleChoiceSingleAnswer *M_view = [[MultipleChoiceSingleAnswer alloc] initWithNibName:nil bundle:nil];
		M_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		M_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		M_view.QItem_View = SelectedItem;
		
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:M_view animated:YES];
		[M_view release];
		
	}
	else if([TemplateType isEqualToString:@"Descriptive Type"]){
		
		DescriptiveType *D_view =[[DescriptiveType alloc] initWithNibName:nil bundle:nil];
		
		D_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		D_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		D_view.QItem_View = SelectedItem;
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:D_view animated:YES];
		[D_view release];
		
		
	}
	else if ([TemplateType isEqualToString:@"True or False"]){
		
		TrueOrFalseYesOrNo *T_view =[[TrueOrFalseYesOrNo alloc] initWithNibName:nil bundle:nil];
		
		T_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		T_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		T_view.QItem_View = SelectedItem;
		
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:T_view animated:YES];
		[T_view release];
		
		
	}
	else if ([TemplateType isEqualToString:@"Yes or No"]){
		
		TrueOrFalseYesOrNo *T_view =[[TrueOrFalseYesOrNo alloc] initWithNibName:nil bundle:nil];
		
		T_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		T_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		T_view.QItem_View = SelectedItem;
		
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:T_view animated:YES];
		[T_view release];
		
	}
	else if ([TemplateType isEqualToString:@"Fill the Blanks"]){
		
		FillTheBlanks *F_view = [[FillTheBlanks alloc] initWithNibName:nil bundle:nil];
		
		F_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		F_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		F_view.QItem_View = SelectedItem;
		F_view.Specialflag = FALSE;
		
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:F_view animated:YES];
		[F_view release];
		
		
	}
	
	}
	
	
	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
	ClientAnswers *C_view = [[ClientAnswers alloc] initWithNibName:nil bundle:nil];
	
	C_view.FullDataArray = UnchangedArray;
	ToReviewQuestions = 1;
	[self.navigationController pushViewController:C_view animated:YES];
	
	[C_view release];
}


#pragma mark -
#pragma mark Data Handling

// Get the ManagedObjectContext from my App Delegate
- (NSManagedObjectContext *)ManagedObjectContext {
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	return appDelegate.managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController {
	// Set up the fetched results controller if needed.
	if (fetchedResultsController == nil) {
		// Create the fetch request for the entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuestionItems" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Question" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		
		// Set the Limit
		//EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		//[fetchRequest  setFetchLimit:appDelegate.NumberOfQuestions.intValue];
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		
		NSArray *Preds = [NSArray arrayWithObjects:DifficultyPredicate,SelectedTopicPredicate,QuestionTemplatePredicate,AccessLevelPredicate, nil];
		
		
		
		NSPredicate *predicate1 = [NSCompoundPredicate andPredicateWithSubpredicates:Preds]; 
		[fetchRequest setPredicate:predicate1];
		
		[fetchRequest setIncludesSubentities:YES];
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController = aFetchedResultsController;
		
		
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	
	return fetchedResultsController;
}    


- (NSFetchedResultsController *)fetchedResultsController_Topics {
	// Set up the fetched results controller if needed.
	if (fetchedResultsController_Topics == nil) {
		// Create the fetch request for the entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Topics" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"TopicName" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController_Topics = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	
	return fetchedResultsController_Topics;
}    

- (NSFetchedResultsController *)fetchedResultsController_QT {
	// Set up the fetched results controller if needed.
	if (fetchedResultsController_QT == nil) {
		// Create the fetch request for the entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"lk_QuestionTemplate" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Description" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController_QT = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	
	return fetchedResultsController_QT;
}    


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[fetchedResultsController release];
	//[fetchedResultsController_Topics release];
	//[fetchedResultsController_QT release];
	[managedObjectContext release];
	//[SelectedTopic release];
	[QuestionTemplate release];
	[ListofQuestions release];
	//[DifficultyColumn release];
	//[DifficultyValue release];
	//[DifficultyPredicate release];
	//[SelectedTopicColumn release];
	//[SelectedTopicValue release];
	//[SelectedTopicPredicate release];
	//[QuestionTemplateColumn release];
	//[QuestionTemplateValue release];
	//[QuestionTemplatePredicate release];
	//[AccessLevelColumn release];
	//[AccessLevelValue release];
	//[AccessLevelPredicate release];
	[PopBox release];
	[UnchangedArray release];
	[timer release];
	[NumberCounter release];
	//[CollectedObjects release];
	//[SelectedArrays release];
	
	
	
	
	
	
	
    [super dealloc];
}


@end
