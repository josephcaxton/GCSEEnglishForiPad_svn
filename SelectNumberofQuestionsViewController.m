//
//  SelectNumberofQuestionsViewController.m
//  Maths
//
//  Created by Joseph caxton-Idowu on 10/05/2013.
//  Copyright (c) 2013 caxtonidowu. All rights reserved.
//

#import "SelectNumberofQuestionsViewController.h"

@interface SelectNumberofQuestionsViewController ()

@end

@implementation SelectNumberofQuestionsViewController

@synthesize QuestionsNumbers;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,185,55)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Select number of questions";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    self.navigationItem.titleView = label;
    [label sizeToFit];
       
    [self.tableView setBackgroundView:nil];
    NSString *BackImagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
	UIImage *BackImage = [[UIImage alloc] initWithContentsOfFile:BackImagePath];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:BackImage];
   
    
    UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Back:)];
    self.navigationItem.leftBarButtonItem = Back;
   

}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
    
    [self ConfigureList];
    
}

-(IBAction)Back:(id)sender{
	
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(void)ConfigureList{
    
      
    QuestionsNumbers = [[NSMutableArray alloc]init];
    
    NSString *AccessLevel = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessLevel"];
    
     if([AccessLevel intValue] == 1){
         
         NSArray *one = [[NSArray alloc]initWithObjects:@"10",@"20", nil];
         [QuestionsNumbers addObjectsFromArray:one];
     }
     else if([AccessLevel intValue] == 2){
          NSArray *two = [[NSArray alloc] initWithObjects:@"10",@"20",@"50",@"100",@"250",nil];
         [QuestionsNumbers addObjectsFromArray:two];

     }
     else if([AccessLevel intValue] == 3){
         
          NSArray *three = [[NSArray alloc] initWithObjects:@"10",@"20",@"50",@"100",@"250",@"500",nil];
         [QuestionsNumbers addObjectsFromArray:three];
         
     }

     else if([AccessLevel intValue] == 4){
         NSArray *four = [[NSArray alloc] initWithObjects:@"10",@"20",@"50",@"100",@"250",@"500",@"750",nil];
         [QuestionsNumbers addObjectsFromArray:four];
     }

     else if([AccessLevel intValue] == 5){
         NSArray *five = [[NSArray alloc] initWithObjects:@"10",@"20",@"50",@"100",@"250",@"500",@"1000",nil];
        [QuestionsNumbers addObjectsFromArray:five];
     }

     else if([AccessLevel intValue] == 6){
         NSArray *six = [[NSArray alloc] initWithObjects:@"10",@"20",@"50",@"100",@"250",@"500",@"1250",nil];

         [QuestionsNumbers addObjectsFromArray:six];
         
     }

     else if([AccessLevel intValue] == 7){
          NSArray *seven = [[NSArray alloc] initWithObjects:@"10",@"20",@"50",@"100",@"250",@"500",@"1500",nil];
        [QuestionsNumbers addObjectsFromArray:seven];
     }
     else if([AccessLevel intValue] == 8){
          NSArray *eight = [[NSArray alloc] initWithObjects:@"10",@"20",@"50",@"100",@"250",@"500",@"1600",nil];
         [QuestionsNumbers addObjectsFromArray:eight];
     }

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return QuestionsNumbers.count;

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
    }
    
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	
    int NoofQuestions = appDelegate.NumberOfQuestions.intValue;
    
            NSString *_Number = [QuestionsNumbers objectAtIndex:indexPath.row];
			cell.textLabel.text = _Number;
			
			if (NoofQuestions == _Number.intValue) {
				
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				
				cell.accessoryType =UITableViewCellAccessoryNone;
				
			}
    // Last object in collection is ALL
    if(indexPath.row + 1 == QuestionsNumbers.count){
        
       cell.detailTextLabel.text = @"ALL";
    }
			
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *Allcells = [tableView visibleCells];
	for (UITableViewCell *cell in Allcells){
		cell.accessoryType = UITableViewCellAccessoryNone;
		
	}
	
	UITableViewCell *SelectedCell = [tableView cellForRowAtIndexPath:indexPath];
	SelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
    
	NSInteger num = [[QuestionsNumbers objectAtIndex:indexPath.row] integerValue];
	
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
    
	appDelegate.NumberOfQuestions = [NSNumber numberWithInteger:num];
    
    //NSLog(@"Here %i",[appDelegate.NumberOfQuestions integerValue]);
	
	[self.navigationController popViewControllerAnimated:YES];
    
	
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
