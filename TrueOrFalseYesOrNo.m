//
//  TrueOrFalseYesOrNo.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 27/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "TrueOrFalseYesOrNo.h"
#import "lk_QuestionTemplate.h"
#import "Topics.h"
#import "QuestionHeader.h"
#import "QuestionItems.h"
#import "Answers.h"
#import "TrueOrFalseYesOrNo1.h"

static NSString *kViewKey = @"viewKey";


@implementation TrueOrFalseYesOrNo


@synthesize QuestionTemplate, SelectedTopic; //, QuestionHeaderBox; //Search;  //QuestionItemBox
@synthesize fileList, FileListTable, DirLocation,SFileName;
@synthesize  SFileName_Edit,QItem_Edit,QItem_View,AnswerObjects,AnswerControls,True,False,ShowAnswer,RemoveContinueButton,Continue;

int Answerflag_Show = 0;
static UIWebView *QuestionHeaderBox = nil;
#pragma mark -
#pragma mark View lifecycle

#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950


- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
	QuestionHeaderBox =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 400)];
	QuestionHeaderBox.scalesPageToFit = YES;
	
	self.FileListTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 260, SCREEN_WIDTH, SCREEN_HEIGHT - 170) style:UITableViewStyleGrouped];
	FileListTable.delegate = self;
	FileListTable.dataSource = self;
	FileListTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
	
	
	// Now I have added 1000 pdfs to the bundle. App is now ver slow
	// I don't need this to go live, it is just for admin only so i comment out CheckExistingFiles
	//CheckExistingFiles *ExistingFiles = [[CheckExistingFiles alloc]init];
	//NSArray *lists = ExistingFiles.ListofPdfsNotInDataBase;
	//self.fileList = lists;    
	
	//if ([fileList count ]  > 0) {
		
	//	NSString *FullFileName = [NSString stringWithFormat:@"%@",[fileList objectAtIndex:0]];
	//	[self setSFileName:[FullFileName lastPathComponent]];
		
		
	//}
	if (QItem_Edit != nil || QItem_View != nil) {
		// this means we are not in edit mode. we are in create mode.
		
		
		if (QItem_Edit) {
		
		NSString *result = [NSString stringWithFormat:@"%@",[QItem_Edit Question]];
		SFileName_Edit = result;
		
		
		UIBarButtonItem *NextButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStyleBordered target:self action:@selector(Edit:)];
		self.navigationItem.rightBarButtonItem = NextButton;
		[NextButton release];
		
		}
		else
		{
			// This is QItem_View  : View Mode
			
			CGRect frame = CGRectMake(5, 5, 250, 30);
			self.True =[[UILabel alloc] initWithFrame:frame];
			self.True.backgroundColor = [UIColor clearColor];
			self.False =[[UILabel alloc] initWithFrame:frame];
			self.False.backgroundColor = [UIColor clearColor];
			
			self.AnswerControls = [NSArray arrayWithObjects:
								   [NSDictionary dictionaryWithObjectsAndKeys:
									self.True,kViewKey,nil],
								   
								   [NSDictionary dictionaryWithObjectsAndKeys:
									self.False,kViewKey,nil],
								   
								   nil];
			
			NSString *result = [NSString stringWithFormat:@"%@",[QItem_View Question]];
			SFileName_Edit = result;
			
			AnswerObjects=  [[NSMutableArray alloc] initWithArray:[[QItem_View Answers1] allObjects]];
			
			UIBarButtonItem *SendSupportMail = [[UIBarButtonItem alloc] initWithTitle:@"Report Problem" style: UIBarButtonItemStyleBordered target:self action:@selector(ReportProblem:)];
			self.navigationItem.rightBarButtonItem = SendSupportMail;
			[SendSupportMail release];
			
			
		}
		
		
		[self loadDocument:[SFileName_Edit stringByDeletingPathExtension] inView:QuestionHeaderBox];
	}
	
	else{
		
		
		UIBarButtonItem *NextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style: UIBarButtonItemStyleBordered target:self action:@selector(Next:)];
		
		self.navigationItem.rightBarButtonItem = NextButton;
		[NextButton release];
		
		[self loadDocument:[SFileName stringByDeletingPathExtension] inView:QuestionHeaderBox];
	}
	
	[self.view addSubview:QuestionHeaderBox];
	[QuestionHeaderBox release];
	[self.view addSubview:FileListTable];
	[FileListTable release];
	
}
-(void)viewWillAppear:(BOOL)animated{
	
	
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
}

-(IBAction)Next:(id)sender{
	
	TrueOrFalseYesOrNo1 *T_view1 = [[TrueOrFalseYesOrNo1 alloc] initWithNibName:nil bundle:nil];
	
	
	T_view1.QuestionTemplate = self.QuestionTemplate;
	
	T_view1.SelectedTopic = self.SelectedTopic;
	T_view1.SFileNameValue = self.SFileName;
	
	[self.navigationController pushViewController:T_view1 animated:YES];
	
	[T_view1 release];
	
	
}

-(IBAction)Edit:(id)sender{
	
	TrueOrFalseYesOrNo1 *T_view1 = [[TrueOrFalseYesOrNo1 alloc] initWithNibName:nil bundle:nil];
	
	T_view1.QItem_ForEdit = QItem_Edit;
	T_view1.QuestionTemplate = (lk_QuestionTemplate *)QItem_Edit.QuestionHeader1.QuestionTemplate;
	
	
	[self.navigationController pushViewController:T_view1 animated:YES];
	
	[T_view1 release];
	
	
}

-(IBAction)Cancel:(id)sender{
	
	//[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)ContinueToNextQuestion:(id)sender{
	
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(IBAction)ReportProblem:(id)sender{
	
	if ([MFMailComposeViewController canSendMail]) {
		
		NSArray *SendTo = [NSArray arrayWithObjects:@"Support@LearnersCloud.com",nil];
		
		MFMailComposeViewController *SendMailcontroller = [[MFMailComposeViewController alloc]init];
		SendMailcontroller.mailComposeDelegate = self;
		[SendMailcontroller setToRecipients:SendTo];
		[SendMailcontroller setSubject:[NSString stringWithFormat:@"Ref %@ problem chemistry question detected on IPad",[[NSString stringWithFormat:@"%@",QItem_View.Question] stringByDeletingPathExtension]]];
		
		[SendMailcontroller setMessageBody:[NSString stringWithFormat:@"Question Number %@ -- \n Additional Messages can be added to this email ", [[NSString stringWithFormat:@"%@",QItem_View.Question] stringByDeletingPathExtension]] isHTML:NO];
		[self presentModalViewController:SendMailcontroller animated:YES];
		[SendMailcontroller release];
		
	}
	
	else {
		UIAlertView *Alert = [[UIAlertView alloc] initWithTitle: @"Cannot send mail" 
														message: @"Device is unable to send email in its current state. Configure email" delegate: self 
											  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[Alert show];
		
		[Alert release];
	}
	
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
	
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	
	
	
	
}





-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView{
	
	NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		QuestionHeaderBox.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 400);
		self.FileListTable.frame = CGRectMake(2, 260, SCREEN_WIDTH, SCREEN_HEIGHT - 170);
		Continue.frame = CGRectMake(625, 0, 100, 44);
		
	}
	
	else {
		
		QuestionHeaderBox.frame = CGRectMake(140, 0,  SCREEN_HEIGHT - 182, 320);
		self.FileListTable.frame = CGRectMake(0, 260, SCREEN_HEIGHT + 80, SCREEN_HEIGHT - 160);
		Continue.frame = CGRectMake(885, 0, 100, 44);
	}
	
	
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
			
		return 1;
	
	
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title;
	
	if (QItem_View && !ShowAnswer) {
		
		title = @"";
	}
	else if (QItem_View && ShowAnswer){
		
		title = @"The correct answer is :";
	}
	else {
		
		title = @"Available Files";
	}
	
	return title; 
	
	
	
	
	
	
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
	
	if (QItem_View  && !ShowAnswer){
		
		count = [AnswerControls count];
		
	}
	else if (QItem_View && ShowAnswer){
		
		count = [AnswerControls count] + 1 ;// I am adding one more row here to add Continue button
	}
	
	else {
		
		count = [fileList count];
	}
	
	return count; 
	
}

// Customize the appearance of table view cells.
// Note all answers are on IndexPath row: 0 because there is only one line on the answers table of the database
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
     WebViewInCell *cell = (WebViewInCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[WebViewInCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (QItem_Edit != nil) {
		// We are in edit mode here so don't show any row
		if (indexPath.row == 0) {
			cell.textLabel.text =@"You can't select file in edit mode";
		}
		return cell;
		
	}
	
	if (QItem_View !=nil ) {
		
		if (indexPath.row == 0) {
			
			UILabel *LabelField = [[self.AnswerControls objectAtIndex:indexPath.row] valueForKey:kViewKey];
			
			LabelField.adjustsFontSizeToFitWidth = YES;
			LabelField.textColor = [UIColor blackColor];
			LabelField.textAlignment = UITextAlignmentLeft;
			LabelField.tag = indexPath.row;
			
			if ([QuestionTemplate.Description isEqualToString:@"True or False"] ) {
				
				LabelField.text = [NSString stringWithFormat:@"True"];
				if (ShowAnswer && [[[AnswerObjects objectAtIndex:0] valueForKey:@"AnswerText"]boolValue] == TRUE) {
					 
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
						
					}
					
			}
		
			else {
				
				
				LabelField.text = [NSString stringWithFormat:@"Yes"];
				if (ShowAnswer && [[[AnswerObjects objectAtIndex:0] valueForKey:@"AnswerText"]boolValue] == TRUE) {
					
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
					
				}
				
			}
			
			[cell.contentView addSubview:LabelField]; 
		}
		else if (indexPath.row	== 1){
			
			UILabel *LabelField = [[self.AnswerControls objectAtIndex:indexPath.row] valueForKey:kViewKey];
			
			LabelField.adjustsFontSizeToFitWidth = YES;
			LabelField.textColor = [UIColor blackColor];
			LabelField.textAlignment = UITextAlignmentLeft;
			LabelField.tag = indexPath.row;
			
			if ([QuestionTemplate.Description isEqualToString:@"True or False"]) {
				
				LabelField.text = [NSString stringWithFormat:@"False"];
				if (ShowAnswer && [[[AnswerObjects objectAtIndex:0] valueForKey:@"AnswerText"]boolValue] == FALSE) {
					
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
					
				}
			}
			else{
				LabelField.text = [NSString stringWithFormat:@"No"];
				if (ShowAnswer && [[[AnswerObjects objectAtIndex:0] valueForKey:@"AnswerText"]boolValue] == FALSE) {
					
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
					
				}
			}
			
			
			[cell.contentView addSubview:LabelField]; 
		}
		else if (indexPath.row ==2){
			
			Continue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[Continue setTitle:@"Continue" forState:UIControlStateNormal];
			
			[Continue addTarget:self action:@selector(ContinueToNextQuestion:) forControlEvents:UIControlEventTouchUpInside];
			[cell addSubview:Continue];
            NSMutableString *Reason = [NSMutableString stringWithFormat:@"%@",[[AnswerObjects objectAtIndex:0] valueForKey:@"Reason"]];
            
            
            if([Reason isEqualToString:@"(null)"] || !Reason) {
                
                //ThereIsAnswerReason = 0;
            }
            else 
            { 
                //ThereIsAnswerReason = 1;
                
                NSMutableString *FormatedString = [[NSMutableString alloc]initWithString:@"<p><font size =\"3\" face =\"times new roman \"> "];
                [FormatedString appendFormat:@"<br/>"];
                [FormatedString appendFormat:@"<br/>"];
                //[FormatedString appendFormat:@"<br/>"];
                [FormatedString appendString:Reason]; 
                [FormatedString appendString:@"</font></p>"];
                [self configureCell:cell HTMLStr:FormatedString];
                [FormatedString release];
                
            }

			
			if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
				
				Continue.frame = CGRectMake(625, 0, 100, 44);
			}
			else {
				
				Continue.frame = CGRectMake(885, 0, 100, 44);
			}
			
			
	}
		
		if (ShowAnswer) {
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		if(ShowAnswer && RemoveContinueButton)
        {
            
            Continue.hidden = YES;
        }

		
		
		return cell;
	}
	
	
	
	else
	{
		cell.textLabel.text = [NSString stringWithFormat:@"%@",[fileList objectAtIndex:indexPath.row]];
		return cell;
		
	}
	

}

- (void)configureCell:(WebViewInCell *)mycell HTMLStr:(NSString *)value; {
    
    mycell.HTMLText =value;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // increase the size of the answer cell, but ignore the the continue button cell 
    
	return 44;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (QItem_Edit == nil && QItem_View == nil ){
		//not in edit mode
		NSString *FullFileName = [NSString stringWithFormat:@"%@",[fileList objectAtIndex:indexPath.row]];
		[self setSFileName:FullFileName];
		
		
		[self loadDocument:[SFileName stringByDeletingPathExtension] inView:QuestionHeaderBox];
		
	}
	
	if (QItem_View && !ShowAnswer) {
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		//ObjectAtindex here has been hardcoded as zero reason is only one object is return on this template
		// For this template YES and TRUE will always be on indexpath.Row = 0
		
		NSNumber *Val = [[AnswerObjects objectAtIndex:0] valueForKey:@"AnswerText"];
		// @Val will always be 1.
		
		
		if ([Val boolValue] == TRUE && indexPath.row + 1  == 1) {
			
			
			//Play Clappy Sound 
			BOOL PlaySound = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"];
			if (PlaySound == YES) {
				
			[appDelegate PlaySound:@"Clapping"];
				
			}
			
			// Users Answer is correct so add the marks on the question to appdelegate.ClientScores
			
			
			NSInteger Counter = [[appDelegate ClientScores]intValue];
			NSNumber *Marks =QItem_View.AllocatedMark;
			
			Counter += [Marks intValue];
			
			appDelegate.ClientScores = [NSNumber numberWithInt:Counter];
			
			[self.navigationController popViewControllerAnimated:YES];
			
			
		}
		else if ([Val boolValue] == FALSE  && indexPath.row == 1){
			
			//Play Clappy Sound 
			BOOL PlaySound = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"];
			if (PlaySound == YES) {
			
			[appDelegate PlaySound:@"Clapping"];
			}
			
			// Users Answer is correct so add the marks on the question to appdelegate.ClientScores
			
			
			NSInteger Counter = [[appDelegate ClientScores]intValue];
			NSNumber *Marks =QItem_View.AllocatedMark;
			
			Counter += [Marks intValue];
			
			appDelegate.ClientScores = [NSNumber numberWithInt:Counter];
			
			[self.navigationController popViewControllerAnimated:YES];
		}
		
		else{
		
			// Users Answer is wrong
			// So Do nothing
			
			//Play Saddy Sound
			BOOL PlaySound = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"];
			if (PlaySound == YES) {
				
			[appDelegate PlaySound:@"Cough"];
			
			}
			
			// if user want answer to be shown then show answer
			
			BOOL ShowMyAnswer = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowMyAnswers"];
			
			if (ShowMyAnswer == YES){
				
				
				ShowAnswer = TRUE;
				[tableView reloadData];
				
				
				
				
			}
			
			else {
				
				[self.navigationController popViewControllerAnimated:YES];
			}
		}
	}
	
}
	
	
	



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	QuestionHeaderBox = nil;
}


- (void)dealloc {
	[QuestionTemplate release];
	[SelectedTopic release];
	//[QuestionHeaderBox release];
	
	[fileList release];
	[FileListTable release];
	[SFileName release];
	[DirLocation release];
	//[SFileName_Edit release];
	
	[QItem_Edit release];
	
	[QItem_View release];
	[AnswerObjects release];
	[AnswerControls release];
	[True release];
	[False release];
	//[Continue release];
    [super dealloc];
}


@end
