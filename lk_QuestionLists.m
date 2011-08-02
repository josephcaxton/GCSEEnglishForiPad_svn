//
//  lk_QuestionLists.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 19/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "lk_QuestionLists.h"
#import "EvaluatorAppDelegate.h"
#import "AdminDashBoard.h"


@implementation lk_QuestionLists

@synthesize managedObjectContext, fetchedResultsController;
@synthesize tableHeaderView;
@synthesize DescriptionTextField;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
		self.navigationItem.title = @"Templates";
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Create and set the table header view.
    if (tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"lk_QuestionListHeader" owner:self options:nil];
		
		// this attempt to fix Gap problem between header and the first section -- Problem still exist
		//CGRect NewFrame = tableHeaderView.frame;
		//NewFrame.size.height = NewFrame.size.height + 1;
		//tableHeaderView.frame	 = NewFrame;
        self.tableView.tableHeaderView = tableHeaderView;
		
           }
	
	
		
	

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.fetchedResultsController = nil;
	self.managedObjectContext = [self ManagedObjectContext];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On QuestionTemplate Table" 
															message: @"Error getting data from QuestionTemplate Table contact support" delegate: self 
												  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[DataError show];
		[DataError release];		
		
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
	}		
	
	
}





#pragma mark -
#pragma mark View Description textField 	
	
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
	if ((textField == self.DescriptionTextField ) && (!self.editing)) {
		
		self.navigationItem.rightBarButtonItem= nil;
		
	}
	else{
	
		if (self.editing) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your have not finished editing" 
									message:@"Click on OK and Done to finish editing" delegate:self 
												  cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			[DescriptionTextField resignFirstResponder];
		}
	
	}
	
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.DescriptionTextField) {
		[DescriptionTextField resignFirstResponder];
		
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
		[self save];
		
	}
	return YES;
}

#pragma mark -
#pragma mark View Save

- (void)save{
	
			if (DescriptionTextField.text.length > 0) {
		
			NSString *message = [[NSString alloc] initWithFormat:@"Do you want to add %@ to templates",DescriptionTextField.text];
			UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:
										 message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
											
			[actionSheet showInView:self.tabBarController.view];
			[message release];
			[actionSheet release];
			
			
			}
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{

	if (buttonIndex != [actionSheet cancelButtonIndex]) {
		
		lk_QuestionTemplate *newQuestionTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"lk_QuestionTemplate" inManagedObjectContext:self.managedObjectContext];
		
		newQuestionTemplate.Description = DescriptionTextField.text;
		newQuestionTemplate.LoggedDate = [NSDate date];
		NSError *error = nil;
		
		if (![newQuestionTemplate.managedObjectContext save:&error]) {
			
			UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On QuestionTemplate Table" 
																message: @"Error adding data to QuestionTemplate Table contact support" delegate: self 
													  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			
			
			
			[DataError show];
			
			[DataError release];		
			
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			
			
		}		
		
		
		// reload
		
		[self.tableView reloadData];
		
		DescriptionTextField.text = nil;
		
	}
	else {
		
		DescriptionTextField.text = nil;
			
	}

	
	
	
}


#pragma mark -
#pragma mark Rotate orientation

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark -
#pragma mark Table Configuration

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger count = [[fetchedResultsController sections] count];
    
	if (count == 0) {
		count = 1;
	}
	
    return count;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title = nil;
	
	switch (section) {
        
        case 0:
            title = @"List of Templates";
            break;
        default:
            break;
    }
    return title;
	
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	NSInteger numberOfRows = 0;
	    
	if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
		
		
				
    }
    
    return numberOfRows;
	}
	



#pragma mark -
#pragma mark Table Appearance and cell Configure
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	 
			static NSString *CellIdentifier = @"Cell";
    
   lk_QuestionListsCell *QLcell = (lk_QuestionListsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (QLcell == nil) {
        QLcell = [[[lk_QuestionListsCell	alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
      QLcell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    // Configure the cell...
    [self configureCell:QLcell atIndexPath:indexPath];
    return QLcell;
}
		
	



- (void)configureCell:(lk_QuestionListsCell *)mycell atIndexPath:(NSIndexPath *)indexPath; {
    
	lk_QuestionTemplate *QT = (lk_QuestionTemplate *)[fetchedResultsController objectAtIndexPath:indexPath]; 
    mycell.QuestionTemplate = QT;
}


#pragma mark -
#pragma mark Table Editing

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			
			UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error QuestionTemplate Table" 
																message: @"Error cannot delete item from QuestionTemplate Table contact support" delegate: self 
													  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			
			
			
			[DataError show];
			[DataError release];		
			
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			
			
		}
		
		 
     } 
	
    }
/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	
	//DescriptionTextField.enabled = NO;
	
	
}
*/

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


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(lk_QuestionListsCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}





#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.tableHeaderView =nil;
	self.DescriptionTextField = nil;
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[tableHeaderView release];
	[DescriptionTextField release];
    [super dealloc];
}


@end

