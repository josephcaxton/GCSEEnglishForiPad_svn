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
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,185,55)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.navigationItem.title;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    self.navigationItem.titleView = label;
    [label sizeToFit];
  
    
    [self.tableView setBackgroundView:nil];
    NSString *BackImagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
	UIImage *BackImage = [[UIImage alloc] initWithContentsOfFile:BackImagePath];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:BackImage];
   
    
    

	if (QItem_ForEdit != nil) {
		
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	
		switch ([QItem_ForEdit.Difficulty intValue]) {
            case 1:
                appDelegate.Difficulty =@"Easy";
                break;
            case 2:
                appDelegate.Difficulty =@"Medium";
                break;
            case 3:
                appDelegate.Difficulty =@"Difficult";
                break;
				
		
		}
	}
	
	if (UserConfigure) {
		
        //Back to previous screen
        UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtn setBackgroundImage:[UIImage imageNamed:@"back_arrow40.png"] forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        backbtn.frame=CGRectMake(0.0, 0.0, 64.0, 40.0);
        UIBarButtonItem *GoBack = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = GoBack;

		self.navigationItem.title = @"Difficulty";
		
	}
	

    
}

-(void)goBack:(id)sender {
    
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
		return 4;
	}
	else{
		
		return 3;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	
	switch (indexPath.row) {
		case 0:
			
			
			cell.textLabel.text = @"Easy";
			
			if ([appDelegate.Difficulty  isEqualToString:@"Easy" ]) {
				
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				
				cell.accessoryType =UITableViewCellAccessoryNone;
				
			}
			
			break;
		case 1:
			
			cell.textLabel.text = @"Medium";
			if ([appDelegate.Difficulty  isEqualToString: @"Medium" ]) {
				
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				
				cell.accessoryType =UITableViewCellAccessoryNone;
				
			}
			
			
			break;
		case 2:
			
			cell.textLabel.text = @"Difficult";
			if ([appDelegate.Difficulty  isEqualToString: @"Difficult" ]) {
				
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				
				cell.accessoryType =UITableViewCellAccessoryNone;
				
			}
			
			break;
		case 3:
			
			cell.textLabel.text = @"All";
			if ([appDelegate.Difficulty  isEqualToString: @"All" ]) {
				
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				
				cell.accessoryType =UITableViewCellAccessoryNone;
				
			}
			
			break;
            
		
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
		
		if ([appDelegate.Difficulty  isEqualToString:@"Easy" ]) {
			
			QItem_ForEdit.Difficulty = [NSNumber numberWithInt:1];
		}
		else if ([appDelegate.Difficulty isEqualToString:@"Medium"]){
			
			QItem_ForEdit.Difficulty = [NSNumber numberWithInt:2];
			
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



@end

