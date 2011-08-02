//
//  MultipleChoiceSingleAnswer1.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 05/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "MultipleChoiceSingleAnswer1.h"
#import "SelectAllocatedMarks.h"
#import "SelectDifficulty.h"
#import "EvaluatorAppDelegate.h"

static NSString *kViewKey = @"viewKey";



@implementation MultipleChoiceSingleAnswer1


@synthesize QuestionTemplate, SelectedTopic,QItem_ForEdit,SFileNameValue,RequireActivityMarker,Authorize;
@synthesize DisplayTable,DisplayedIndexPath;
@synthesize Answer1,Answer2,Answer3,Answer4,Answer5,AnswerControls,AnswerObjects;
@synthesize Answer1tick,Answer2tick,Answer3tick,Answer4tick,Answer5tick;
@synthesize managedObjectContext, fetchedResultsController;


#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950

- (void)viewDidLoad {
    [super viewDidLoad];
	
		
/*	NSLog(@"Questiontemplate is %@",self.QuestionTemplate.Description);
	NSLog(@"SelectedTopic is %@",self.SelectedTopic.TopicName);
	if (!AuthorizeVal.isOn) {
		NSLog(@"AuthorizeVal is off");
	}
	else {
		NSLog(@"AuthorizeVal is on");
	}

	
	NSLog(@"SFileNameVal is %@",self.SFileNameVal); */
	
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
	self.Answer1 =[[UITextField alloc] initWithFrame:frame];
	self.Answer2 =[[UITextField alloc] initWithFrame:frame];
	self.Answer3 =[[UITextField alloc] initWithFrame:frame];
	self.Answer4 =[[UITextField alloc] initWithFrame:frame];
	self.Answer5 =[[UITextField alloc] initWithFrame:frame];
	
	self.AnswerControls = [NSArray arrayWithObjects:
							[NSDictionary dictionaryWithObjectsAndKeys:
								self.Answer1,kViewKey,nil],
						   
						   [NSDictionary dictionaryWithObjectsAndKeys:
								self.Answer2,kViewKey,nil],
						   
						   [NSDictionary dictionaryWithObjectsAndKeys:
								self.Answer3,kViewKey,nil],
						   
						   [NSDictionary dictionaryWithObjectsAndKeys:
								self.Answer4,kViewKey,nil],
						   
						   [NSDictionary dictionaryWithObjectsAndKeys:
							self.Answer5,kViewKey,nil],
						   
						   nil];
	Answer1tick = YES;
	Answer2tick = NO;
	Answer3tick = NO;
	Answer4tick = NO;
	Answer5tick = NO;
	
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[DisplayTable reloadData];
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	if (interfaceOrientation == UIInterfaceOrientationPortrait ) {
			
		self.DisplayTable.frame = CGRectMake(2, 2, SCREEN_WIDTH, SCREEN_HEIGHT);
		RequireActivityMarker.frame = CGRectMake(200.0,10.0,40.0,45.0);
		Authorize.frame = CGRectMake(200.0, 10.0, 40.0, 45.0);
	}
	
	else {
		
		self.DisplayTable.frame = CGRectMake(2, 2, SCREEN_HEIGHT + 30 , SCREEN_WIDTH);
		RequireActivityMarker.frame = CGRectMake(350.0,10.0,40.0,45.0);
		Authorize.frame = CGRectMake(350.0, 10.0, 40.0, 45.0);
	}
	
	
	
}

-(IBAction)Commit:(id)sender{
	
	if ([self CheckAnswers] == 0) {
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
		Ans1.Correct =  self.Answer1tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
	}
	
	if (![Answer2.text length] == 0 && ![Answer2.text isEqualToString:nil] ){
		Answers *Ans2  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
		[QI addAnswers1Object:Ans2];
		
		Ans2.AnswerText = Answer2.text;
		Ans2.Correct =  self.Answer2tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
	}
	
	if (![Answer3.text length] == 0 && ![Answer3.text isEqualToString:nil] ){
		Answers *Ans3  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
		[QI addAnswers1Object:Ans3];
		
		
		Ans3.AnswerText = Answer3.text;
		Ans3.Correct =  self.Answer3tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
	}
	
	if (![Answer4.text length] == 0 && ![Answer4.text isEqualToString:nil]) {
		
		Answers *Ans4  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
		[QI addAnswers1Object:Ans4];
		
		
		Ans4.AnswerText = Answer4.text;
		Ans4.Correct =  self.Answer4tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
		
	}
	if (![Answer5.text length] == 0 && ![Answer5.text isEqualToString:nil]){
		
		Answers *Ans5  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
		[QI addAnswers1Object:Ans5];
		
		
		Ans5.AnswerText = Answer5.text;
		Ans5.Correct =  self.Answer5tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
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
	
	if ([self CheckAnswers] == 0) {
		NSString *Lmessage = [[NSString alloc] initWithFormat:@"You have not selected an Answer"];
		
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Wrong Action"
													   message:Lmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		[Lmessage release];
		[alert release];
	}
	else {
		
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
			Ans1.Correct =  self.Answer1tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
			
		}
		
		if (![Answer2.text length] == 0 && ![Answer2.text isEqualToString:nil] ){
			Answers *Ans2  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QItem_ForEdit addAnswers1Object:Ans2];
			
			Ans2.AnswerText = Answer2.text;
			Ans2.Correct =  self.Answer2tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
		}
		
		if (![Answer3.text length] == 0 && ![Answer3.text isEqualToString:nil] ){
			Answers *Ans3  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QItem_ForEdit addAnswers1Object:Ans3];
			
			
			Ans3.AnswerText = Answer3.text;
			Ans3.Correct =  self.Answer3tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
		}
		
		if (![Answer4.text length] == 0 && ![Answer4.text isEqualToString:nil]) {
			
			Answers *Ans4  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QItem_ForEdit addAnswers1Object:Ans4];
			
			
			Ans4.AnswerText = Answer4.text;
			Ans4.Correct =  self.Answer4tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
			
		}
		if (![Answer5.text length] == 0 && ![Answer5.text isEqualToString:nil]){
			
			Answers *Ans5  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QItem_ForEdit addAnswers1Object:Ans5];
			
			
			Ans5.AnswerText = Answer5.text;
			Ans5.Correct =  self.Answer5tick ? [NSNumber numberWithBool:YES ]: [NSNumber numberWithBool:NO];
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


-(int)CheckAnswers{
	int Count = 0;
	
	for (int i = 0; i<5; i++) {
		
		switch (i) {
			case 0:
				if (Answer1tick) {
					Count++;
				}
				break;
			case 1:
				if(Answer2tick){
				Count++;
				}
				break;
				
			case 2:
				if(Answer3tick){
				Count++;
				}
				break;
			case 3:
				if(Answer4tick){
					Count++;
				}
				break;
			case 4:
				if(Answer5tick){
					Count++;
				}
				break;
			
		}
	}
	
	return Count;
	
	
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
			count = 5;
			break;
	}
	
		
	return count; 
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

  */

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
				if(self.interfaceOrientation == UIInterfaceOrientationPortrait){
					RequireActivityMarker = [[[UISwitch alloc] initWithFrame:CGRectMake(200.0,10.0,40.0,45.0)] autorelease];
				}
				else {
					RequireActivityMarker = [[[UISwitch alloc] initWithFrame:CGRectMake(350.0,10.0,40.0,45.0)] autorelease];
				}

				
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
				
					if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
						Authorize =[[[UISwitch alloc] initWithFrame:CGRectMake(200.0, 10.0, 40.0, 45.0)]autorelease];
					}
					else{
						
						Authorize =[[[UISwitch alloc] initWithFrame:CGRectMake(350.0, 10.0, 40.0, 45.0)]autorelease];
					}
				
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
	
	
	
		else   {
			
			
			
			UITextField *TextField = [[self.AnswerControls objectAtIndex:indexPath.row] valueForKey:kViewKey];
			
			
			TextField.adjustsFontSizeToFitWidth = YES;
			TextField.borderStyle = UITextBorderStyleRoundedRect;
			TextField.textColor = [UIColor blackColor];
			TextField.placeholder = [NSString stringWithFormat:@"<enter answer> %i",indexPath.row + 1];
			TextField.autocorrectionType = UITextAutocorrectionTypeNo;
			//TextField.returnKeyType = UIReturnKeyNext;
			TextField.textAlignment = UITextAlignmentLeft;
			TextField.tag = indexPath.row;
			TextField.clearButtonMode = UITextFieldViewModeAlways;
			TextField.delegate = self;
			[cell.contentView addSubview:TextField]; 
				
			if (QItem_ForEdit != nil) {
				
				if (indexPath.row < AnswerObjects.count) {
					TextField.text = [[AnswerObjects objectAtIndex:indexPath.row]valueForKey:@"AnswerText"];
					if ([[[AnswerObjects objectAtIndex:indexPath.row] valueForKey:@"Correct"]boolValue]) {
						cell.accessoryType = UITableViewCellAccessoryCheckmark;
					}
					//cell.accessoryType = 
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

									  



- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
      
	
	

	/// Fix problem of Keyvboard blocking text fields
	
	switch (textField.tag) {
			
		case 0:
		{
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			CGRect rect = self.view.frame;
			rect.origin.y = -150;
			rect.size.height = 690;
			self.view.frame = rect;
			[UIView commitAnimations];
			break;
		}
		case 1:
		{
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			CGRect rect = self.view.frame;
			rect.origin.y = -180;
			rect.size.height = 690;
			self.view.frame = rect;
			[UIView commitAnimations];
			break;
		}
		case 2:
		{
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			CGRect rect = self.view.frame;
			rect.origin.y = -210;
			rect.size.height = 690;
			self.view.frame = rect;
			[UIView commitAnimations];
			break;
		}
		case 3:
		{
			//CGRect Group = [DisplayTable rectForSection:1];
			//Group.size.height = 600;
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			CGRect rect = self.view.frame;
			rect.origin.y = -240;
			rect.size.height = 690;
			self.view.frame = rect;
			[UIView commitAnimations];
			break;
		}
		case 4:
		{
			
			
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			CGRect rect = self.view.frame;
			rect.origin.y = -270;
			rect.size.height = 690;
			self.view.frame = rect;
			[UIView commitAnimations];
			break;
		}
		default:
			break;
	}
	
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect rect = self.view.frame;
	rect.origin.y = 0;
	rect.size.height = 450;
	self.view.frame = rect;
	[UIView commitAnimations];
	   
	
	return YES;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	

	
	if (indexPath.section == 2 ) {
		UITableViewCell *SelectedCell = [DisplayTable cellForRowAtIndexPath:indexPath];
		
		// Deselect all the cells for Multiple Answer single question so that only one cell can be marked as answer.
		if ([QuestionTemplate.Description isEqualToString:@"Multiple Choice Single Answer"]) {
			NSArray *Allcells = [DisplayTable visibleCells];
			for (UITableViewCell *cell in Allcells){
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
		
		
		if (SelectedCell.accessoryType == UITableViewCellAccessoryNone) {
			SelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			if (indexPath.row == 0)  {            /// serious bug in objective c can't use switch here.
					
				Answer1tick = YES;
					
			}
			else if (indexPath.row == 1) {
				
				Answer2tick = YES;
			}
			else if (indexPath.row == 2) {
				
				Answer3tick = YES;
			}
			else if (indexPath.row == 3) {
				
				Answer4tick = YES;
			}
			else if (indexPath.row == 4) {
				
				Answer5tick = YES;
			}
				
							
		}
		
		else{
			SelectedCell.accessoryType = UITableViewCellAccessoryNone;
			
			
			
			if (indexPath.row == 0)  {            /// serious bug in objective c can't use switch here.
				
				Answer1tick = NO;
				
			}
			else if (indexPath.row == 1) {
				
				Answer2tick = NO;
			}
			else if (indexPath.row == 2) {
				
				Answer3tick = NO;
			}
			else if (indexPath.row == 3) {
				
				Answer4tick = NO;
			}
			else if (indexPath.row == 4) {
				
				Answer5tick = NO;
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
    Answer1 = nil;
	Answer2 = nil;
	Answer3 = nil;
	Answer4 = nil;
	Answer5 = nil;
	
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
	[Answer2 release];
	[Answer3 release];
	[Answer4 release];
	[Answer5 release];
	[AnswerControls release];
	[AnswerObjects release];
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end
