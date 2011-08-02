    //
//  Report.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 23/11/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "Report.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


@implementation Report

@synthesize CollectionofArrays,ClearLog,imageView,FinalString,ThisTable,Refresh; //WebBox

#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950

//UIActivityIndicatorView *Activity;

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
		
		
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//[self AddProgress];
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	CGRect FirstViewframe = CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT);
	self.ThisTable = [[UITableView alloc] initWithFrame:FirstViewframe style:UITableViewStyleGrouped];
	
	ThisTable.delegate = self;
	ThisTable.dataSource = self;
	ThisTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
	
	[self.view addSubview:ThisTable];
	
	if ([self isDataSourceAvailable] == YES) {
		
		
		
		NSArray *Resultpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *ResultdocumentsDirectory = [Resultpaths objectAtIndex:0];
		NSString *result = [ResultdocumentsDirectory stringByAppendingString:@"/Results.xml"];
		
		[self loadDataFromXML:result];
		
		
		NSString *CorrectValues =  @"";
		NSString *WrongValues = @"";
		
		
		if ([CollectionofArrays count] > 0) {
			
            NSMutableArray *Totals =[[NSMutableArray alloc]init];
            
			//Due to screen limitation we need to produce graph max 28 results
			if ([CollectionofArrays count] > 21) {
				
				int removeAmount = [CollectionofArrays count] - 21;
				for (int i = 0; i < removeAmount; i++) {
					[CollectionofArrays removeObjectAtIndex:0]; // I am using 0 here because MutableArray reindexes after removing.
				}
				
				
			}
			
			for (NSArray *arr in CollectionofArrays) {
				
				CorrectValues = [CorrectValues stringByAppendingString:[NSString stringWithFormat:@"%@,",[arr objectAtIndex:0]]];
				WrongValues = [WrongValues stringByAppendingString:[NSString stringWithFormat:@"%@,",[arr objectAtIndex:1]]];
				// Add the values to and put into array
				NSString *Val1 = [arr objectAtIndex:0];
				NSString *Val2 = [arr objectAtIndex:1];
				int TotalTemp = [Val1 intValue] + [Val2 intValue];
				//NSLog(@"Correct Total = %i ",TotalTemp );
				NSNumber *Number = [NSNumber numberWithInt:TotalTemp];
				[Totals addObject:Number];
				
				
			}
			// this is just ot remove the last comma on the strings
			
			NSString *Correct = [CorrectValues substringToIndex:[CorrectValues length] - 1];
			NSString *Wrong = [WrongValues substringToIndex:[WrongValues length] - 1];
			
			//Check for the maximum Correct + Wrong to determine the max for the y axis.
			int MaxValue = [[Totals valueForKeyPath:@"@max.intValue"]intValue];
			[Totals release];
			
			NSString *SiteAddress = [NSString stringWithString:@"http://chart.apis.google.com/chart?"];
			NSString *PlusChartSize = [SiteAddress stringByAppendingString:@"chs=600x500&"];
			NSString *PlusChartType = [PlusChartSize stringByAppendingString:@"cht=bvs&"];
			NSString *PlusChartColor = [PlusChartType stringByAppendingString:@"chco=0000FF,FF0000&"];
			NSString *PlusVisibleAxis = [PlusChartColor stringByAppendingString:@"chxt=y&"];
			//NSString *PlusAxisRange = [PlusVisibleAxis stringByAppendingString:@"chxr=0,0,100&"];
			NSString *PlusAxisRange = [PlusVisibleAxis stringByAppendingString:[NSString stringWithFormat:@"chxr=0,0,%i&",MaxValue]];
			NSString *PlusLegend = [PlusAxisRange stringByAppendingString:@"chdl=Correct Answers|Wrong Answers&"];
			NSString *PlusSeriesColors = [PlusLegend stringByAppendingString:@"chco=0000FF,FF0000&"];
			NSString *PlusLegendPosition = [PlusSeriesColors stringByAppendingString:@"chdlp=b&chd=t:"];
			NSString *PlusCorrect = [PlusLegendPosition stringByAppendingString:Correct];
			NSString *PlusDivider =[PlusCorrect stringByAppendingString:@"|"];
			NSString *PlusWrong = [PlusDivider stringByAppendingString:Wrong];
			NSString *PlusScaling = [PlusWrong stringByAppendingString:[NSString stringWithFormat:@"&chds=0,%i",MaxValue]];
			
			FinalString = PlusScaling;
			[FinalString retain];
			
		}
		else {
			
			NSString *message = [[NSString alloc] initWithFormat:@"All logs are now cleared"];
			
			UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"You have no results"
														   message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[alert show];
			[message release];
			[alert release];
			[self.ThisTable reloadData];
		}
		
	}
	
	else {
		NSString *message = [[NSString alloc] initWithFormat:@"No internet connection"];
		
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"I cannot connect to the internet to run your results"
													   message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		[message release];
		[alert release];
	}
	
	
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	UIActivityIndicatorView *Activity =(UIActivityIndicatorView *)[self.tabBarController.view viewWithTag:1];
	[Activity removeFromSuperview];
	
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.SecondThread cancel];
	[appDelegate.SecondThread release];
	appDelegate.SecondThread = nil;
	
	
}



-(UIImage*)loadLink:(NSString*)linkAddress {
	
	//[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
	
	 //NSString *Str = @"http://chart.apis.google.com/chart?chs=450x150&cht=bvs&chd=t:100,12,10,8,13,14,12,12,43,23,54,32|100,5,7,6,9,1,32,56,78,43,24,65&chco=0000FF,FF0000&chxt=y&chxr=0,0,1000&chdl=Correct Answers|Wrong Answers&chco=0000FF,FF0000&chdlp=b";
		
	//NSLog(@"Addrerss is %@", linkAddress);
	NSString *path = [linkAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
	NSURL *url = [[NSURL alloc]initWithString:path];
	
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:imageData];

	

	//NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	//[WebBox loadRequest:request];
	
	[url release];
	//[request release];
	return image;
	
}




- (BOOL)isDataSourceAvailable{
    static BOOL checkNetwork = YES;
	BOOL _isDataSourceAvailable;
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
       // checkNetwork = NO; don't cache
		
        Boolean success;    
        const char *host_name = "http://chart.apis.google.com"; // my data source host name
		
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    return _isDataSourceAvailable;
}


-(IBAction)ClearAllLogs:(id)sender{
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *ResultsXMLDestination = [documentsDir stringByAppendingPathComponent:@"Results.xml"];
	
	NSString *ResultsXML = [[NSBundle mainBundle] pathForResource:@"Results" ofType:@"xml"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error=[[[NSError alloc]init] autorelease]; 
	
	BOOL success=[fileManager fileExistsAtPath:ResultsXMLDestination];
	
	
	if(success)
	{
		[fileManager removeItemAtPath:ResultsXMLDestination error:&error];
		
		success=[fileManager copyItemAtPath:ResultsXML toPath:ResultsXMLDestination error:&error];
		
		if(!success){
			
			NSAssert1(0,@"failed to create database with message '%@'.",[error localizedDescription]); 
		}
		else {
			//self.view = nil;
			//[self viewDidLoad];
			[CollectionofArrays removeAllObjects];
			[ThisTable reloadData];
			
		}

	}
	
	
	
}

-(IBAction)RefreshTable:(id)sender{
	
	[self viewDidLoad];
	

	
}

/*- (void)AddProgress{
	
	
	UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator stopAnimating];
	[activityIndicator hidesWhenStopped];
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[self navigationItem].rightBarButtonItem = barButton;
	[activityIndicator release];
	[barButton release];
	
	
	
}
*/


    

-(void)loadDataFromXML:(NSString *)FileLocation {
	
	NSString* path = FileLocation;
	
	
	
	NSData* data = [NSData dataWithContentsOfFile: path];
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
	
	
	[parser setDelegate:self];
	
	[parser parse];
	[parser release];
	
	
	
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	
	
	CollectionofArrays = [[NSMutableArray alloc]init];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {	
	
	//NSLog(@"%@", elementName);
	
	if ([elementName isEqualToString:@"Result"]) {
		
		
		NSString* Total = [attributeDict valueForKey:@"Total"];
		NSString* Correct = [attributeDict valueForKey:@"Award"];
		
	
		NSString* Wrong = [NSString stringWithFormat:@"%i",[Total intValue] - [Correct intValue]];
		
		
		NSArray *A = [[[NSArray alloc] initWithObjects:Correct,Wrong,nil]autorelease];
		[CollectionofArrays addObject:A];
		 
		 //[A release];
		
	}
	
	
	
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//the parser found some characters inbetween an opening and closing tag
	//what are you going to do?
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
//	NSLog(@"%@", elementName);
	
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//the parser finished. what are you going to do?
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	if (interfaceOrientation == UIInterfaceOrientationPortrait  || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		ThisTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
		
		CGRect CustomFrame = CGRectMake(50, 10, 670.0, 740.0);
		imageView.frame = CustomFrame;
		
		
		self.ClearLog.frame = CGRectMake(580,760,140,40);
		//self.Refresh.frame = CGRectMake(400,760,140,40);
			}
	
	else {
		
	  ThisTable.frame = CGRectMake(0, 0, SCREEN_HEIGHT + 80, SCREEN_WIDTH - 120);
		CGRect CustomFrame = CGRectMake(50, 10, 935.0, 740.0);
		imageView.frame = CustomFrame;
		
		
		self.ClearLog.frame = CGRectMake(780,760,140,40);
		//self.Refresh.frame = CGRectMake(600,760,140,40);
	}
	
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	
	return 1;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
		//if (indexPath.section ==0) {
			return SCREEN_HEIGHT - 140;
		//}
		//else {
		//	return 40;
		//}	
	
	
	
	
	
	
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	tableView.allowsSelection = NO;
	
	if (indexPath.row == 0){
	if ([CollectionofArrays count] > 0){
		
	
		imageView = [[UIImageView alloc] initWithImage:[self loadLink:FinalString]];
	
		[FinalString release];
		//[Activity stopAnimating];
		//[Activity release];
		//Activity = nil;
	//[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
	}
		else {
			
			NSString *FilePath = [[NSBundle mainBundle] pathForResource:@"Graph_Ipad" ofType:@"png"];
			UIImage *image =  [[UIImage alloc]initWithContentsOfFile:FilePath];
			imageView = [[UIImageView alloc] initWithImage:image];
			
			[image release];
			
			
		
		}

		
	//CGRect CustomFrame = CGRectMake(50, 10, 660.0, 740.0);

	//imageView.frame = CustomFrame;
		
		[cell addSubview:imageView];
	
	
		
		self.ClearLog = [UIButton buttonWithType:UIButtonTypeRoundedRect];   
		//self.ClearLog.frame = CGRectMake(580,760,140,40);
		[ClearLog setTitle:@"Clear Logs" forState:UIControlStateNormal];
		[ClearLog addTarget:self action:@selector(ClearAllLogs:) forControlEvents:UIControlEventTouchUpInside];
	
		[cell addSubview:ClearLog];
		
		
		//self.Refresh = [UIButton buttonWithType:UIButtonTypeRoundedRect];   
//		//self.Refresh.frame = CGRectMake(400,760,140,40);
//		[Refresh setTitle:@"Refresh" forState:UIControlStateNormal];
//		[Refresh addTarget:self action:@selector(RefreshTable:) forControlEvents:UIControlEventTouchUpInside];
//		
//		[cell addSubview:Refresh];
		
	
	
	cell.backgroundColor = [UIColor whiteColor];
		
	}
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];	
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	
}

/*- (UIImage*)PictureOrientation:(UIInterfaceOrientation)interfaceOrientation{
	
	if (interfaceOrientation == UIInterfaceOrientationPortrait  || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
			NSString *FilePath = [[NSBundle mainBundle] pathForResource:@"Graph_Ipad_Portrait" ofType:@"png"];
			UIImage *image = [[UIImage alloc]initWithContentsOfFile:FilePath];
			return image;

		}
		
		else {
			NSString *FilePath = [[NSBundle mainBundle] pathForResource:@"Graph_Ipad_LandScape" ofType:@"png"];
			UIImage *image = [[UIImage alloc]initWithContentsOfFile:FilePath];
			return image;
		}

	
	
}*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	imageView = nil;
}


- (void)dealloc {
	
	//WebBox = nil;
	//[WebBox release];
	[imageView release];
	[CollectionofArrays release];
	[ClearLog release];
	[ThisTable release];
	[FinalString release];
	
	[super dealloc];
	
    
}


@end
