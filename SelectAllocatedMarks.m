//
//  SelectAllocatedMarks.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 12/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "SelectAllocatedMarks.h"
#import "EvaluatorAppDelegate.h"


@implementation SelectAllocatedMarks
@synthesize QItem_ForEdit;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	if (QItem_ForEdit != nil) {
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		appDelegate.AllocatedMarks =QItem_ForEdit.AllocatedMark;
		
	}
	
    
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);

}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 20;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
    EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if (indexPath.row == 0) {
			
		
		
		if ([appDelegate.AllocatedMarks isEqualToNumber:[NSNumber numberWithInt:indexPath.row + 1]]) {
				
			 cell.accessoryType = UITableViewCellAccessoryCheckmark;
				
			}
		else {
				cell.accessoryType = UITableViewCellAccessoryNone;
								
		}
		//NSNumber *Num = [NSNumber numberWithInt:indexPath.row + 1];
		//appDelegate.AllocatedMarks = Num;
		
		cell.textLabel.text = [NSString  stringWithFormat:@"%i Mark",indexPath.row + 1];
		
	}
	else
	{
		//NSLog(@"Appdelegate here :%@ Indexpath: %i",appDelegate.AllocatedMarks, indexPath.row);
		if ([appDelegate.AllocatedMarks isEqualToNumber:[NSNumber numberWithInt:indexPath.row + 1]]) {
			
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			
		}
		
		cell.textLabel.text = [NSString  stringWithFormat:@"%i Marks",indexPath.row + 1];
	}
	
	
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
		NSArray *Allcells = [tableView visibleCells];
	for (UITableViewCell *cell in Allcells){
		cell.accessoryType = UITableViewCellAccessoryNone;
		
	}
		
		UITableViewCell *SelectedCell = [tableView cellForRowAtIndexPath:indexPath];
		SelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		NSNumber *Num = [NSNumber numberWithInt:indexPath.row + 1];
		appDelegate.AllocatedMarks = Num;
	
	if (QItem_ForEdit != nil) {
		
		QItem_ForEdit.AllocatedMark = appDelegate.AllocatedMarks;
		
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[QItem_ForEdit release];
}


@end

