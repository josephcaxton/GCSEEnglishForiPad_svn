//
//  CustomPickerDataSource_Num_Questions.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 02/11/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "CustomPickerDataSource_Num_Questions.h"


@implementation CustomPickerDataSource_Num_Questions

@synthesize customPickerArray;



- (id)init
{
	
	self = [super init];
	if (self)
	{
		
		// create the data source for this custom picker
		customPickerArray = [[NSMutableArray alloc] init];
		
		NSString *AccessLevel = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessLevel"];
		
		if([AccessLevel intValue] == 1){
			
			for (int i = 1; i < 30 + 1; i++) {
				
				[customPickerArray  addObject: [NSString stringWithFormat:@"%i", i ]];
			}
		}
		
		else if ([AccessLevel intValue] == 2){
		
				for (int i = 1; i < 250 + 1; i++) {
			
				[customPickerArray  addObject: [NSString stringWithFormat:@"%i", i ]];
			}
		
		}
		else if ([AccessLevel intValue] == 3){
			
			for (int i = 1; i < 500 + 1; i++) {
				
				[customPickerArray  addObject: [NSString stringWithFormat:@"%i", i ]];
			}
		
		}
		
		else if ([AccessLevel intValue] == 4){
			
			for (int i = 1; i < 750 + 1; i++) {
				
				[customPickerArray  addObject: [NSString stringWithFormat:@"%i", i ]];
			}
			
		}
		
		else if ([AccessLevel intValue] == 5){
			
			for (int i = 1; i < 1040 + 1; i++) {
				
				[customPickerArray  addObject: [NSString stringWithFormat:@"%i", i ]];
			}
			
		}
		
	}
	return self;
	
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if(component == 0){
		
		return 1;
	}
	
	else {
		return [customPickerArray count];
		
	}

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 30;
}

/*- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == 0) {
		
		return @"Question(s)";
	}
	
	else {
		
		return [customPickerArray objectAtIndex:row];
		
	}

	
} */

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 145, 45)];
	[label setTextAlignment:UITextAlignmentCenter];
	label.opaque=NO;
	label.backgroundColor=[UIColor clearColor];
	label.textColor = [UIColor blackColor];
	UIFont *font = [UIFont boldSystemFontOfSize:20];
	label.font = font;
	
	if (component == 0) {
		
		[label setText:@"Question(s)"];
		
		
	}
	else if(component == 1){
		
		[label setText:[NSString stringWithFormat:@"%@", [customPickerArray objectAtIndex:row]]];

	}
	
	return [label autorelease];

	
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	
	if (component == 1) {
		
		EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
		
		 appDelegate.NumberOfQuestions =[NSNumber numberWithInt:row+1];
		
	}
	

	
	
	
}

- (void)dealloc
{
	[customPickerArray release];
	[super dealloc];
}


@end
