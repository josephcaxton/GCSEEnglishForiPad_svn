//
//  DescriptiveType1.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 26/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "DescriptiveType1.h"
#import "SelectAllocatedMarks.h"
#import "SelectDifficulty.h"
#import "EvaluatorAppDelegate.h"





@implementation DescriptiveType1

@synthesize QuestionTemplate, SelectedTopic,QItem_ForEdit,SFileNameValue,RequireActivityMarker,Authorize;
@synthesize DisplayTable,DisplayedIndexPath;
@synthesize Answer1, AnswerObjects; 
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
	
	CGRect frame = CGRectMake(5, 5, 290, 140);
	self.Answer1 =[[UITextView alloc] initWithFrame:frame];
	
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[DisplayTable reloadData];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)Commit:(id)sender{
	
	if ([Answer1.text length] == 0 || [Answer1.text isEqualToString:nil]) {
		NSString *Lmessage = [[NSString alloc] initWithFormat:@"You have not selected an Answer"];
		
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Wrong Action"
													   message:Lmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		[Lmessage release];
		[alert release];
	}
	else { 
		
		
		
		
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
		
		if (![Answer1.text length] == 0 && ![Answer1.text isEqualToString:nil]) {
			Answers *Ans1  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans1];
			
			
			Ans1.AnswerText = Answer1.text;
			
			Ans1.Correct =  [NSNumber numberWithBool:YES ];
		}
		
				
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
	
	
}
	
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
		
		if (![Answer1.text length] == 0 && ![Answer1.text isEqualToString:nil]) {
			
			Answers *Ans1  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QItem_ForEdit addAnswers1Object:Ans1];
			
			Ans1.AnswerText = Answer1.text;
			Ans1.Correct = [NSNumber numberWithBool:YES ];
			
		}
		
		
		
		
		
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
			count = 1;
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
					
					RequireActivityMarker.on = YES;
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
		
		
		
		Answer1.editable = YES;
		Answer1.delegate = self;
		Answer1.textColor = [UIColor blackColor];
		
		Answer1.autocorrectionType =UITextAutocorrectionTypeYes;
		Answer1.textAlignment = UITextAlignmentLeft;
		Answer1.tag = indexPath.row;
		
		if (QItem_ForEdit != nil){
			
			Answer1.text = [[AnswerObjects objectAtIndex:indexPath.row]valueForKey:@"AnswerText"];
			
		}
		
	
		[cell.contentView addSubview:Answer1]; 
		
			
		return cell;
		
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section == 2) {
		
		return 150;
	}
	return 50;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect rect = self.view.frame;
	rect.origin.y = -230;
	rect.size.height = 690;
	self.view.frame = rect;
	[UIView commitAnimations];
	
	
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        
        [Answer1 resignFirstResponder];
		// return screen to where is should be
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		CGRect rect = self.view.frame;
		rect.origin.y = 0;
		rect.size.height = 450;
		self.view.frame = rect;
		[UIView commitAnimations];
		
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	
	
 	
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
    Answer1 = nil;
	
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
	[Answer1 release];
	[AnswerObjects release];
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end
