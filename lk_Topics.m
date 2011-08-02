//
//  lk_Topics.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 29/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "lk_Topics.h"
#import "EvaluatorAppDelegate.h"

@implementation lk_Topics

@synthesize managedObjectContext, fetchedResultsController;
@synthesize tableHeaderView;
@synthesize DescriptionTextField;





- (void)viewDidLoad {
	
    
	self.navigationItem.title = @"Topics";
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Create and set the table header view.
    if (tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"lk_Topics" owner:self options:nil];
        self.tableView.tableHeaderView = tableHeaderView;
		
	}
	
	
			
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.fetchedResultsController = nil;
	self.managedObjectContext = [self ManagedObjectContext];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On Topics Table" 
															message: @"Error getting data from Topics Table contact support" delegate: self 
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
		
		NSString *message = [[NSString alloc] initWithFormat:@"Do you want to add %@ to topics",DescriptionTextField.text];
		UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:
									 message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
		
		[actionSheet showInView:self.tabBarController.view];
		[message release];
		[actionSheet release];
		
		
	}
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
	
	if (buttonIndex != [actionSheet cancelButtonIndex]) {
		
		Topics *newTopic = [NSEntityDescription insertNewObjectForEntityForName:@"Topics" inManagedObjectContext:self.managedObjectContext];
		
		newTopic.TopicName = DescriptionTextField.text;
		
		NSError *error = nil;
		
		if (![newTopic.managedObjectContext save:&error]) {
			
			UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On Topics Table" 
																message: @"Error adding data to Topics Table contact support" delegate: self 
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
            title = @"List of Topics";
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
    
	lk_TopicsCell *QLcell = (lk_TopicsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (QLcell == nil) {
        QLcell = [[[lk_TopicsCell	alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		QLcell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    // Configure the cell...
    [self configureCell:QLcell atIndexPath:indexPath];
	
	//cell.textLabel.text = cell.lblDescription.text;
	//cell.detailTextLabel.text = cell.lblLoggedDate.text;
    return QLcell;
}





- (void)configureCell:(lk_TopicsCell *)mycell atIndexPath:(NSIndexPath *)indexPath; {
    
	Topics *TP = (Topics *)[fetchedResultsController objectAtIndexPath:indexPath]; 
    mycell.OneTopic = TP;
	
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
			
			UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error on Topics Table" 
																message: @"Error cannot delete item from Topics Table contact support" delegate: self 
													  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			
			
			
			[DataError show];
			
			[DataError release];		
			
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		}
		
		
	} 
	
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
			[self configureCell:(lk_TopicsCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
	
	[fetchedResultsController release];
	[managedObjectContext release];
	[tableHeaderView release];
	[DescriptionTextField release];
    [super dealloc];
}


@end
