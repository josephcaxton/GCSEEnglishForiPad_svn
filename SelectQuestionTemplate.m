//
//  SelectQuestionTemplate.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 01/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "SelectQuestionTemplate.h"
#import "EvaluatorAppDelegate.h"
#import "SelectTopic.h"

@implementation SelectQuestionTemplate

@synthesize  SelectedTemplate,UserConfigure;
@synthesize managedObjectContext, fetchedResultsController;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
		
   self.navigationItem.title = @"Type of Question";
	
	if (UserConfigure) {
		
		UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Back:)];
		self.navigationItem.leftBarButtonItem = Back;
		[Back release];
	}
	
	
}

-(void)viewWillAppear:(BOOL)animated{
	
	self.fetchedResultsController = nil;
	self.managedObjectContext = [self ManagedObjectContext];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On Template table" 
															   message: @"Error getting data from QuestionTemplate Table contact support" delegate: self 
													 cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[DataError show];
		
		[DataError release];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		
		
	}
	
		
}

-(IBAction)Back:(id)sender{
	
	[self.navigationController popViewControllerAnimated:YES];
	
	
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
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
     
	if (UserConfigure) {
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		 if (indexPath.row > [[fetchedResultsController fetchedObjects]count] -1) {
			 
			 cell.textLabel.text = @"All";
			 
			 if ([appDelegate.TypeOfQuestion  isEqualToString:@"All" ]) {
				 
				 cell.accessoryType = UITableViewCellAccessoryCheckmark;
			 }
			 else {
				 
				 cell.accessoryType =UITableViewCellAccessoryNone;
				 
			 }
			 
			 
			 
		 }
		 else{
			 
			 
			 lk_QuestionTemplate *QT = (lk_QuestionTemplate *)[fetchedResultsController objectAtIndexPath:indexPath];
			 cell.textLabel.text = QT.Description;
			 if ([QT.Description isEqualToString:@"Descriptive Type"]) {
				 cell.detailTextLabel.text =@"(Do not count in overall marks)";
			 }
			 
			 
			 if ([appDelegate.TypeOfQuestion  isEqualToString:QT.Description ]) {
				 
				 cell.accessoryType = UITableViewCellAccessoryCheckmark;
			 }
			 else {
				 
				 cell.accessoryType =UITableViewCellAccessoryNone;
				 
			 }
			 
		 }
		 
	}
	
	else{
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		lk_QuestionTemplate *QT = (lk_QuestionTemplate *)[fetchedResultsController objectAtIndexPath:indexPath];
		cell.textLabel.text = QT.Description; 
	}
	
    
	
    return cell;
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
		self.fetchedResultsController = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	
	return fetchedResultsController;
}    





// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}





#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (UserConfigure) {
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		if (indexPath.row > [[fetchedResultsController fetchedObjects]count] -1) {
			appDelegate.TypeOfQuestion = @"All";
			
			[self.navigationController popViewControllerAnimated:YES];
		}
		else {
			SelectedTemplate = (lk_QuestionTemplate *)[fetchedResultsController objectAtIndexPath:indexPath];
			appDelegate.TypeOfQuestion = SelectedTemplate.Description;
			
			[self.navigationController popViewControllerAnimated:YES];
		}

	}
	
	else {
		
	
	SelectedTemplate = (lk_QuestionTemplate *)[fetchedResultsController objectAtIndexPath:indexPath];
	SelectTopic	*S_view = [[SelectTopic alloc] initWithStyle:UITableViewStyleGrouped];
	S_view.SelectedTemplate = SelectedTemplate;
	
	//[self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];
	
	[self.navigationController pushViewController:S_view animated:YES];
	[S_view release];  
	
	
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
	//[SelectedTemplate release];
    [super dealloc];
}


@end

