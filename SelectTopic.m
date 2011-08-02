//
//  SelectTopic.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 03/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "SelectTopic.h"
#import "EvaluatorAppDelegate.h"


@implementation SelectTopic

@synthesize  SelectedTopic,SelectedTemplate,UserConfigure;
@synthesize managedObjectContext, fetchedResultsController;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	//UIBarButtonItem *BackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
	//self.navigationItem.leftBarButtonItem = BackButton;
	//[BackButton release];
	
	self.navigationItem.title = @"Topics";
	
	if (UserConfigure) {
		
		UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Back:)];
		self.navigationItem.leftBarButtonItem = Back;
		[Back release];
	}
	
    	
}

-(IBAction)Back:(id)sender{
	
	[self.navigationController popViewControllerAnimated:YES];
	
}


-(void)viewWillAppear:(BOOL)animated{
	
	self.fetchedResultsController = nil;
	self.managedObjectContext = [self ManagedObjectContext];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On Topics table" 
															message: @"Error getting data from Topics Table contact support" delegate: self 
												  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[DataError show];
		
		[DataError release];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		
	}
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	NSInteger count = [[fetchedResultsController sections] count];
	
	if (count == 0) {
		count = 1;
	}
	
    return count;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title = @"Topics";
	
	return title; 
	
	
	
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger numberOfRows = 0;
	
	if (UserConfigure) {
		
		numberOfRows = [[fetchedResultsController fetchedObjects]count] + 1;
	}
	else{
		
	numberOfRows = [[fetchedResultsController fetchedObjects]count];
	
	}
	return numberOfRows;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if (indexPath.row > [[fetchedResultsController fetchedObjects]count] -1) {
		
		cell.textLabel.text = @"All";
		
		if ([appDelegate.Topic  isEqualToString:@"All" ]) {
			
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else {
			
			cell.accessoryType =UITableViewCellAccessoryNone;
			
		}
		
	}
	else{
		
		
	Topics *T = (Topics *)[fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = T.TopicName;
		
		if ([appDelegate.Topic  isEqualToString:T.TopicName ]) {
			
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else {
			
			cell.accessoryType =UITableViewCellAccessoryNone;
			
			}
		
	
		}
		
	
    return cell;
	
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Topics" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"TopicName" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root_topics"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	
	return fetchedResultsController;
}    


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if (UserConfigure) {
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		if (indexPath.row > [[fetchedResultsController fetchedObjects]count] -1) {
			appDelegate.Topic = @"All";
			[self.navigationController popViewControllerAnimated:TRUE];
		}
		else {
			SelectedTopic = (Topics *)[fetchedResultsController objectAtIndexPath:indexPath];
			appDelegate.Topic = SelectedTopic.TopicName;
			[self.navigationController popViewControllerAnimated:TRUE];
		}
		
	}
	
	
	else{
		
		SelectedTopic = (Topics *)[fetchedResultsController objectAtIndexPath:indexPath];
		
		NSString *message = [[NSString alloc] initWithFormat:@"Do you want to create a %@ question for topic: %@?", SelectedTemplate.Description, SelectedTopic.TopicName];
		
		UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:
									 message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
		
		[actionSheet showInView:self.tabBarController.view];
		[message release];
		[actionSheet release];
		
	}
	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
	
	
	
	
	
	
	
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
	
	if (buttonIndex != [actionSheet cancelButtonIndex]){
		
		NSString *str = SelectedTemplate.Description; 
		
		if ([str isEqualToString:@"Multiple Choice Single Answer"]) {
			
			MultipleChoiceSingleAnswer *M_view = [[MultipleChoiceSingleAnswer alloc] initWithNibName:nil bundle:nil];
			
			M_view.QuestionTemplate = SelectedTemplate;
			M_view.SelectedTopic = SelectedTopic;
			
			
			
			[self.navigationController pushViewController:M_view animated:YES];
			
			
			[M_view release]; 
			
			
		}
		else if([str isEqualToString:@"Multiple Choice Multiple Answer"])
		{
			MultipleChoiceSingleAnswer *M_view = [[MultipleChoiceSingleAnswer alloc] initWithNibName:nil bundle:nil];
			
			M_view.QuestionTemplate = SelectedTemplate;
			M_view.SelectedTopic = SelectedTopic;
			
			
			
			[self.navigationController pushViewController:M_view animated:YES];
			
			[M_view release];
		}
		
		else if ([str isEqualToString:@"True or False"])
			
		{
			TrueOrFalseYesOrNo *T_view = [[TrueOrFalseYesOrNo alloc] initWithNibName:nil bundle:nil];
			
			T_view.QuestionTemplate = SelectedTemplate;
			T_view.SelectedTopic = SelectedTopic;
			
			
			
			[self.navigationController pushViewController:T_view animated:YES];
			
			[T_view release];
			
			
			
		}
		
		else if ([str isEqualToString:@"Yes or No"])
		{
			
			TrueOrFalseYesOrNo *T_view = [[TrueOrFalseYesOrNo alloc] initWithNibName:nil bundle:nil];
			
			T_view.QuestionTemplate = SelectedTemplate;
			T_view.SelectedTopic = SelectedTopic;
			
			
			
			[self.navigationController pushViewController:T_view animated:YES];
			
			[T_view release];
			
			
		}
		else if ([str isEqualToString:@"Descriptive Type"])
		{
			DescriptiveType *D_view = [[DescriptiveType alloc] initWithNibName:nil bundle:nil];
			
			D_view.QuestionTemplate = SelectedTemplate;
			D_view.SelectedTopic = SelectedTopic;
			
			
			
			[self.navigationController pushViewController:D_view animated:YES];
			
			[D_view release];
			
			
		}
		else if ([str isEqualToString:@"Fill the Blanks"])
		{
			FillTheBlanks *F_view = [[FillTheBlanks alloc] initWithNibName:nil bundle:nil];
			
			F_view.QuestionTemplate = SelectedTemplate;
			F_view.SelectedTopic = SelectedTopic;
			
			
			
			[self.navigationController pushViewController:F_view animated:YES];
			
			[F_view release];
			
		}
		
		
	}
	
	else {
		
	}


	
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
	

}


- (void)dealloc {
	
	//[fetchedResultsController release];
	[managedObjectContext release];
	
    [super dealloc];
}


@end

