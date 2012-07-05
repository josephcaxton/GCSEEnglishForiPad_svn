//
//  Help.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 20/12/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "Help.h"
#import "CopyrightLicense.h"
#import "HelpVideo.h"
#import "Attribution.h"
@implementation Help
@synthesize listofItems;

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationController *nav =self.navigationController;
    nav.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.title = @"Help";
	listofItems = [[NSMutableArray alloc] init];
	
	// Add items to the array this is hardcoded for now .. may need to be migrated to the database
	[listofItems addObject:@"View Help Video"];
	//[listofItems addObject:@"View Help File"];
	//[listofItems addObject:@"Licensing Agreement"];
	[listofItems addObject:@"Acknowledgements"];
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    // Configure the cell...
    
    NSString *cellValue = [[NSString alloc] initWithFormat:@"%@",[listofItems objectAtIndex:indexPath.row]];
	cell.textLabel.text = cellValue;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[cellValue release];
	
	return cell;
	
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
	
	switch (index) {
			
		case 0:
			;
			HelpVideo *Hlpv = [[HelpVideo alloc] initWithNibName:nil bundle:nil];
			[self.navigationController pushViewController:Hlpv animated:YES];
			[Hlpv release];
			break;
			
		//case 1:
//			;
//			Help1 *Hlp = [[Help1 alloc] initWithNibName:nil bundle:nil];
//			[self.navigationController pushViewController:Hlp animated:YES];
//			[Hlp release];
//			break;
			
		//case 1:
//			;
//			CopyrightLicense *L = [[CopyrightLicense alloc] initWithNibName:nil bundle:nil];
//			[self.navigationController pushViewController:L animated:YES];
//			[L release];
//			
//			break; 
			
		case 1:
			;
			Attribution *Attr = [[Attribution alloc] initWithNibName:nil bundle:nil];
			[self.navigationController pushViewController:Attr animated:YES];
			[Attr release];
			
			break; 
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
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

