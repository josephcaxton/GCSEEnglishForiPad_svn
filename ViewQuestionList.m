//
//  ViewQuestionList.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 19/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "ViewQuestionList.h"
#import "QuestionItems.h"
#import "lk_QuestionTemplate.h"
#import "EvaluatorAppDelegate.h"
#import "MultipleChoiceSingleAnswer.h"
#import "DescriptiveType.h"
#import "TrueOrFalseYesOrNo.h"
#import	"FillTheBlanks.h"


@implementation ViewQuestionList

@synthesize managedObjectContext, fetchedResultsController;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Questions";
}



- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
	
	self.fetchedResultsController = nil;
	self.managedObjectContext = [self ManagedObjectContext];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On QuestionItems" 
															message: @"Error getting data from QuestionItems Table contact support" delegate: self 
												  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[DataError show];
		
		[DataError release];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		
		
	}
	
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
	
	numberOfRows = [[fetchedResultsController fetchedObjects]count];
	
	return numberOfRows;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    QuestionItems *QI = (QuestionItems *)[fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = QI.Question; 
	switch ([QI.Difficulty intValue]) {
		case 1:
			cell.detailTextLabel.text =@"Foundation";
			break;
		case 0:
			cell.detailTextLabel.text =@"Foundation & Higher";
			break;
		case 3:
			cell.detailTextLabel.text =@"Higher";
			break;


		default:
			break;
	} 
	
    return cell;
}



// Override to support conditional editing of the table view.
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
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuestionItems" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Question" ascending:YES];
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



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	QuestionItems *SelectedItem = (QuestionItems *)[fetchedResultsController objectAtIndexPath:indexPath];
	NSString *TemplateType = [NSString stringWithFormat:@"%@", [SelectedItem.QuestionHeader1.QuestionTemplate valueForKey:@"Description"]];
	
	if ([TemplateType isEqualToString:@"Multiple Choice Single Answer"] ) {
		
		MultipleChoiceSingleAnswer *M_view = [[MultipleChoiceSingleAnswer alloc] initWithNibName:nil bundle:nil];
		M_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		M_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		M_view.QItem_Edit = SelectedItem;
		
		[self.navigationController pushViewController:M_view animated:YES];
		[M_view release];
	}
	else if([TemplateType isEqualToString:@"Multiple Choice Multiple Answer"]){
		
		MultipleChoiceSingleAnswer *M_view = [[MultipleChoiceSingleAnswer alloc] initWithNibName:nil bundle:nil];
		M_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		M_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		M_view.QItem_Edit = SelectedItem;
		
		[self.navigationController pushViewController:M_view animated:YES];
		[M_view release];
		
	}
	else if([TemplateType isEqualToString:@"Descriptive Type"]){
		
		DescriptiveType *D_view =[[DescriptiveType alloc] initWithNibName:nil bundle:nil];
		
		D_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		D_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		D_view.QItem_Edit = SelectedItem;
		
		[self.navigationController pushViewController:D_view animated:YES];
		[D_view release];
		
		
	}
	else if ([TemplateType isEqualToString:@"True or False"]){
		
		TrueOrFalseYesOrNo *T_view =[[TrueOrFalseYesOrNo alloc] initWithNibName:nil bundle:nil];
		
		T_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		T_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		T_view.QItem_Edit = SelectedItem;
		
		[self.navigationController pushViewController:T_view animated:YES];
		[T_view release];

		
	}
	else if ([TemplateType isEqualToString:@"Yes or No"]){
		
		TrueOrFalseYesOrNo *T_view =[[TrueOrFalseYesOrNo alloc] initWithNibName:nil bundle:nil];
		
		T_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		T_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		T_view.QItem_Edit = SelectedItem;
		
		[self.navigationController pushViewController:T_view animated:YES];
		[T_view release];
		
	}
	else if ([TemplateType isEqualToString:@"Fill the Blanks"]){
		
		FillTheBlanks *F_view = [[FillTheBlanks alloc] initWithNibName:nil bundle:nil];
		
		F_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		F_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		F_view.QItem_Edit = SelectedItem;
		
		[self.navigationController pushViewController:F_view animated:YES];
		[F_view release];
		
		
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
   
	[fetchedResultsController release];
	[managedObjectContext release];
     [super dealloc];
}


@end

