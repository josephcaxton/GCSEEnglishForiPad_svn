//
//  Uploads.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 20/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "Uploads.h"


@implementation Uploads

@synthesize managedObjectContext;  //, fetchedResultsController;
@synthesize fetchedResultsController_QT,fetchedResultsController_Topics,fetchedResultsController_Version,QTArray,TopArray;
@synthesize FileName,Topicbutton,QuestionTemplatebutton,Databutton,VersionButton,PdfButton,VerNumber;

#pragma mark -
#pragma mark View lifecycle

int StoreVal = 0;
int Version = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.managedObjectContext = [self ManagedObjectContext];
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	NSError *error = nil;
	if (![[self fetchedResultsController_Version] performFetch:&error]) {
		
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On DBVersion" 
															message: @"Error getting data from DBVersion Table contact support" delegate: self 
												  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[DataError show];
		
		[DataError release];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		
		
	}
	
	
	NSArray *Objs = [fetchedResultsController_Version fetchedObjects];
	if ([Objs count] > 0) {
		
	
	VerNumber = (DBVersion *)[Objs objectAtIndex:0];
		
	if (VerNumber) {
			Version = [VerNumber.VersionNumber intValue];
		}
	}
	
}

-(IBAction)StartUpload:(id)sender{
	
	UIButton *button = (UIButton *)sender;
	int row = button.tag;

	
	NSString *Mtext = @"";
	switch (row) {
		case 0:
			;
			Mtext = [NSString stringWithFormat:@"Topic"];
			StoreVal = 0;  
			break;
		case 1:
			;
			Mtext = [NSString stringWithFormat:@"Question Template"];
			StoreVal =1;  
			break;
		case 2:
			;
			Mtext = [NSString stringWithFormat:@"Data"];
			StoreVal = 2;
			// Get the Topics and add it an array
			NSError *error = nil;
			if (![[self fetchedResultsController_Topics] performFetch:&error]) {
				
				UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On Topics" 
																	message: @"Error getting data from Topics Table contact support" delegate: self 
														  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
				
				
				
				[DataError show];
				
				[DataError release];
				NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
				
				
				
			}
			
			TopArray = [fetchedResultsController_Topics fetchedObjects];
			
			
			// Get the QuestionTemplates and add it an array
			if (![[self fetchedResultsController_QT] performFetch:&error]) {
				
				UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On Question Template" 
																	message: @"Error getting data from Question Template Table contact support" delegate: self 
														  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
				
				
				
				[DataError show];
				
				[DataError release];
				NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
				
				
				
			}
			
			QTArray = [fetchedResultsController_QT fetchedObjects];
			
							
			break;
		default:
			break;
	}
	
	
	
	
	NSString *message = [[NSString alloc] initWithFormat:@"Do you want to load %@ to DataBase", Mtext];
	
	UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:
								 message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	
	[actionSheet showInView:self.tabBarController.view];	
	[message release];
	[actionSheet release];
	
	
	
		
}
						 
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
							 
		if (buttonIndex != [actionSheet cancelButtonIndex]) {
				
			if (StoreVal == 0) {
				
			NSArray *Topicspaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *TopicsdocumentsDirectory = [Topicspaths objectAtIndex:0];
			NSString *Topicsresult = [TopicsdocumentsDirectory stringByAppendingString:@"/ChemistryTopics.xml"];
				
			[self loadDataFromXML:Topicsresult];
			
			[self DeleteFile:Topicsresult];	
				
			}
			
			else if (StoreVal == 1){
				
				NSArray *Templatepaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *TemplatedocumentsDirectory = [Templatepaths objectAtIndex:0];
				NSString *Templateresult = [TemplatedocumentsDirectory stringByAppendingString:@"/ChemistryQuestionTemplates.xml"];
				
				[self loadDataFromXML:Templateresult];
				
				[self DeleteFile:Templateresult];
			}
			
			else if (StoreVal == 2){
				
				NSArray *DataPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *DataDirectory = [DataPaths objectAtIndex:0];
				NSString *Dataresult = [DataDirectory stringByAppendingString:@"/Chemistry_Data.xml"];
				
				//[self loadDataFromXML:Dataresult];
				[self MyParser:Dataresult]; // I have had to write my own parser as Xml and Html cannot marry.
				[self DeleteFile:Dataresult]; //Delete file when finished
				
				
			}
			
			NSString *message = [[NSString alloc] initWithFormat:@"Data Successfully loaded"];
			
			UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Loaded Successfully"
														   message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[alert show];
			[message release];
			[alert release];
								 
		}
	
		else{
			
			
			
			
		}
							 
							 
							 
							 
	}
						 
-(void)loadDataFromXML:(NSString *)FileLocation {
	
	NSString* path = FileLocation;
	
	NSData* data = [NSData dataWithContentsOfFile: path];
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
	
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	
	
	
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//the parser started this document. what are you going to do?
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {	
	
	
	if ([elementName isEqualToString:@"Topics"]) {
		
		
		NSString* title = [attributeDict valueForKey:@"title"];
		
		Topics *T =[NSEntityDescription insertNewObjectForEntityForName:@"Topics" inManagedObjectContext:self.managedObjectContext];
		T.TopicName = title;
		
		NSError *error = nil;
		if (![self.managedObjectContext save:&error]) {
			
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		}

		 
	}
	else if ([elementName isEqualToString:@"QuestionTemplate"]){
		
		NSString* title = [attributeDict valueForKey:@"title"];
		lk_QuestionTemplate *QT = [NSEntityDescription insertNewObjectForEntityForName:@"lk_QuestionTemplate" inManagedObjectContext:self.managedObjectContext];
		QT.Description = title;
		NSError *error = nil;
		if (![self.managedObjectContext save:&error]) {
			
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		}
		
	}
	else if([elementName isEqualToString:@"Question"]){
		
		NSManagedObjectContext *context = [self ManagedObjectContext];
		
		
		// QUESTION HEADER TABLE
		QuestionHeader *QH = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionHeader" inManagedObjectContext:context];
		
		//QuestionTemplate
		NSString* QTDescription = [attributeDict valueForKey:@"QTDescription"];
		
		
		// Question Template added to object
		for(lk_QuestionTemplate *Temp in QTArray){
			
			if([QTDescription isEqualToString:[NSString stringWithFormat:@"%@",Temp.Description]]){
				
				QH.QuestionTemplate = Temp;
				
			}
			
		}
		
		NSString* TopicName = [attributeDict valueForKey:@"TopicName"];
		
		for (Topics *Temp1 in TopArray) {
			
			if ([TopicName isEqualToString:[NSString stringWithFormat:@"%@",Temp1.TopicName]] ) {
				
				QH.QuestionHeader_Topic = Temp1;
			}
		}
		
		NSString* Autorize = [attributeDict valueForKey:@"Autorize"];
		QH.Autorize = [NSNumber numberWithInt:[Autorize intValue]];
		
					  // NSLog(@"%@ - %@ - %@",QH.QuestionTemplate,QH.QuestionHeader_Topic, QH.Autorize);
		
		
		//QUESTION ITEMS TABLE
		QuestionItems *QI = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionItems" inManagedObjectContext:context];
		[QH  addQuestionItemsObject:QI];
		
		NSString* AllocatedMark = [attributeDict valueForKey:@"AllocatedMark"];
		
		QI.AllocatedMark = [NSNumber numberWithInt:[AllocatedMark intValue]];
		
		NSString* Difficulty = [attributeDict valueForKey:@"Difficulty"];
		
		QI.Difficulty = [NSNumber numberWithInt:[Difficulty intValue]];
		
		NSString* Question = [attributeDict valueForKey:@"Question"];
		
		QI.Question = Question;
		
		NSString* RequireActivityMarker = [attributeDict valueForKey:@"RequireActivityMarker"];
		
		QI.RequireActivityMarker = [NSNumber numberWithInt:[RequireActivityMarker intValue]];
		
		NSString* AccessLevel = [attributeDict valueForKey:@"AccessLevel"];
		
		QI.AccessLevel = [NSNumber numberWithInt:[AccessLevel intValue]];
		
		NSString* Answer1Text = [attributeDict valueForKey:@"Answer1Text"];
		NSString* Answer1Correct = [attributeDict valueForKey:@"Answer1Correct"];
		
		if ([Answer1Text length] > 0) {
			
			Answers *Ans1  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans1];
			Ans1.AnswerText = Answer1Text;
			Ans1.Correct = [NSNumber numberWithInt:[Answer1Correct intValue]];
		}
			
		NSString* Answer2Text = [attributeDict valueForKey:@"Answer2Text"];
		NSString* Answer2Correct = [attributeDict valueForKey:@"Answer2Correct"];
		
		if ([Answer2Text length] > 0) {
			
			Answers *Ans2  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans2];
			Ans2.AnswerText = Answer2Text;
			Ans2.Correct = [NSNumber numberWithInt:[Answer2Correct intValue]];
		}
		
		NSString* Answer3Text = [attributeDict valueForKey:@"Answer3Text"];
		NSString* Answer3Correct = [attributeDict valueForKey:@"Answer3Correct"];
		
		if ([Answer3Text length] > 0) {
			
			Answers *Ans3  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans3];
			Ans3.AnswerText = Answer3Text;
			Ans3.Correct = [NSNumber numberWithInt:[Answer3Correct intValue]];
		}
		
		NSString* Answer4Text = [attributeDict valueForKey:@"Answer4Text"];
		NSString* Answer4Correct = [attributeDict valueForKey:@"Answer4Correct"];
		
		if ([Answer4Text length] > 0) {
			
			Answers *Ans4  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans4];
			Ans4.AnswerText = Answer4Text;
			Ans4.Correct = [NSNumber numberWithInt:[Answer4Correct intValue]];
		}
		NSString* Answer5Text = [attributeDict valueForKey:@"Answer5Text"];
		NSString* Answer5Correct = [attributeDict valueForKey:@"Answer5Correct"];
		
		if ([Answer5Text length] > 0) {
			
			Answers *Ans5  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans5];
			Ans5.AnswerText = Answer5Text;
			Ans5.Correct = [NSNumber numberWithInt:[Answer5Correct intValue]];
		}
		
		NSError *error = nil;
		if (![context save:&error]) {
			
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
			
			//NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			//abort();
		}
		
		
		
		
	}
	
	
	
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//the parser finished. what are you going to do?
}

-(void)MyParser:(NSString *)FileLocation{
	
	NSError* error;
	
	NSString* fileContents = [NSString stringWithContentsOfFile:FileLocation encoding:NSWindowsCP1252StringEncoding error:&error];
	
	
	//NSLog(@"MyError %@, %@", &error, [&error userInfo]);
	
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"±"]];
	
	for(int idx = 0; idx < pointStrings.count; idx++)
	{
		// break the string down even further to the columns
		NSString* currentPointString = [pointStrings objectAtIndex:idx];
		NSArray* arr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
		
		NSString *QTDescription = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:1]];
		NSString *TopicName = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:3]];
		NSString *Autorize = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:5]];
		NSString *DateAutorized = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:7]];
		NSString *AllocatedMark = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:9]];
		NSString *Difficulty = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:11]];
		NSString *Question = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:13]];
		NSString *RequireActivityMarker = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:15]];
		NSString *Answer1Text = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:17]];
		NSString *Answer1Correct = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:19]];
		NSString *Answer1Reason = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:21]];
		NSString *Answer2Text = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:23]];
		NSString *Answer2Correct = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:25]];
		NSString *Answer2Reason = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:27]];
		NSString *Answer3Text = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:29]];
		NSString *Answer3Correct = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:31]];
		NSString *Answer3Reason = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:33]];
		NSString *Answer4Text = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:35]];
		NSString *Answer4Correct = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:37]];
		NSString *Answer4Reason = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:39]];
		NSString *Answer5Text = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:41]];
		NSString *Answer5Correct = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:43]];
		NSString *Answer5Reason = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:45]];
		NSString *AccessLevel = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:47]];
	
		NSManagedObjectContext *context = [self ManagedObjectContext];
		
		
		// QUESTION HEADER TABLE
		QuestionHeader *QH = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionHeader" inManagedObjectContext:context];
		
		//QuestionTemplate
		// Question Template added to object
		for(lk_QuestionTemplate *Temp in QTArray){
			
			if([QTDescription isEqualToString:[NSString stringWithFormat:@"%@",Temp.Description]]){
				
				QH.QuestionTemplate = Temp;
				
			}
			
		}
		
		
		for (Topics *Temp1 in TopArray) {
			
			if ([TopicName isEqualToString:[NSString stringWithFormat:@"%@",Temp1.TopicName]] ) {
				
				QH.QuestionHeader_Topic = Temp1;
			}
		}
		
		QH.Autorize = [NSNumber numberWithInt:[Autorize intValue]];
		
		// NSLog(@"%@ - %@ - %@",QH.QuestionTemplate,QH.QuestionHeader_Topic, QH.Autorize);
		
		
		//QUESTION ITEMS TABLE
		QuestionItems *QI = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionItems" inManagedObjectContext:context];
		[QH  addQuestionItemsObject:QI];
		
		
		QI.AllocatedMark = [NSNumber numberWithInt:[AllocatedMark intValue]];
		QI.Difficulty = [NSNumber numberWithInt:[Difficulty intValue]];
		QI.Question = Question;
		QI.RequireActivityMarker = [NSNumber numberWithInt:[RequireActivityMarker intValue]];
		QI.AccessLevel = [NSNumber numberWithInt:[AccessLevel intValue]];
	
		
		if ([Answer1Text length] > 0) {
			
			Answers *Ans1  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans1];
			Ans1.AnswerText = Answer1Text;
			Ans1.Correct = [NSNumber numberWithInt:[Answer1Correct intValue]];
		}
		
		if ([Answer2Text length] > 0) {
			
			Answers *Ans2  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans2];
			Ans2.AnswerText = Answer2Text;
			Ans2.Correct = [NSNumber numberWithInt:[Answer2Correct intValue]];
		}
		
		
		if ([Answer3Text length] > 0) {
			
			Answers *Ans3  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans3];
			Ans3.AnswerText = Answer3Text;
			Ans3.Correct = [NSNumber numberWithInt:[Answer3Correct intValue]];
		}
		
		
		if ([Answer4Text length] > 0) {
			
			Answers *Ans4  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans4];
			Ans4.AnswerText = Answer4Text;
			Ans4.Correct = [NSNumber numberWithInt:[Answer4Correct intValue]];
		}
				
		if ([Answer5Text length] > 0) {
			
			Answers *Ans5  = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
			[QI addAnswers1Object:Ans5];
			Ans5.AnswerText = Answer5Text;
			Ans5.Correct = [NSNumber numberWithInt:[Answer5Correct intValue]];
		}
		
		NSError *error = nil;
		if (![context save:&error]) {
			
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
			
			//NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			//abort();
		}
		
		
		
		
		[QTDescription release];
		[TopicName release];
		[Autorize release];
		[DateAutorized release];
		[AllocatedMark release];
		[Difficulty release];
		[Question release];
		[RequireActivityMarker release];
		[Answer1Text release];
		[Answer1Correct release];
		[Answer1Reason release];
		[Answer2Text release];
		[Answer2Correct release];
		[Answer2Reason release];
		[Answer3Text release];
		[Answer3Correct release];
		[Answer3Reason release];
		[Answer4Text release];
		[Answer4Correct release];
		[Answer4Reason release];
		[Answer5Text release];
		[Answer5Correct release];
		[Answer5Reason release];
		[AccessLevel release];
		
	}
}

						 

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(BOOL)DeleteFile:(NSString*)documentFullName {
	
	NSError **error = nil;
	
	NSFileManager *FM = [NSFileManager defaultManager];
	[FM removeItemAtPath:documentFullName error:error ];
	
	return YES;
}

-(IBAction)ChangeVersionNumber:(id)sender{
	
	Version++;
	
	[VerNumber setVersionNumber:[NSNumber numberWithInt:Version]]; 
	
	 NSError *error = nil;
	 
	if (![[self managedObjectContext] save:&error]) {
		
		UIAlertView *DataError = [[UIAlertView alloc] initWithTitle: @"Error On DBVersion" 
															message: @"Error getting saving to DBVersion Table contact support" delegate: self 
												  cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[DataError show];
		
		[DataError release];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		
		
	}
	[self.navigationController popViewControllerAnimated:YES];
}

/*-(IBAction)CreatePdfs:(id)sender{
	
	/// The Problem with using a webview is that webview does cannot finish loading in the UIwebview in the runloop 
	// Except at the end.. So i am dumping this.
	
	NSArray *Templatepaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *TemplatedocumentsDirectory = [Templatepaths objectAtIndex:0];
	NSString *Templateresult = [TemplatedocumentsDirectory stringByAppendingString:@"/Chemistry_Data_bak.xml"];
	
	NSError* error;
	NSString* fileContents = [NSString stringWithContentsOfFile:Templateresult encoding:NSWindowsCP1252StringEncoding error:&error];
	
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"±"]];
	
	for(int idx = 0; idx < pointStrings.count; idx++)
	{
		NSString* currentPointString = [pointStrings objectAtIndex:idx];
		NSArray* arr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
		NSMutableString *QTDescription = [[NSMutableString alloc] initWithFormat:@"%@",[arr objectAtIndex:1]];
		NSString *Question = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:13]];
		
	UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,768,550)];
	
	NSMutableString *HTMLString =[[NSMutableString alloc]initWithString:@"<html><body><p>"];
	[HTMLString appendString:QTDescription];
	[HTMLString appendString:@"</p></body></html>"];
						  
	[webview loadHTMLString:HTMLString baseURL:nil];
	
	
		NSString *DestFileName = [NSString stringWithFormat:@"%@/%@",TemplatedocumentsDirectory,Question];
		CGRect mediaBox = webview.bounds;     //CGRectMake(0, 0, 768, 550);
		CGContextRef ctx = CGPDFContextCreateWithURL((CFURLRef)[NSURL fileURLWithPath:DestFileName isDirectory:NO],&mediaBox,NULL);
		CGPDFContextBeginPage(ctx, NULL);
		//CGContextScaleCTM(ctx, 1, -1);
		//CGContextTranslateCTM(ctx, 0, -mediaBox.size.height);
		
		//CALayer *webViewLayer;
//		for (UIView *_subview in [[[webview subviews] objectAtIndex:0] subviews]) {  // Note comment this out if not apple will give you a slap
//			if ([_subview isKindOfClass:[UIWebDocumentView class]]) {
//				webViewLayer = [_subview layer];
//			}
//		}
		[webview.layer renderInContext:ctx];
		CGPDFContextEndPage(ctx);
		CFRelease(ctx);
		
		[QTDescription release];
		[HTMLString release];
		[Question release];
	}
	
}*/

void CreateMyPDFFile (CGRect pageRect, const char *filename,const char *picture,const char *text) {
	
	// This code block sets up our PDF Context so that we can draw to it
	CGContextRef pdfContext;
	CFStringRef path;
	CFURLRef url;
	CFMutableDictionaryRef myDictionary = NULL;
	// Create a CFString from the filename we provide to this method when we call it
	path = CFStringCreateWithCString (NULL, filename,
									  kCFStringEncodingUTF8);
	// Create a CFURL using the CFString we just defined
	url = CFURLCreateWithFileSystemPath (NULL, path,
										 kCFURLPOSIXPathStyle, 0);
	CFRelease (path);
	// This dictionary contains extra options mostly for 'signing' the PDF
	myDictionary = CFDictionaryCreateMutable(NULL, 0,
											 &kCFTypeDictionaryKeyCallBacks,
											 &kCFTypeDictionaryValueCallBacks);
	CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
	CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
	// Create our PDF Context with the CFURL, the CGRect we provide, and the above defined dictionary
	pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary);
	// Cleanup our mess
	CFRelease(myDictionary);
	CFRelease(url);
	// Done creating our PDF Context, now it's time to draw to it
	
	// Starts our first page
	CGContextBeginPage (pdfContext, &pageRect);
	
	// Draws a black rectangle around the page inset by 50 on all sides
	CGContextStrokeRect(pdfContext, CGRectMake(50, 50, pageRect.size.width - 100, pageRect.size.height - 100));
	
	// This code block will create an image that we then draw to the page
	//const char *picture = "Picture";
	if ( strcmp(picture, "1")  == 1) {
		
	
	CGImageRef image;
    CGDataProviderRef provider;
    CFStringRef picturePath;
    CFURLRef pictureURL;
	
    picturePath = CFStringCreateWithCString (NULL, picture,
											 kCFStringEncodingUTF8);
    pictureURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), picturePath, CFSTR("png"), NULL);
	CFRelease(picturePath);
    provider = CGDataProviderCreateWithURL (pictureURL);
    CFRelease (pictureURL);
    image = CGImageCreateWithPNGDataProvider (provider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease (provider);
    CGContextDrawImage (pdfContext, CGRectMake(200, 200, 207, 385),image);
    CGImageRelease (image);
	}
	// End image code
	
	// Adding some text on top of the image we just added
	CGContextSelectFont (pdfContext, "Helvetica", 16, kCGEncodingMacRoman);
	CGContextSetTextDrawingMode (pdfContext, kCGTextFill);
	CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
	//const char *text = "Hello World!";
	CGContextShowTextAtPoint (pdfContext, 60, 440, text, strlen(text));
	// End text
	
	// We are done drawing to this page, let's end it
	// We could add as many pages as we wanted using CGContextBeginPage/CGContextEndPage
	CGContextEndPage (pdfContext);
	
	// We are done with our context now, so we release it
	CGContextRelease (pdfContext);
}



-(IBAction)CreatePdfs:(id)sender{
	
	NSArray *Templatepaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *TemplatedocumentsDirectory = [Templatepaths objectAtIndex:0];
	NSString *Templateresult = [TemplatedocumentsDirectory stringByAppendingString:@"/Chemistry_Data.xml"];
	
	NSError* error;
	NSString* fileContents = [NSString stringWithContentsOfFile:Templateresult encoding:NSWindowsCP1252StringEncoding error:&error];
	
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"±"]];
	
	for(int idx = 0; idx < pointStrings.count -1; idx++)
	{
		NSString* currentPointString = [pointStrings objectAtIndex:idx];
		NSArray* arr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
		NSString *QText = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:49]];
		NSString *Question = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:13]];
		NSString *Picture = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:51]];
		
		NSString *DestFileName = [NSString stringWithFormat:@"%@/PDFResults/%@",TemplatedocumentsDirectory,Question];
		const char *Mfilename =[DestFileName UTF8String];
		
		const char *Mpicture =[Picture UTF8String];
		const char *Mtext = [QText UTF8String];
		CGRect mediaBox = CGRectMake(0, 0, 768, 550);
		
		
		CreateMyPDFFile(mediaBox,Mfilename,Mpicture,Mtext);
	
		[QText release];
		[Question release];
		[Picture release];
	}
}



- (void)webViewDidFinishLoad:(UIWebView *)webview {
	
	
	
	
}
	 

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	switch (indexPath.row) {
		case 0:
			;
			Topicbutton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			[Topicbutton setTitle:@"Topics" forState:UIControlStateNormal];
			Topicbutton.frame = CGRectMake(0, 0, 680, 45);
			[Topicbutton addTarget:self action:@selector(StartUpload:) forControlEvents:UIControlEventTouchUpInside];
			[Topicbutton setTag:indexPath.row];
			[cell.contentView addSubview:Topicbutton]; 
			break;
			
		case 1:
			;
			QuestionTemplatebutton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			[QuestionTemplatebutton setTitle:@"QuestionTemplate" forState:UIControlStateNormal];
			QuestionTemplatebutton.frame = CGRectMake(0, 0, 680, 45);
			[QuestionTemplatebutton addTarget:self action:@selector(StartUpload:) forControlEvents:UIControlEventTouchUpInside];
			[QuestionTemplatebutton setTag:indexPath.row];
			[cell.contentView addSubview:QuestionTemplatebutton];
			break;
			
		case 2:
			;
			Databutton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			[Databutton setTitle:@"Data" forState:UIControlStateNormal];
			Databutton.frame = CGRectMake(0, 0, 680, 45);
			[Databutton addTarget:self action:@selector(StartUpload:) forControlEvents:UIControlEventTouchUpInside];
			[Databutton setTag:indexPath.row];
			[cell.contentView addSubview:Databutton]; 
			break;
		case 3:
			;
			VersionButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			[VersionButton setTitle:[NSString stringWithFormat:@"Version: %i",Version] forState:UIControlStateNormal];
			VersionButton.frame = CGRectMake(0, 0, 680, 45);
			[VersionButton addTarget:self action:@selector(ChangeVersionNumber:) forControlEvents:UIControlEventTouchUpInside];
			[VersionButton setTag:indexPath.row];
			[cell.contentView addSubview:VersionButton]; 
			break;
			
		case 4:
			;
			PdfButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			[PdfButton setTitle:[NSString stringWithFormat:@"Create PDFs"] forState:UIControlStateNormal];
			PdfButton.frame = CGRectMake(0, 0, 680, 45);
			[PdfButton addTarget:self action:@selector(CreatePdfs:) forControlEvents:UIControlEventTouchUpInside];
			[PdfButton setTag:indexPath.row];
			[cell.contentView addSubview:PdfButton]; 
			break;
			
	}
    
    
	
	
    
    return cell;
}


#pragma mark -
#pragma mark Data Handling

// Get the ManagedObjectContext from my App Delegate
- (NSManagedObjectContext *)ManagedObjectContext {
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	return appDelegate.managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController_Topics {
	// Set up the fetched results controller if needed.
	if (fetchedResultsController_Topics == nil) {
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
		self.fetchedResultsController_Topics = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	
	return fetchedResultsController_Topics;
} 

- (NSFetchedResultsController *)fetchedResultsController_QT {
	// Set up the fetched results controller if needed.
	if (fetchedResultsController_QT == nil) {
		// Create the fetch request for the entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"lk_QuestionTemplate" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Description" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController_QT = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	
	return fetchedResultsController_QT;
} 


- (NSFetchedResultsController *)fetchedResultsController_Version {
	// Set up the fetched results controller if needed.
	if (fetchedResultsController_Version == nil) {
		// Create the fetch request for the entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"DBVersion" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"VersionNumber" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController_Version = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	
	return fetchedResultsController_Version;
} 



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	
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
    
	[fetchedResultsController_QT release];
	[fetchedResultsController_Topics release];
	[QTArray release];
	[TopArray release];
	[managedObjectContext release];
	[FileName release];
	[Topicbutton release];
	[QuestionTemplatebutton release];
	[Databutton release];
	[VersionButton release];
	[PdfButton release];
	[fetchedResultsController_Version release];
	//[VerNumber release];
    [super dealloc];
}


@end

