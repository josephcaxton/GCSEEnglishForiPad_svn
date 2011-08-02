//
//  Start.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 31/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "Start.h"


@implementation Start

@synthesize FirstView, SecondView,FirstTable,SecondTable,QuestionPickerView,CustomDataSource,Sound,ShowAnswers,logoView,Copyright,WebText,StartPractice,btnStartTest;


#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950
#define _TransitionDuration	0.45

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// First View and Children
	CGRect FirstViewframe = CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT);
	self.FirstView = [[UIView alloc] initWithFrame:FirstViewframe];
	//[self.FirstView setBackgroundColor:[UIColor redColor]];
	[self.view addSubview:FirstView];
	[self PageButton:1];
	
	self.FirstTable = [[UITableView alloc] initWithFrame:FirstViewframe style:UITableViewStyleGrouped];
	FirstTable.delegate = self;
	FirstTable.dataSource = self;
	FirstTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
	FirstTable.backgroundColor = [UIColor clearColor];
	FirstTable.tag = 1;
	[self.FirstView addSubview:FirstTable];
	
	
	
	// Second View and Children --- don't add to subview yet
	CGRect SecondFrame = CGRectMake(0,40, SCREEN_WIDTH, SCREEN_HEIGHT);
	self.SecondView = [[UIView alloc] initWithFrame:SecondFrame];
	[self.SecondView setBackgroundColor:[UIColor clearColor]];
	QuestionPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,180)];
    CustomDataSource = [[CustomPickerDataSource_Num_Questions alloc] init];
	CGRect SecondTableframe = CGRectMake(0 ,230, SCREEN_WIDTH, 700);
    self.SecondTable = [[UITableView alloc] initWithFrame:SecondTableframe style:UITableViewStyleGrouped];
	//[self.view addSubview:SecondView];
	//[self AddStartButton:2];
	
	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[FirstTable reloadData]; // we need this if not version information will not update after user buys more questions
	[SecondTable reloadData]; // we need this if not the configuration of will not update
    
    if(CustomDataSource != nil){ // this is the refresh the QuestionPicker after user purchase
        
        [CustomDataSource release];
        CustomDataSource = [[CustomPickerDataSource_Num_Questions alloc] init];
        QuestionPickerView.delegate = CustomDataSource;
        QuestionPickerView.dataSource = CustomDataSource;
    }

	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	if ([self.FirstView superview]) {
		
	
	
	if (interfaceOrientation == UIInterfaceOrientationPortrait  || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		FirstView.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
		FirstTable.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
		logoView.frame = CGRectMake(30.0,0.0,710,600);
		
		//Copyright.frame = CGRectMake(250,40,320,40);
		WebText.frame = CGRectMake(300,20,200,20);
		StartPractice.frame = CGRectMake(95, 620, 600, 44);
		
	}
	
	else {
		
		
		FirstView.frame = CGRectMake(0, 0, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
		FirstTable.frame = CGRectMake(0, 0, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
				
		logoView.frame = CGRectMake(120, 0.0, 780, 550);
		
		//Copyright.frame = CGRectMake(400,40,320,40);
		WebText.frame = CGRectMake(400,20,200,20);
		
		StartPractice.frame = CGRectMake(210, 520, 600, 44);
			}
		
}
	else {
		if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			
			self.SecondView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
			self.SecondTable.frame = CGRectMake(0 ,180, SCREEN_WIDTH, 700);
			self.QuestionPickerView.frame = CGRectMake(0,0,SCREEN_WIDTH,180);
			self.Sound.frame =  CGRectMake(620.0, 10.0, 40.0, 45.0);
			self.ShowAnswers.frame = CGRectMake(620.0, 10.0, 40.0, 45.0);
			self.btnStartTest.frame = CGRectMake(45, 0, 680, 44);
		}
		
		else {
			
			self.SecondView.frame = CGRectMake(0,0, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
			self.SecondTable.frame = CGRectMake(0 ,180, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
			self.QuestionPickerView.frame = CGRectMake(0,0,SCREEN_HEIGHT + 80,180);
			self.Sound.frame = CGRectMake(860.0, 10.0, 40.0, 45.0);
			self.ShowAnswers.frame = CGRectMake(860.0, 10.0, 40.0, 45.0);
			self.btnStartTest.frame = CGRectMake(45, 0, 940, 44);
		}

	}


	
	
	
}


/*-(void)CheckOrientation{
	
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
	
	UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
	
	
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
		
		logoView.frame = CGRectMake(200.0,0.0,550,600);
		Copyright.frame = CGRectMake(400,40,320,40);
		WebText.frame = CGRectMake(450,20,200,20);
		
	}
	
}  */

-(IBAction)Practice:(id)sender{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:_TransitionDuration];
	
	[UIView setAnimationTransition:([self.FirstView superview] ?
									UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft)
						   forView:self.view cache:YES];
	if ([self.SecondView superview])
	{
		[self.SecondView removeFromSuperview];
		[self.view addSubview:FirstView];
		self.navigationItem.title  = @"";
		[self PageButton:1];
	}
	else
	{
		
		
		[self.FirstView removeFromSuperview];
		[self.view addSubview:SecondView];
		
		
		
		//QuestionPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		
		QuestionPickerView.delegate = CustomDataSource;
		QuestionPickerView.showsSelectionIndicator = YES;
		[SecondView  addSubview:QuestionPickerView];	
		
		//Add Second Table
		
		SecondTable.delegate = self;
		SecondTable.dataSource = self;
		SecondTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
		SecondTable.tag = 2;
		[self.SecondView addSubview:SecondTable];
		
			
		self.navigationItem.title  = @"Customise";  //@"Search Engine";
		[self PageButton:2];
	}
	
	[UIView commitAnimations];
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
	
	
	
	
}

-(IBAction)StartTest:(id)sender{
	
	NSString *AccessLevel = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessLevel"];
	
	if([AccessLevel intValue] == 1){
		
		NSString *message = [[NSString alloc] initWithFormat:@"You are using the free version of the app. The app will only deliver a maximum of 30 questions depending on your search criteria"];
		
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Important Notice"
													   message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		[message release];
		[alert release];
	}
	
	
	ClientEngine *ce_view = [[ClientEngine alloc] initWithStyle:UITableViewStyleGrouped];
	
	
	[self.navigationController pushViewController:ce_view animated:YES];
	[ce_view release];
	
	
}

- (void)switchAction:(UISwitch*)sender{
	
	if (sender.tag == 1){
	
		[[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"PlaySound"];
	}
	else {
		
		[[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"ShowMyAnswers"];
		
	}

	
	
}

-(void)PageButton:(int)sender{
	
	if (sender==1) {
		
		UIBarButtonItem *Practice = [[UIBarButtonItem alloc] initWithTitle:@"Start Practice Questions Here " style:UIBarButtonItemStyleBordered target:self action:@selector(Practice:)];
		self.navigationItem.rightBarButtonItem = Practice;
		[Practice release];
		self.navigationItem.leftBarButtonItem = nil;
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		BOOL PlaySound = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"];
		if (PlaySound == YES) {
			
			[appDelegate PlaySound:@"ArrowWoodImpact"];
			
		}
		
		
		
		
		
	}else {
		
		UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Practice:)];
		self.navigationItem.leftBarButtonItem = Back;
		[Back release];
		
		
		UIBarButtonItem *StartTest = [[UIBarButtonItem alloc] initWithTitle:@"Start Test Here" style:UIBarButtonItemStylePlain target:self action:@selector(StartTest:)];
		self.navigationItem.rightBarButtonItem = StartTest;
		[StartTest release];
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		BOOL PlaySound = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"];
		if (PlaySound == YES) {
			
			[appDelegate PlaySound:@"ArrowWoodImpact"];
			
		}
		
		
		
		
	}
	
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
	
	
}


#pragma mark -
#pragma mark Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(tableView.tag == 1){
		
	return 2;
	}
	else {
		return 1;
	}

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title=@"";
	
	
	if (section== 0 && tableView.tag == 1) {
		
		NSString *AccessLevel = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessLevel"];
		
		if([AccessLevel intValue] == 1){
		
		title = @"GCSE Chemistry Free Version";
		}
		else if ([AccessLevel intValue] == 2){
			
		title = @"GCSE Chemistry 250 Questions";
			
		}
		else if ([AccessLevel intValue] == 3){
			
			title = @"GCSE Chemistry 500 Questions";
			
		}
		else if ([AccessLevel intValue] == 4){
			
			title = @"GCSE Chemistry 750 Questions";
			
		}
		else if ([AccessLevel intValue] == 5){
			
			title = @"GCSE Chemistry 1000+ Questions";
			
		}
		
		
		
	
	}
	
	else if (tableView.tag == 2 && section == 0){
		title =@"";
		
	}
	
	
	
	return title; 
	
	
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	NSInteger count = 1;
	
	if (tableView.tag == 1){
	
	
	
	}
	
	else {
		count = 6;
	}

	 
	
	return count; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
		if (indexPath.section ==0) {
			return 700;
		}
		else {
			return 90;
		}
	}
	else {
		
		return 40;
	}

	
	




}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	 
	
	if (tableView.tag == 1) {
		
			tableView.allowsSelection = NO;
    
			if (indexPath.section == 0) {
		
					if (logoView == nil) {
						
					
				
					NSString *LogoPath = [[NSBundle mainBundle] pathForResource:@"LearnersCloudLogo" ofType:@"png"];
	
					UIImage *LogoImage = [[UIImage alloc] initWithContentsOfFile:LogoPath];
					logoView = [[UIImageView alloc] initWithImage:LogoImage];
					logoView.frame = CGRectMake(30.0,0.0,710,600);
					
					[cell addSubview:logoView];
					[LogoImage release];
					[logoView release];
					
					StartPractice = [UIButton buttonWithType:UIButtonTypeRoundedRect];
					[StartPractice setTitle:@"Start Practice Questions Here!" forState:UIControlStateNormal];

					StartPractice.frame = CGRectMake(95, 620, 600, 44);
					[StartPractice addTarget:self action:@selector(Practice:) forControlEvents:UIControlEventTouchUpInside];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					[cell addSubview:StartPractice];
					}
					
				}
				else if (indexPath.section == 1) {
		
					 //if (Copyright == nil) {
//						 
//						
//					Copyright = [[UILabel alloc] initWithFrame:CGRectMake(250,40,320,40)];
//					
//					Copyright.font= [UIFont systemFontOfSize:10.0];
//					Copyright.textColor = [UIColor blueColor];
//					Copyright.backgroundColor = [UIColor clearColor];
//					Copyright.text = @"Registered Trademark Owner Theta Computer Services \u00AE 2010";
//					
//					[cell addSubview:Copyright];
//					
//					[Copyright release];
					if (WebText == nil){
		
					WebText = [[UITextView alloc] initWithFrame:CGRectMake(300,20,200,20)];
					WebText.editable = NO;
					WebText.backgroundColor = [UIColor clearColor];
					WebText.dataDetectorTypes = UIDataDetectorTypeLink;
					NSString *Website = @"http://www.LearnersCloud.com";
					
					WebText.text =Website;
					[cell addSubview:WebText];
					
					[WebText release];
					//[self CheckOrientation];
					
					}
				}
		
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			
		
	}
	else {
			
			EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;	
		switch (indexPath.row) {
				case 0:
					//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
					cell.textLabel.text = @"Difficulty";
					cell.detailTextLabel.text = appDelegate.Difficulty;
					break;
				case 1:
					//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
					cell.textLabel.text = @"Topic";
					cell.detailTextLabel.text = appDelegate.Topic;
					break;
					
				case 2:
					//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
					cell.textLabel.text = @"Type of question";
					cell.detailTextLabel.text = appDelegate.TypeOfQuestion;
					break;
				
				case 3:
						
							if (Sound == nil) {
							
								Sound =[[UISwitch alloc] initWithFrame:CGRectMake(620.0, 10.0, 40.0, 45.0)];
								
							}
							
					
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
				    cell.textLabel.text = @"Sound";
				  
				   BOOL PlaySound = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"];
					
					if (PlaySound ==YES) {
					
						Sound.on = YES;
					}
					else {
						Sound.on = NO;
					}
					Sound.tag = 1;
					[Sound addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
					[cell addSubview:Sound];
					break;

				case 4:
					
					if (ShowAnswers == nil) {
						
						ShowAnswers =[[UISwitch alloc] initWithFrame:CGRectMake(620.0, 10.0, 40.0, 45.0)];
						
					}
									
				
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.textLabel.text = @"Show answers";
				
				BOOL ShowMyAnswers = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowMyAnswers"];
				
				if (ShowMyAnswers ==YES) {
					
					ShowAnswers.on = YES;
				}
				else {
					ShowAnswers.on = NO;
				}
				ShowAnswers.tag = 2;
				[ShowAnswers addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
				[cell addSubview:ShowAnswers];
				break;
				
				case 5:
					
					if (btnStartTest == nil) {
						
						
						btnStartTest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
						//btnStartTest.frame = CGRectMake(45, 0, 680, 44);
					}
									
				[btnStartTest setTitle:@"Start Test!" forState:UIControlStateNormal];
				
				[btnStartTest addTarget:self action:@selector(StartTest:) forControlEvents:UIControlEventTouchUpInside];
				[cell addSubview:btnStartTest];
				
				break;
		}
		
		
		
	}

	
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		SelectDifficulty *Difficulty_view = [[SelectDifficulty alloc]initWithNibName:nil bundle:nil];
		Difficulty_view.UserConfigure =  YES;
		[self.navigationController pushViewController:Difficulty_view animated:YES];
		[Difficulty_view release];
		
		
	}
	else if(indexPath.row == 1) {
		
		SelectTopic *Topic_view  =[[SelectTopic alloc] initWithNibName:nil bundle:nil];
		Topic_view.UserConfigure = YES;
		[self.navigationController pushViewController:Topic_view animated:YES];
		[Topic_view release];
		
	}
	
	else if(indexPath.row == 2){
		
		SelectQuestionTemplate *QT_view = [[SelectQuestionTemplate alloc] initWithNibName:nil bundle:nil];
		QT_view.UserConfigure = YES;
		[self.navigationController pushViewController:QT_view animated:YES];
		[QT_view release];
		
	}
	
}



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
		
	
	
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
    [FirstView release];
	[FirstTable release];
	[SecondView release];
	[SecondTable release];
	[QuestionPickerView release];
	[CustomDataSource release];
	[Sound release];
	[ShowAnswers release];
	//[logoView release];
    [super dealloc];
}


@end
