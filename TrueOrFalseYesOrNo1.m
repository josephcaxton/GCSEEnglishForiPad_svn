//
//  TrueOrFalseYesOrNo1.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 27/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "TrueOrFalseYesOrNo1.h"
#import "SelectAllocatedMarks.h"
#import "SelectDifficulty.h"
#import "EvaluatorAppDelegate.h"

static NSString *kViewKey = @"viewKey";

@implementation TrueOrFalseYesOrNo1

@synthesize QuestionTemplate, SelectedTopic,QItem_ForEdit,SFileNameValue,RequireActivityMarker,Authorize;
@synthesize DisplayTable,DisplayedIndexPath;
@synthesize True,False,AnswerControls,AnswerObjects;
@synthesize Truetick;
@synthesize managedObjectContext, fetchedResultsController;


#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950


- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (QItem_ForEdit !=nil) {
		
		UIBarButtonItem *UpdateButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style: UIBarButtonItemStyleBordered target:self action:@selector(Update:)];
		self.navigationItem.rightBarButtonItem = UpdateButton;
		[UpdateButton release];
		
		
		AnswerObjects=  [[NSMutableArray alloc] initWithArray:[[QItem_ForEdit Answers1] allObjects]];
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		appDelegate.AllocatedMarks = QItem_ForEdit.AllocatedMark;
		
		switch ([QItem_ForEdit.Difficulty intValue]) {
			case 1:
				appDelegate.Difficulty =@"Foundation";
				break;
			case 0:
				appDelegate.Difficulty =@"Foundation & Higher";
				break;
			case 3:
				appDelegate.Difficulty =@"Higher";
				break;
		}
		
		
	}
	else {
		UIBarButtonItem *CommitButton = [[UIBarButtonItem alloc] initWithTitle:@"Commit" style: UIBarButtonItemStyleBordered target:self action:@selector(Commit:)];
		self.navigationItem.rightBarButtonItem = CommitButton;
		[CommitButton release];
		
	}
	
	self.DisplayTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 2, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
	DisplayTable.delegate = self;
	DisplayTable.dataSource = self;
	DisplayTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
	
	[self.view addSubview:DisplayTable];
	
	CGRect frame = CGRectMake(5, 5, 250, 30);
	self.True =[[UILabel alloc] initWithFrame:frame];
	self.False =[[UILabel alloc] initWithFrame:frame];
		
	self.AnswerControls = [NSArray arrayWithObjects:
						   [NSDictionary dictionaryWithObjectsAndKeys:
							self.True,kViewKey,nil],
						   
						   [NSDictionary dictionaryWithObjectsAndKeys:
							self.False,kViewKey,nil],
						   
						   nil];
	Truetick = YES;
	
	
	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[DisplayTable reloadData];
	
}
-(IBAction)Commit:(id)sender{
	
		
		NSManagedObjectContext *context = [self ManagedObjectContext];
		
		QuestionHeader *QH = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionHeader" inManagedObjectContext:context];
		
		
		QH.Autorize = ([Authorize isOn] ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO]);
		
		if ([Authorize isOn]) {
			
			
			QH.DateAutorized = [NSDate date]; 
			
			
			
		}
		
		
		
		
		
		QH.QuestionTemplate = self.QuestionTemplate; 
		QH.QuestionHeader_Topic = self.SelectedTopic;
		
		QuestionItems *QI = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionItems" inManagedObjectContext:context]; 
		[QH  addQuestionItemsObject:QI];
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		QI.AllocatedMark = [appDelegate AllocatedMarks]; 
		
		if ([appDelegate.Difficulty  isEqualToString:@"Foundation" ]) {
			
			QI.Difficulty = [NSNumber numberWithInt:1];
		}
		else if ([appDelegate.Difficulty isEqualToString:@"Foundation & Higher"]){
			
			QI.Difficulty = [NSNumber numberWithInt:0];
			
		}
		else{
			
			QI.Difficulty = [NSNumber numberWithInt:3];
			
		}
		
		QI.Question = SFileNameValue;
		
		
		QI.RequireActivityMarker = ([RequireActivityMarker isOn] ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO]);
		
		
			Answers *Ans1  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans1];
			
			
		    Ans1.AnswerText = self.Truetick ? [NSString stringWithFormat:@"%i",1] : [NSString stringWithFormat:@"%i",0];
		    Ans1.Correct =  [NSNumber numberWithBool:YES ];
		
		
				
		NSError *error = nil;
		if (![context save:&error]) {
			
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
			
			//NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			//abort();
		}
		
		
		NSString *message = [[NSString alloc] initWithFormat:@"Question Successfully entered"];
		
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Question added"
													   message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		[message release];
		[alert release];
		
		[self.navigationController popToRootViewControllerAnimated:YES];
		
		
		
	} // end of else 
	
	
	
	
	
	


-(IBAction)Update:(id)sender{
	
		
		// important to change the context here;
		
		NSManagedObjectContext *context = QItem_ForEdit.managedObjectContext;
		
		
		QItem_ForEdit.QuestionHeader1.Autorize = ([Authorize isOn] ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO]);
		
		if ([Authorize isOn]) {
			
			
			QItem_ForEdit.QuestionHeader1.DateAutorized = [NSDate date]; 
			
		}
		
		// *******Note here QuestionTemplate and Topic Should never be updated.
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		QItem_ForEdit.AllocatedMark = [appDelegate AllocatedMarks];
		
		if ([appDelegate.Difficulty  isEqualToString:@"Foundation" ]) {
			
			QItem_ForEdit.Difficulty = [NSNumber numberWithInt:1];
		}
		else if ([appDelegate.Difficulty isEqualToString:@"Foundation & Higher"]){
			
			QItem_ForEdit.Difficulty = [NSNumber numberWithInt:0];
			
		}
		else{
			
			QItem_ForEdit.Difficulty = [NSNumber numberWithInt:3];
			
		}
		
		QItem_ForEdit.RequireActivityMarker = ([RequireActivityMarker isOn] ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO]);
		
		
		// remove all the existing objects in the NSSet
		
		NSSet *AnswersSet = QItem_ForEdit.Answers1;
		
		NSMutableSet *mutable = [NSMutableSet setWithSet:AnswersSet];
		[mutable removeAllObjects];
		QItem_ForEdit.Answers1 = mutable;
		
		// Now update with new objects
		
		
			
			Answers *Ans1  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QItem_ForEdit addAnswers1Object:Ans1];
			
			Ans1.AnswerText = self.Truetick ? [NSString stringWithFormat:@"%i",1] : [NSString stringWithFormat:@"%i",0];
			Ans1.Correct =  [NSNumber numberWithBool:YES ];

			
		
		NSError *error = nil;
		if (![context save:&error]) {
			
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			
		}
		
		NSString *message = [[NSString alloc] initWithFormat:@"Successfully updated"];
		
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Question updated"
													   message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		[message release];
		[alert release];
		
		[self.navigationController popToRootViewControllerAnimated:YES];
		
		
	}
	


		

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




-(NSString *)DifficultyConverter:(NSNumber*)Val{
	NSString *RetVal= @"";
	
	switch ([Val intValue]) {
		case 1:
			RetVal = @"Foundation";
			break;
		case 0:
			RetVal = @"Foundation & Higher";
			break;
		case 3:
			RetVal = @"Higher";
			break;
	}
	return RetVal;
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 3;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	NSInteger count = 0;
	
	switch (section) {
		case 0:
			count = 2;
			break;
		case 1:
			count = 2;
			break;	
			
		case 2:
			count = 2;
			break;
	}
	
	
	return count; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	
	if (indexPath.section == 0) {
		
		
	    switch (indexPath.row) {
			case 0:
				
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				cell.textLabel.text = @"Allocated Marks";
				cell.tag = 3;
				if (QItem_ForEdit != nil) {
					// edit  mode here
					appDelegate.AllocatedMarks = [QItem_ForEdit AllocatedMark]; //Objective c Madness
					cell.detailTextLabel.text = [appDelegate.AllocatedMarks stringValue];
					
				}
				else {
					
					cell.detailTextLabel.text = [appDelegate.AllocatedMarks stringValue];
					
					
				}
				break;
			case 1:
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				cell.textLabel.text = @"Difficulty";
				EvaluatorAppDelegate *appDelegate1 = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
				cell.tag = 3;
				
				if (QItem_ForEdit != nil) {
					
					
					appDelegate1.Difficulty = [self DifficultyConverter:[QItem_ForEdit Difficulty]];
					cell.detailTextLabel.text = appDelegate1.Difficulty;
					
				}
				
				else {
					if ([appDelegate1.Difficulty isEqualToString:@"All"]) {
						[appDelegate1 setDifficulty:(NSString *)@"Foundation"];
					}
					
					cell.detailTextLabel.text = appDelegate1.Difficulty;
				}
				
				break;
				
				
		}
		
		return cell;
	}
	else if (indexPath.section == 1)
	{
		
		switch (indexPath.row) {
				
			case 0:
				RequireActivityMarker = [[[UISwitch alloc] initWithFrame:CGRectMake(200.0,10.0,40.0,45.0)] autorelease];
				RequireActivityMarker.tag = 3;
				cell.textLabel.text = @"Teacher to Mark";
				
				if (QItem_ForEdit != nil) {
					
					RequireActivityMarker.on = [[QItem_ForEdit RequireActivityMarker]boolValue];
					[cell.contentView addSubview:RequireActivityMarker];
				}
				else {
					
					RequireActivityMarker.on = NO;
					[cell.contentView addSubview:RequireActivityMarker];
					
					
				}
				break;
				
			case 1:
				Authorize =[[[UISwitch alloc] initWithFrame:CGRectMake(200.0, 10.0, 40.0, 45.0)]autorelease];
				Authorize.tag = 3;
				cell.textLabel.text = @"Authorize";
				
				if (QItem_ForEdit != nil) {
					
					Authorize.on =[[QItem_ForEdit.QuestionHeader1 Autorize]boolValue];
					
					[cell.contentView addSubview:Authorize];
					
				}
				else {
					
					Authorize.on = YES;
					[cell.contentView addSubview:Authorize];
				}
				
				break;
				
				
		}
		
		return cell;
	}
	
	
	
	else {
		
		
		UILabel *LabelField = [[self.AnswerControls objectAtIndex:indexPath.row] valueForKey:kViewKey];
		
		
		LabelField.adjustsFontSizeToFitWidth = YES;
		LabelField.textColor = [UIColor blackColor];
		if (indexPath.row == 0) {
			 if ([QuestionTemplate.Description isEqualToString:@"True or False"] ) {
				
				 LabelField.text = [NSString stringWithFormat:@"True"];
				}
				  else {
					  
					 
					  LabelField.text = [NSString stringWithFormat:@"Yes"];
					  
				}
			
		}
		else{
			 if ([QuestionTemplate.Description isEqualToString:@"True or False"]) {
				 
				 LabelField.text = [NSString stringWithFormat:@"False"];
			 }
			else{
					LabelField.text = [NSString stringWithFormat:@"No"];
				}
		}
		
		
		LabelField.textAlignment = UITextAlignmentLeft;
		LabelField.tag = indexPath.row;
		[cell.contentView addSubview:LabelField]; 
		
		if (QItem_ForEdit != nil) {
			
			 if (indexPath.row == 0) {
				 if ([[[AnswerObjects objectAtIndex:0] valueForKey:@"AnswerText"]boolValue]) {
					 cell.accessoryType = UITableViewCellAccessoryCheckmark;
				 }
				 else {
					 
					 cell.accessoryType = UITableViewCellAccessoryNone;
				 }
			 }
			else {
				
				if ([[[AnswerObjects objectAtIndex:0] valueForKey:@"AnswerText"]boolValue]) {
					
					cell.accessoryType = UITableViewCellAccessoryNone;
				}
				else {
					
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
				 }
			}

			
			
		}
		
		else {
			
			
			
			
			if (indexPath.row == 0) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
		}
		
		return cell;
		
	}
	
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	
	
	if (indexPath.section == 2 ) {
		UITableViewCell *SelectedCell = [DisplayTable cellForRowAtIndexPath:indexPath];
		
		// Deselect all the cells so that only one cell can be marked as answer.
		
			NSArray *Allcells = [DisplayTable visibleCells];
			for (UITableViewCell *cell in Allcells){
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		
		
		
		if (SelectedCell.accessoryType == UITableViewCellAccessoryNone) {
			SelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			if (indexPath.row == 0)  {            /// serious bug in objective c can't use switch here.
				
				Truetick= YES;
				
			}
			else if (indexPath.row == 1) {
				
				Truetick = NO;
			}
						
			
		}
		
		else{
			SelectedCell.accessoryType = UITableViewCellAccessoryNone;
			
			
			
			if (indexPath.row == 0)  {            /// serious bug in objective c can't use switch here.
				
				Truetick = NO;
				
			}
			else if (indexPath.row == 1) {
				
				Truetick = YES;
			}
						
			
			
		}
		
	}
	
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.row == 0) {
		
		SelectAllocatedMarks *AllocatedMarks_view = [[SelectAllocatedMarks alloc] initWithNibName:nil bundle:nil];
		AllocatedMarks_view.QItem_ForEdit = self.QItem_ForEdit;
		[self.navigationController pushViewController:AllocatedMarks_view animated:YES];
		[AllocatedMarks_view release];
	}
	else if(indexPath.row == 1) {
		
		SelectDifficulty *Difficulty_view = [[SelectDifficulty alloc]initWithNibName:nil bundle:nil];
		Difficulty_view.QItem_ForEdit =  self.QItem_ForEdit;
		[self.navigationController pushViewController:Difficulty_view animated:YES];
		[Difficulty_view release];
	}
	
	
}

#pragma mark -
#pragma mark Data Handling

// Get the ManagedObjectContext from my App Delegate
- (NSManagedObjectContext *)ManagedObjectContext {
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	return appDelegate.managedObjectContext;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    True = nil;
	False = nil;
	
}


- (void)dealloc {
	[QuestionTemplate release];
	[SelectedTopic release];
	[QItem_ForEdit release];
	[SFileNameValue release];
	[DisplayTable release];
	[DisplayedIndexPath release];
	[RequireActivityMarker release];
	[Authorize release];
	[True release];
	[False release];
	[AnswerControls release];
	[AnswerObjects release];
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end
