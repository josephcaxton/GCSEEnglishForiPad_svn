//
//  SelectDifficulty.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 13/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "SelectDifficulty.h"
#import "EvaluatorAppDelegate.h"

@implementation SelectDifficulty
@synthesize QItem_ForEdit,UserConfigure;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	if (QItem_ForEdit != nil) {
		
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	
		switch ([QItem_ForEdit.Difficulty intValue]) {
		case 1:
			appDelegate.Difficulty =@"Foundation";
			break;
		case 0:
			appDelegate.Difficulty =@"Foundation & Higher";
			break;
		case 3:
			appDelegate.Difficulty =@"Higher";
			break;
				
		
		}
	}
	
	if (UserConfigure) {
		
		UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Back:)];
		self.navigationItem.leftBarButtonItem = Back;
		self.navigationItem.title = @"Difficulty";
		[Back release];
	}
	

    
}

-(IBAction)Back:(id)sender{
	
	[self.navigationController popViewControllerAnimated:YES];
	
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
    // Return the number of rows in the section. If User is configuring the  we need to add ALL
	if (UserConfigure) {
		return 3;
	}
	else{
		
		return 2;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	
	switch (indexPath.row) {
		case 0:
			
			
			cell.textLabel.text = @"Foundation";
			
			if ([appDelegate.Difficulty  isEqualToString:@"Foundation" ]) {
				
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				
				cell.accessoryType =UITableViewCellAccessoryNone;
				
			}
			
			break;
		case 2:
			
			cell.textLabel.text = @"Foundation & Higher";
			if ([appDelegate.Difficulty  isEqualToString: @"Foundation & Higher" ]) {
				
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				
				cell.accessoryType =UITableViewCellAccessoryNone;
				
			}
			
			
			break;
		case 1:
			
			cell.textLabel.text = @"Higher";
			if ([appDelegate.Difficulty  isEqualToString: @"Higher" ]) {
				
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				
				cell.accessoryType =UITableViewCellAccessoryNone;
				
			}
			
			break;
//		case 3:
//			
//			cell.textLabel.text = @"All";
//			if ([appDelegate.Difficulty  isEqualToString: @"All" ]) {
//				
//				cell.accessoryType = UITableViewCellAccessoryCheckmark;
//			}
//			else {
//				
//				cell.accessoryType =UITableViewCellAccessoryNone;
//				
//			}
//			
//			break;
		
	}
    // Configure the cell...
    
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
	appDelegate.Difficulty = SelectedCell.textLabel.text;
	
	if (QItem_ForEdit != nil) {
		
		if ([appDelegate.Difficulty  isEqualToString:@"Foundation" ]) {
			
			QItem_ForEdit.Difficulty = [NSNumber numberWithInt:1];
		}
		else if ([appDelegate.Difficulty isEqualToString:@"Foundation & Higher"]){
			
			QItem_ForEdit.Difficulty = [NSNumber numberWithInt:0];
			
		}
		else{
			
			QItem_ForEdit.Difficulty = [NSNumber numberWithInt:3];
			
		}
		
	}
	
	[self.navigationController popViewControllerAnimated:YES];
		
	



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
	[QItem_ForEdit release];
    [super dealloc];
	
}


@end

