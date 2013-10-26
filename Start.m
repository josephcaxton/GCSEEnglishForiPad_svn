//
//  Start.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 31/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "Start.h"
#import "TransparentToolBar.h"


@implementation Start

@synthesize FirstView, SecondView,FirstTable,SecondTable,Sound,ShowAnswers,logoView,Copyright,WebText,StartPractice,btnStartTest,Instruction,popover,TVHeaderImageView,DifficultybtnLock,TopicbtnLock,TypeofquestionbtnLock;


#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950
#define _TransitionDuration	0.45

- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    self.navigationItem.title = @"LearnersCloud";
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,185,55)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.navigationItem.title;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    self.navigationItem.titleView = label;
    [label sizeToFit];
  
    

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
    FirstTable.opaque = NO;
    FirstTable.backgroundView = nil;
    NSString *BackImagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
	UIImage *BackImage = [[UIImage alloc] initWithContentsOfFile:BackImagePath];
    FirstTable.backgroundColor = [UIColor colorWithPatternImage:BackImage];
	FirstTable.tag = 1;
	[self.FirstView addSubview:FirstTable];
	
	
	
	// Second View and Children --- don't add to subview yet
	CGRect SecondFrame = CGRectMake(0,40, SCREEN_WIDTH, SCREEN_HEIGHT);
	self.SecondView = [[UIView alloc] initWithFrame:SecondFrame];
    self.SecondView.backgroundColor = [UIColor colorWithPatternImage:BackImage];
	//QuestionPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,180)];
    //CustomDataSource = [[CustomPickerDataSource_Num_Questions alloc] init];
	CGRect SecondTableframe = CGRectMake(0 ,0, SCREEN_WIDTH, 700);
    self.SecondTable = [[UITableView alloc] initWithFrame:SecondTableframe style:UITableViewStyleGrouped];
    
    self.SecondTable.backgroundColor = [UIColor clearColor];
    self.SecondTable.opaque = NO;

	//[self.view addSubview:SecondView];
	//[self AddStartButton:2];
	
   
	
    NSString *HeaderLocation = [[NSBundle mainBundle] pathForResource:@"header_bar" ofType:@"png"];
    UIImage *HeaderBackImage = [[UIImage alloc] initWithContentsOfFile:HeaderLocation];
    [self.navigationController.navigationBar setBackgroundImage:HeaderBackImage forBarMetrics:UIBarMetricsDefault];
    

	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[FirstTable reloadData]; // we need this if not version information will not update after user buys more questions
	[SecondTable reloadData]; // we need this if not the configuration of will not update
    
   /* if(CustomDataSource != nil){ // this is the refresh the QuestionPicker after user purchase
        
        [CustomDataSource release];
        CustomDataSource = [[CustomPickerDataSource_Num_Questions alloc] init];
        QuestionPickerView.delegate = CustomDataSource;
        QuestionPickerView.dataSource = CustomDataSource;
        EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.NumberOfQuestions == [NSNumber numberWithInt:1]) {
            appDelegate.NumberOfQuestions =[NSNumber numberWithInt:1];
            [QuestionPickerView selectRow:0 inComponent:1 animated:YES];  // sets the default on the PickerView to 10
        }
        else
        {
            int NumberofQ = appDelegate.NumberOfQuestions.intValue - 1;
            [QuestionPickerView selectRow:NumberofQ inComponent:1 animated:YES];
            
        }
        
    
    }*/
    
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
    
    // Lets ask for review after user has viewed videos 5 times
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *ReviewID = [prefs stringForKey:@"Review"];
    NSString *IhaveReviewed = [prefs stringForKey:@"IHaveLeftReview"];
	NSString *MyAccessLevel = [prefs stringForKey:@"AccessLevel"];
    NSInteger AccessLevel = [MyAccessLevel intValue];
    // Note we only want those who have brought to review. Those looking for free talk non-sense.  AccessLevel > 1
    if ([ReviewID isEqualToString:@"10"] && [IhaveReviewed isEqualToString:@"0"] &&  AccessLevel > 1 ) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Review this app" message:@"Do you like this app enough to leave us a review?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
      
        
	}
    else {
        
        NSInteger Counter = [ReviewID integerValue];
        NSInteger CounterPlus = Counter + 1;
        NSString *ID = [NSString stringWithFormat:@"%d",CounterPlus];
        [prefs setObject:ID  forKey:@"Review"];
        [prefs synchronize];
        
    }
    

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	if ([self.FirstView superview]) {
		
        
        
        if (interfaceOrientation == UIInterfaceOrientationPortrait  || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            
            FirstView.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
            FirstTable.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
            logoView.frame = CGRectMake(140.0,195.0,515,347);
            //Copyright.frame = CGRectMake(250,40,320,40);
            WebText.frame = CGRectMake(280,720,290,40);
            StartPractice.frame = CGRectMake(95, 620, 600, 62);
            TVHeaderImageView.frame = CGRectMake(210, 0.0, 360, 178);
            
        }
        
        else {
            
            
            FirstView.frame = CGRectMake(0, 0, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
            FirstTable.frame = CGRectMake(0, 0, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
            
            logoView.frame = CGRectMake(270, 125.0, 515, 347);
            
            //Copyright.frame = CGRectMake(400,40,320,40);
            WebText.frame = CGRectMake(400,550,290,40);
            
            StartPractice.frame = CGRectMake(220, 490, 600, 62);
            TVHeaderImageView.frame = CGRectMake(340, 0.0, 360, 128);
        }
		
    }
	else {
        
        if(popover){
            
            [popover dismissPopoverAnimated:YES];
            [popover.delegate popoverControllerDidDismissPopover:self.popover];
            
        }
        
		if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			
			self.SecondView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
			self.SecondTable.frame = CGRectMake(0 ,0, SCREEN_WIDTH, 700);
            btnStartTest.center = CGPointMake(self.SecondTable.center.x, 25);
			//self.QuestionPickerView.frame = CGRectMake(0,0,SCREEN_WIDTH,180);
			//self.Sound.frame =  CGRectMake(640.0, 5.0, 40.0, 45.0);
			//self.ShowAnswers.frame = CGRectMake(595.0, 5.0, 40.0, 45.0);
			//self.btnStartTest.frame = CGRectMake(265, 12.5, 156, 45);
            //DifficultybtnLock.frame = CGRectMake(680, 2, 36, 35);
            //TopicbtnLock.frame = CGRectMake(680, 2, 36, 35);
            //TypeofquestionbtnLock.frame = CGRectMake(680, 2, 36, 35);
		}
		
		else {
			
			self.SecondView.frame = CGRectMake(0,0, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
			self.SecondTable.frame = CGRectMake(0 ,0, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
            btnStartTest.center = CGPointMake(self.SecondTable.center.x, 45);
			//self.QuestionPickerView.frame = CGRectMake(0,0,SCREEN_HEIGHT + 80,180);
			//self.Sound.frame = CGRectMake(900.0, 5.0, 40.0, 45.0);
			//self.ShowAnswers.frame = CGRectMake(855.0, 5.0, 40.0, 45.0);
			//self.btnStartTest.frame = CGRectMake(400, 12.5, 156, 45);
            //DifficultybtnLock.frame = CGRectMake(950, 2, 35, 35);
            //TopicbtnLock.frame = CGRectMake(950, 2, 35, 35);
            //TypeofquestionbtnLock.frame = CGRectMake(950, 2, 35, 35);

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
		NSString *AccessLevel = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessLevel"];
        
        if([AccessLevel intValue] == 1){
            
            NSString *message = [[NSString alloc] initWithFormat:@"You are using the free version of this app. To unlock all question filters and get unlimited access to over 1000 exam-standard questions, buy in-app today."];
            
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Welcome to LearnersCloud"
                                                           message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
        }
        

		
		[self.FirstView removeFromSuperview];
		[self.view addSubview:SecondView];
		
		
		
		//QuestionPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		/*if(CustomDataSource != nil){
            
            [CustomDataSource release];
            CustomDataSource = [[CustomPickerDataSource_Num_Questions alloc] init];
            QuestionPickerView.dataSource = CustomDataSource;
        }
        

		
		QuestionPickerView.delegate = CustomDataSource;
		QuestionPickerView.showsSelectionIndicator = YES;
		[SecondView  addSubview:QuestionPickerView];	*/
		
		//Add Second Table
		
		SecondTable.delegate = self;
		SecondTable.dataSource = self;
		//SecondTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
		SecondTable.tag = 2;
		[self.SecondView addSubview:SecondTable];
		
			
		self.navigationItem.title  = @"Customise";  //@"Search Engine";
		[self PageButton:2];
	}
	
	[UIView commitAnimations];
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
	
	
	
	
}

-(IBAction)StartTest:(id)sender{
	
	
	ClientEngine *ce_view = [[ClientEngine alloc] initWithStyle:UITableViewStyleGrouped];
	
	
	[self.navigationController pushViewController:ce_view animated:YES];
		
	
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
        
        self.navigationItem.leftBarButtonItem = nil;
         self.navigationItem.rightBarButtonItem = nil;
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		BOOL PlaySound = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"];
		if (PlaySound == YES) {
			
			[appDelegate PlaySound:@"ArrowWoodImpact"];
			
		}
		
		
		
		
		
	}else {
		
        
        // create a toolbar where we can place some buttons
        TransparentToolBar* toolbar = [[TransparentToolBar alloc]
                                       initWithFrame:CGRectMake(0, 0, 170, 45)];
        
        
        
        // create an array for the buttons
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
        
        // Create Share button
        
        UIButton *Sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [Sharebtn setBackgroundImage:[UIImage imageNamed:@"share40.png"] forState:UIControlStateNormal];
        [Sharebtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        Sharebtn.frame=CGRectMake(0.0, 0.0, 61.0, 40.0);
        UIBarButtonItem *ShareButton = [[UIBarButtonItem alloc] initWithCustomView:Sharebtn];
        

        
        [buttons addObject:ShareButton];
        
        
        // create a spacer between the buttons
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil
                                   action:nil];
        [buttons addObject:spacer];
        
        
        //Start button
        UIButton *Startbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [Startbtn setBackgroundImage:[UIImage imageNamed:@"start_test40.png"] forState:UIControlStateNormal];
        [Startbtn addTarget:self action:@selector(StartTest:) forControlEvents:UIControlEventTouchUpInside];
        Startbtn.frame=CGRectMake(0.0, 0.0, 86.0, 40.0);
        UIBarButtonItem *StartTest = [[UIBarButtonItem alloc] initWithCustomView:Startbtn];
        
        [buttons addObject:StartTest ];
        
        
        
        
        
        [toolbar setItems:buttons animated:NO];
        
        // place the toolbar into the navigation bar
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithCustomView:toolbar];
        
     
        
        //_____
		
        UIButton *Startback = [UIButton buttonWithType:UIButtonTypeCustom];
        [Startback setBackgroundImage:[UIImage imageNamed:@"back_arrow40.png"] forState:UIControlStateNormal];
        [Startback addTarget:self action:@selector(Practice:) forControlEvents:UIControlEventTouchUpInside];
        Startback.frame=CGRectMake(0.0, 0.0, 64.0, 40.0);
        UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithCustomView:Startback];
		self.navigationItem.leftBarButtonItem = Back;
		
		
		
		
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
		
	return 1;
	}
	else {
		return 1;
	}

}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title=@"";
	
	
	if (section== 0 && tableView.tag == 1) {
		
		NSString *AccessLevel = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessLevel"];
		
		if([AccessLevel intValue] == 1){
		
		title = @"GCSE English Free Version";
		}
		else if ([AccessLevel intValue] == 2){
			
		title = @"GCSE English 250 Questions";
			
		}
		else if ([AccessLevel intValue] == 3){
			
			title = @"GCSE English 500 Questions";
			
		}
		else if ([AccessLevel intValue] == 4){
			
			title = @"GCSE English 750 Questions";
			
		}
		else if ([AccessLevel intValue] == 5){
			
			title = @"GCSE English 1000+ Questions";
			
		}
		
		
		
	
	}
	
	else if (tableView.tag == 2 && section == 0){
		title =@"";
		
	}
	
	
	
	return title; 
	
	
	
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	NSInteger count = 1;
	
	if (tableView.tag == 1){
	
	
	
	}
	
	else {
		count = 8;
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
	else if(tableView.tag == 2){
        if(indexPath.row == 7){
            return 70;
        }
        return 40;
    }
    else{
        
		return 40;
        
	}

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
	 
	
	if (tableView.tag == 1) {
		
        tableView.allowsSelection = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.separatorColor = [UIColor clearColor];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        if (TVHeaderImageView == nil) {
            UIView *headerView = [[UIView alloc] init];
            
            NSString *HeaderImagePath = [[NSBundle mainBundle] pathForResource:@"EQ_english_header" ofType:@"png"];
            UIImage *HeaderImage = [[UIImage alloc] initWithContentsOfFile:HeaderImagePath];
            TVHeaderImageView = [[UIImageView alloc] initWithImage:HeaderImage];
            TVHeaderImageView.frame = CGRectMake(210, 0.0, 360, 178);
            TVHeaderImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [headerView addSubview:TVHeaderImageView];
            [cell addSubview:headerView];
          
          
            
        }
        
		
        if (logoView == nil) {
            
            
            
            NSString *LogoPath = [[NSBundle mainBundle] pathForResource:@"hero" ofType:@"png"];
            
            UIImage *LogoImage = [[UIImage alloc] initWithContentsOfFile:LogoPath];
            logoView = [[UIImageView alloc] initWithImage:LogoImage];
            logoView.frame = CGRectMake(140.0,195.0,515,347);
            
            [cell addSubview:logoView];
          
        
            
            NSString *StartImageLocation = [[NSBundle mainBundle] pathForResource:@"start_practice_questions" ofType:@"png"];
            
            UIImage *StartImage = [[UIImage alloc] initWithContentsOfFile:StartImageLocation];
            
            
            StartPractice = [UIButton buttonWithType:UIButtonTypeCustom];
            [StartPractice setImage:StartImage forState:UIControlStateNormal];
            
            StartPractice.frame = CGRectMake(95, 620, 600, 62);
            [StartPractice addTarget:self action:@selector(Practice:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:StartPractice];
        }
        
        //}
        //else if (indexPath.section == 1) {
		
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
            
            WebText = [[UITextView alloc] initWithFrame:CGRectMake(280,70,290,40)];
            WebText.textColor = [UIColor whiteColor];
            WebText.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
            WebText.backgroundColor =[UIColor clearColor];
            WebText.editable = NO;
            NSString *Website = @"www.LearnersCloud.com";
            WebText.text = Website;
            [cell addSubview:WebText];
            
            
            //[self CheckOrientation];
            
        }
        //}
		
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
		
	}
	else {
        [tableView setBackgroundView:nil];
        [cell setBackgroundColor:[UIColor whiteColor]];
        EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
         NSString *MyAccessLevel = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessLevel"];
		switch (indexPath.row) {
                
            case 0:
            {
                
                //NSString *textval = [NSString stringWithFormat:@"%d", [appDelegate.NumberOfQuestions integerValue]];
                //cell.detailTextLabel.text = textval;
                cell.textLabel.text = @"Number of questions";
                cell.detailTextLabel.text = [appDelegate.NumberOfQuestions stringValue];
                
                break;
            }

            case 1:
            {
                if ([MyAccessLevel intValue] <= 2){
                    
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.enabled = NO;
                    cell.textLabel.text = @"Difficulty";
                    
                    
                    UIImage *imgLock = [UIImage imageNamed:@"Padlock.png"];
                    DifficultybtnLock = [UIButton buttonWithType:UIButtonTypeCustom];
                    DifficultybtnLock.frame = CGRectMake(0, 2, 36, 35);
                    [DifficultybtnLock setBackgroundImage:imgLock forState:UIControlStateNormal];
                    cell.accessoryView = DifficultybtnLock;
                    //[cell addSubview:DifficultybtnLock ];
                }
                else{
                    
                    [DifficultybtnLock removeFromSuperview];
                    
                    cell.userInteractionEnabled = YES;
                    cell.textLabel.enabled = YES;

                    cell.textLabel.text = @"Difficulty";
                    cell.detailTextLabel.text = appDelegate.Difficulty;
                }
                break;
            }
            case 2:
            {
                if ([MyAccessLevel intValue] <= 2){
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.enabled = NO;
                    cell.textLabel.text = @"Topic";
                    
                    UIImage *imgLock = [UIImage imageNamed:@"Padlock.png"];
                    TopicbtnLock = [UIButton buttonWithType:UIButtonTypeCustom];
                    TopicbtnLock.frame = CGRectMake(0, 2, 36, 35);
                    [TopicbtnLock setBackgroundImage:imgLock forState:UIControlStateNormal];
                    cell.accessoryView = TopicbtnLock;
                    //[cell addSubview:TopicbtnLock ];
                    

                    
                }
                else{
                    
                    [TopicbtnLock removeFromSuperview];
                    
                    cell.userInteractionEnabled = YES;
                    cell.textLabel.enabled = YES;

                    cell.textLabel.text = @"Topic";
                    cell.detailTextLabel.text = appDelegate.Topic;
                }
                 break;
            
            }
                
            case 3:
            {
                if ([MyAccessLevel intValue] <= 2){
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.enabled = NO;
                    cell.textLabel.text = @"Type of question";
                    
                    UIImage *imgLock = [UIImage imageNamed:@"Padlock.png"];
                    TypeofquestionbtnLock = [UIButton buttonWithType:UIButtonTypeCustom];
                    TypeofquestionbtnLock.frame = CGRectMake(0, 2, 36, 35);
                    [TypeofquestionbtnLock setBackgroundImage:imgLock forState:UIControlStateNormal];
                    cell.accessoryView =TypeofquestionbtnLock;
                    //[cell addSubview:TypeofquestionbtnLock ];
                    
                    
                }
                else {
                    
                    [TypeofquestionbtnLock removeFromSuperview];
                    
                    
                    cell.userInteractionEnabled = YES;
                    cell.textLabel.enabled = YES;
                    cell.textLabel.text = @"Type of question";
                    cell.detailTextLabel.text = appDelegate.TypeOfQuestion;
                }
                break;
            }
				
            case 4:
            {
                
                if (Sound == nil) {
                    
                    Sound =[[UISwitch alloc] initWithFrame:CGRectMake(0, 5.0, 40.0, 45.0)];
                    
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
                cell.accessoryView = Sound;
                //[cell addSubview:Sound];
                break;
            }
                
            case 5:
            {
                
                if (ShowAnswers == nil) {
                    
                    ShowAnswers =[[UISwitch alloc] initWithFrame:CGRectMake(0, 5.0, 40.0, 45.0)];
                    
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
                cell.accessoryView =ShowAnswers;
				//[cell.contentView addSubview:ShowAnswers];
				break;
            }
                
            case 6:
            {
                
                if(Instruction == nil){
                    
                    Instruction = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 600, 20)];
                    
                }
                Instruction.font = [UIFont boldSystemFontOfSize: 12.0];
                Instruction.textColor = [UIColor purpleColor];
                Instruction.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
                Instruction.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview: Instruction];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                Instruction.text = @"Please note: Some questions are best viewed in portrait mode due to limited space on your iPad.";
                
                
                break;
            }
				
            case 7:
            {
                UIImage *StartImage = [UIImage imageNamed:@"btn_start_test.png"];
                if (btnStartTest == nil) {
                    
                    
                    btnStartTest = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    [btnStartTest setBackgroundImage:StartImage forState:UIControlStateNormal];
                    
                    
                    //btnStartTest.frame = CGRectMake(45, 0, 680, 44);
                }
                
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[btnStartTest addTarget:self action:@selector(StartTest:) forControlEvents:UIControlEventTouchUpInside];
                btnStartTest.frame = CGRectMake((tableView.bounds.size.width/2) - (StartImage.size.width/2), cell.contentView.center.y, 156, 45);
				[cell.contentView addSubview:btnStartTest];
				
				break;
            }
		}
		
		
		
	}
    
	
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.row == 0) {
        
        SelectNumberofQuestionsViewController *noofquestions =[[SelectNumberofQuestionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:noofquestions animated:YES];
		
    }

	else if (indexPath.row == 1) {
		SelectDifficulty *Difficulty_view = [[SelectDifficulty alloc] initWithStyle:UITableViewStyleGrouped];
		Difficulty_view.UserConfigure =  YES;
		[self.navigationController pushViewController:Difficulty_view animated:YES];
		
		
		
	}
	else if(indexPath.row == 2) {
		
		SelectTopic *Topic_view  =[[SelectTopic alloc] initWithStyle:UITableViewStyleGrouped];
		Topic_view.UserConfigure = YES;
		[self.navigationController pushViewController:Topic_view animated:YES];
		
		
	}
	
	else if(indexPath.row == 3){
		
		SelectQuestionTemplate *QT_view = [[SelectQuestionTemplate alloc] initWithStyle:UITableViewStyleGrouped];
        QT_view.UserConfigure = YES;
		[self.navigationController pushViewController:QT_view animated:YES];
		
		
	}
	
}



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
		
	
	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1){
        
        [self reviewPressed];
        
    }
    else {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *ReviewID = [prefs stringForKey:@"Review"];
        NSInteger Counter = [ReviewID integerValue];
        NSInteger CounterPlus = Counter + 1;
        NSString *ID = [NSString stringWithFormat:@"%d",CounterPlus];
        [prefs setObject:ID  forKey:@"Review"];
        [prefs synchronize];
        
    }

    
}

- (void)reviewPressed {
    
    //Set user has reviewed.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *ID = @"1";
    [prefs setObject:ID forKey:@"IHaveLeftReview"];
    
    [prefs synchronize];
    
    // Report to  analytics
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"User Sent to Review English Questions iPad at app store"
                                         action:@"User Sent to Review English Questions iPad at app store"
                                          label:@"User Sent to Review English Questions iPad at app store"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
    
    
    NSString *str = @"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=454173809&type=Purple+Software"; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)share:(id)sender{
     UIButton *button = (UIButton*)sender;
    
    PopUpTableviewViewController *tableViewController = [[PopUpTableviewViewController alloc] initWithStyle:UITableViewStylePlain];
    
    
    popover = [[UIPopoverController alloc] initWithContentViewController:tableViewController];
    tableViewController.m_popover = popover;
    tableViewController.StartPage = self;
    [popover setPopoverContentSize:CGSizeMake(420, 380) animated:YES];
    
    [popover presentPopoverFromRect:CGRectMake(button.frame.size.width / 2, button.frame.size.height / 1, 1, 1) inView:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
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




@end
