//
//  AdminDashBoard.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 18/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "AdminDashBoard.h"
#import "lk_QuestionLists.h"
#import "lk_Topics.h"
#import "ViewQuestionList.h"
#import "Uploads.h"

@implementation AdminDashBoard

@synthesize listofItems;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Configure";
	listofItems = [[NSMutableArray alloc] init];
	
	// Add items to the array this is hardcoded for now .. may need to be migrated to the database
	[listofItems addObject:@"Question Template"];
	[listofItems addObject:@"Topics"];
	[listofItems addObject:@"View Questions"];
	[listofItems addObject:@"Uploads"];
	
	
}



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
    return [listofItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    NSString *cellValue = [[NSString alloc] initWithFormat:@"%@",[listofItems objectAtIndex:indexPath.row]];
	cell.textLabel.text = cellValue;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[cellValue release];
	
	return cell;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	int index = indexPath.row;
	
	switch (index) {
		case 0:
			;
			lk_QuestionLists *QL = [[lk_QuestionLists alloc] initWithStyle:UITableViewStyleGrouped];
			[self.navigationController pushViewController:QL animated:YES];
			[QL release];
			break;
			
		case 1:
			;
			lk_Topics *T = [[lk_Topics alloc] initWithStyle:UITableViewStyleGrouped];
			[self.navigationController pushViewController:T animated:YES];
			[T release];
				
			break;
		case 2:
			;
			ViewQuestionList *VQL = [[ViewQuestionList alloc] initWithStyle:UITableViewStyleGrouped];
			[self.navigationController pushViewController:VQL animated:YES];
			[VQL release];
			
				
			break;
		case 3:
			;
			Uploads *Up = [[Uploads alloc] initWithStyle:UITableViewStyleGrouped];
			[self.navigationController pushViewController:Up animated:YES];
			[Up release];
			
			
			break;
			

		default:
			break;
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
	[listofItems release];
    [super dealloc];
}


@end

