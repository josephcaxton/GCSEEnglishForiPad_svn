//
//  ViewQuestionList.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 19/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewQuestionList : UITableViewController <NSFetchedResultsControllerDelegate>{
	
@private
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	

}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSManagedObjectContext *)ManagedObjectContext;

@end
