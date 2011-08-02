    //
//  LearnersCloudSamplesVideos.m
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 21/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import "LearnersCloudSamplesVideos.h"
#import "VideoPlayer.h"

@implementation LearnersCloudSamplesVideos

@synthesize listofItems,WebText,ImageNames;

//static MPMoviePlayerController *moviePlayerController = nil; 

//- (id) initWithCoder: (NSCoder *) coder {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
  //  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
   // }
 //   return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.title = @"GCSE Sample Videos";
	listofItems = [[NSMutableArray alloc] init];
	ImageNames = [[NSMutableArray alloc] init];
	// Add items to the array this is hardcoded for now .. may need to be migrated to the database
	[listofItems addObject:@"Maths"];
	[ImageNames addObject:@"Maths.png"];
	[listofItems addObject:@"  English"];
	[ImageNames addObject:@"English.png"];
	[listofItems addObject:@" Physics"];
	[ImageNames addObject:@"Physics.png"];
	[listofItems addObject:@" Chemistry"];
	[ImageNames addObject:@"Chemistry.png"];
//	[listofItems addObject:@"French"];
//	[ImageNames addObject:@"French.png"];
//	[listofItems addObject:@"Batteries"];
//	[ImageNames addObject:@"Batteries.png"];
//	[listofItems addObject:@"The Ruined Maid"];
//	[ImageNames addObject:@"Ruined_maid.png"];
//	[listofItems addObject:@"Les Grand Seigneurs"];
//	[ImageNames addObject:@"LesGrandSeignors.png"];
//	[listofItems addObject:@"Horse Whisperer"];
//	[ImageNames addObject:@"HorseWhisperer.png"];
//	[listofItems addObject:@"Hunchback in the Park"];
//	[ImageNames addObject:@"Hunchback.png"];
//	[listofItems addObject:@"The Clown Punk"];
//	[ImageNames addObject:@"ClownPunk.png"];
//	[listofItems addObject:@"Concave Convex Rap"];
//	[ImageNames addObject:@"Convexrap.png"];
	
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
	//[self.tableView reloadData];
	
	//UIActivityIndicatorView *Activity =(UIActivityIndicatorView *)[self.tabBarController.view viewWithTag:1];
//	[Activity removeFromSuperview];
//	
//	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
//	[appDelegate.SecondThread cancel];
//	[appDelegate.SecondThread release];
//	appDelegate.SecondThread = nil;
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title=@""; 
	
	
		return title; 
	
	
	
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		
		return [listofItems count];
	}
	else {
		return 1;
	}

    
	
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//		
//			return 50;
//	}
//		
//		else {
//			return 70;		}
//		
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
    
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
		
	
    // Configure the cell...
    
    NSString *cellValue = [[NSString alloc] initWithFormat:@"%@",[listofItems objectAtIndex:indexPath.row]];
	NSString *PicLocation = [[NSString alloc] initWithFormat:@"%@",[ImageNames objectAtIndex:indexPath.row]];
	cell.textLabel.text = cellValue;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	// Just want to show the thumbnail image
	//NSString *filepath   =   [[NSBundle mainBundle] pathForResource:cellValue ofType:@"m4v"];
//	NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath]; 
//	moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
//	 
//	UIImage* theImage = [moviePlayerController thumbnailImageAtTime:8 timeOption:MPMovieTimeOptionNearestKeyFrame];	
		UIImage* theImage = [UIImage imageNamed:PicLocation];
		cell.imageView.image = theImage;
		
		//[moviePlayerController pause];
//		moviePlayerController.initialPlaybackTime = -1.0;
//	[moviePlayerController stop];
//	[moviePlayerController release];
//	moviePlayerController = nil;
		
	[PicLocation release];		
	[cellValue release];
	
		
	}
	
	else if (indexPath.section == 1){
	
		if (!WebText) {
			
			WebText =[[UITextView alloc] initWithFrame:CGRectMake(250,0,480,40)]; 
		}
		
		
		WebText.editable = NO;
		WebText.backgroundColor = [UIColor clearColor];
		WebText.dataDetectorTypes = UIDataDetectorTypeLink;
		NSString *Visit = @"Visit ";
		NSString *Website =[Visit stringByAppendingString: @"http://www.LearnersCloud.com "];
		NSString *videos = [Website stringByAppendingString:@"for more videos"];
		
		WebText.text =videos;
		WebText.font= [UIFont systemFontOfSize:16.0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.imageView.image = nil;
		[cell addSubview:WebText];
		
		[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
	}

	
	return cell;
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
	
	switch (index) {
			
		case 0:
			;
			VideoPlayer *VP1 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
			VP1.VideoFileName =[NSString stringWithString:@"Maths"];
			[self.navigationController pushViewController:VP1 animated:YES];
			[VP1 release];
			break;
			
		case 1:
			;
			VideoPlayer *VP2 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
			VP2.VideoFileName =[NSString stringWithString:@"English"];
			[self.navigationController pushViewController:VP2 animated:YES];
			[VP2 release];
			break;
			
		case 2:
			;
			
			VideoPlayer *VP3 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
			VP3.VideoFileName =[NSString stringWithString:@"Physics"];
			[self.navigationController pushViewController:VP3 animated:YES];
			[VP3 release];
			
			
			
			break; 
			
		case 3:
			;
			VideoPlayer *VP4 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
			VP4.VideoFileName =[NSString stringWithString:@"Chemistry"];
			[self.navigationController pushViewController:VP4 animated:YES];
			[VP4 release];
			
			
			
			break;
			
//		case 4:
//			;
//			VideoPlayer *VP5 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
//			VP5.VideoFileName =[NSString stringWithString:@"French"];
//			[self.navigationController pushViewController:VP5 animated:YES];
//			[VP5 release];
//			
//			
//			
//			break;
//			
//			
//		case 5:
//			;
//			VideoPlayer *VP6 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
//			VP6.VideoFileName =[NSString stringWithString:@"Batteries"];
//			[self.navigationController pushViewController:VP6 animated:YES];
//			[VP6 release];
//			
//			
//			
//			break;
//			
//		case 6:
//			;
//			VideoPlayer *VP7 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
//			VP7.VideoFileName =[NSString stringWithString:@"Ruined_maid"];
//			[self.navigationController pushViewController:VP7 animated:YES];
//			[VP7 release];
//			
//			
//			
//			break;
//			
//		case 7:
//			;
//			VideoPlayer *VP8 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
//			VP8.VideoFileName =[NSString stringWithString:@"LesGrandSeignors"];
//			[self.navigationController pushViewController:VP8 animated:YES];
//			[VP8 release];
//			
//			
//			
//			break;
//			
//		case 8:
//			;
//			VideoPlayer *VP9 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
//			VP9.VideoFileName =[NSString stringWithString:@"HorseWhisperer"];
//			[self.navigationController pushViewController:VP9 animated:YES];
//			[VP9 release];
//			
//			
//			
//			break;
//			
//		case 9:
//			;
//			VideoPlayer *VP10 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
//			VP10.VideoFileName =[NSString stringWithString:@"Hunchback"];
//			[self.navigationController pushViewController:VP10 animated:YES];
//			[VP10 release];
//			
//			
//			
//			break;
//		case 10:
//			;
//			VideoPlayer *VP11 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
//			VP11.VideoFileName =[NSString stringWithString:@"ClownPunk"];
//			[self.navigationController pushViewController:VP11 animated:YES];
//			[VP11 release];
//			
//			
//			
//			break;
//		case 11:
//			;
//			VideoPlayer *VP12 = [[VideoPlayer	alloc] initWithNibName:nil bundle:nil];
//			VP12.VideoFileName =[NSString stringWithString:@"Convexrap"];
//			[self.navigationController pushViewController:VP12 animated:YES];
//			[VP12 release];
//			
//			
//			
//			break;
	}
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ) {
		
		WebText.frame = CGRectMake(250,0,480,40);
		
	}
	
	else {
		
		WebText.frame = CGRectMake(350,0,480,40);
		
		
	}
	
	
	
	
	
}

#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[listofItems release];
	[ImageNames release];
	[WebText release];
    [super dealloc];
}


@end
