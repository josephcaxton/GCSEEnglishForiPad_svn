//
//  ClientAnswers.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 24/11/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "ClientAnswers.h"



@implementation ClientAnswers

@synthesize FullDataArray,PopBox,NumberCounter;



- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Answers";
	
	PopBox = [FullDataArray mutableCopy];
	NumberCounter = [[NSMutableArray alloc]init];
	
	
	for (int i = 0; i <[PopBox count]; i++) {
		
		[NumberCounter insertObject: [NSNumber numberWithInt:i+1] atIndex:i];  // this is just for numbering 
		
	}		
	
	
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if ([PopBox count] == 0) {
		
		[self.navigationController popViewControllerAnimated:YES];
	}
	[self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSInteger numberOfRows = 0;
	
		numberOfRows =   [PopBox count];   
	
	return numberOfRows;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    QuestionItems *QI = (QuestionItems *)[PopBox objectAtIndex:indexPath.row];
	//Show only the Filename without extension.
	//NSString *FullFileName = [NSString stringWithFormat:@"%@",[QI Question]];
	//NSArray *FileName = [FullFileName componentsSeparatedByString:@"."];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	//cell.textLabel.text = [NSString stringWithFormat:@"Answer   %@",[FileName objectAtIndex:0]];
	cell.textLabel.text = [NSString stringWithFormat:@"Question %i Answer" ,[[NumberCounter objectAtIndex:indexPath.row]intValue]]; // Just numbering here
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Mark(s): %@", QI.AllocatedMark];
    
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
    QuestionItems *SelectedItem = (QuestionItems *)[PopBox objectAtIndex:indexPath.row];
	
	NSString *TemplateType = [NSString stringWithFormat:@"%@", [SelectedItem.QuestionHeader1.QuestionTemplate valueForKey:@"Description"]];
	
	if ([TemplateType isEqualToString:@"Multiple Choice Single Answer"] ) {
		
		MultipleChoiceSingleAnswer *M_view = [[MultipleChoiceSingleAnswer alloc] initWithNibName:nil bundle:nil];
		M_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		M_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		M_view.QItem_View = SelectedItem;
		M_view.ShowAnswer = YES;
		
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:M_view animated:YES];
		[M_view release];
	}
	else if([TemplateType isEqualToString:@"Multiple Choice Multiple Answer"]){
		
		MultipleChoiceSingleAnswer *M_view = [[MultipleChoiceSingleAnswer alloc] initWithNibName:nil bundle:nil];
		M_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		M_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		M_view.QItem_View = SelectedItem;
		M_view.ShowAnswer = YES;
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:M_view animated:YES];
		[M_view release];
		
	}
	else if([TemplateType isEqualToString:@"Descriptive Type"]){
		
		DescriptiveType *D_view =[[DescriptiveType alloc] initWithNibName:nil bundle:nil];
		
		D_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		D_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		D_view.QItem_View = SelectedItem;
		D_view.ShowAnswer = YES;
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:D_view animated:YES];
		[D_view release];
		
		
	}
	else if ([TemplateType isEqualToString:@"True or False"]){
		
		TrueOrFalseYesOrNo *T_view =[[TrueOrFalseYesOrNo alloc] initWithNibName:nil bundle:nil];
		
		T_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		T_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		T_view.QItem_View = SelectedItem;
		T_view.ShowAnswer = YES;
        T_view.RemoveContinueButton = YES;
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:T_view animated:YES];
		[T_view release];
		
		
	}
	else if ([TemplateType isEqualToString:@"Yes or No"]){
		
		TrueOrFalseYesOrNo *T_view =[[TrueOrFalseYesOrNo alloc] initWithNibName:nil bundle:nil];
		
		T_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		T_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		T_view.QItem_View = SelectedItem;
		T_view.ShowAnswer = YES;
        T_view.RemoveContinueButton = YES;
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
		[self.navigationController pushViewController:T_view animated:YES];
		[T_view release];
		
	}
	else if ([TemplateType isEqualToString:@"Fill the Blanks"]){
		
		FillTheBlanks *F_view = [[FillTheBlanks alloc] initWithNibName:nil bundle:nil];
		
		F_view.QuestionTemplate = (lk_QuestionTemplate *)SelectedItem.QuestionHeader1.QuestionTemplate;
		F_view.SelectedTopic = (Topics *)SelectedItem.QuestionHeader1.QuestionHeader_Topic;
		F_view.QItem_View = SelectedItem;
		F_view.ShowAnswer = YES;
        F_view.RemoveContinueButton = YES;
        F_view.Specialflag= YES;
		
		// Remove this Object from the PopBox
		
		[PopBox removeObjectAtIndex:indexPath.row];
		[NumberCounter removeObjectAtIndex:indexPath.row];
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[FullDataArray release];
	[PopBox release];
	[NumberCounter release];
    [super dealloc];
}


@end

