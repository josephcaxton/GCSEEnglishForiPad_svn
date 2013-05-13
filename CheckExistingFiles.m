//
//  CheckExistingFiles.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 03/12/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "CheckExistingFiles.h"


@implementation CheckExistingFiles

@synthesize managedObjectContext, fetchedResultsController,ListofPdfsNotInDataBase;



-(id)init
{
    if (self = [super init]){
		
		self.fetchedResultsController = nil;
		self.managedObjectContext = [self ManagedObjectContext];
		
		NSError *error = nil;
		if (![[self fetchedResultsController] performFetch:&error]) {
			
			UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On Topics table" 
																message: @"Error getting data from Topics Table contact support" delegate: self 
													  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			
			[DataError show];
			
			
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			
			
		}
		
		// Get the Lists of files from client bundle compare with the list on the database and make a list of the difference
		// I had to use a work around here as mutable arrays rearranges the items in index if an object is removed
		NSArray *ListofpdfsOnClient = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
		
		NSMutableArray *pdfsOnClient = [NSMutableArray arrayWithArray:ListofpdfsOnClient];
		NSMutableArray *ListofpdfsMissing = [[NSMutableArray alloc]init];
		

		NSArray *FetchObjects = [fetchedResultsController fetchedObjects];
		
				
		int ClientPDFCount = [pdfsOnClient count];
		
		for (int i = 0; i< ClientPDFCount; i++) {
			
			NSString *Value = [[pdfsOnClient objectAtIndex:i]lastPathComponent];
				
				for(int p = 0; p< [FetchObjects count]; p++) {
					
					QuestionItems *QI = (QuestionItems *)[FetchObjects objectAtIndex:p ];
					
					if ([Value isEqualToString:QI.Question] ) {
				 
						[pdfsOnClient replaceObjectAtIndex:i withObject:@"Empty"];
					
					
					}
					
				}
			
		}
		
		for (int i = 0; i< [pdfsOnClient count]; i++) {	 
		
			NSString *Value = [[pdfsOnClient objectAtIndex:i]lastPathComponent];
			
			
			if ([Value isEqualToString:@"Empty"] != true ) {
				[ListofpdfsMissing addObject:Value];  
			 }
		} 
		
		ListofPdfsNotInDataBase =[NSArray arrayWithArray:ListofpdfsMissing];
		
		
		
    }
	
    return self;
	
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
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root_topics"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController = aFetchedResultsController;
		
		
		
		
		
	}
	
	return fetchedResultsController;
}    


@end
