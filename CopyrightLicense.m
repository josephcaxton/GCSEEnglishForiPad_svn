//
//  CopyrightLicense.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 20/12/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "CopyrightLicense.h"


@implementation CopyrightLicense
@synthesize WebBox;

#pragma mark -
#pragma mark Initialization

#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950

- (void)viewDidLoad {
    [super viewDidLoad];

    self.WebBox = [[UIWebView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	self.WebBox.scalesPageToFit = YES;
	self.WebBox.delegate = self;
	
	
	[self loadDocument:@"copyrightlicense_agreement" inView:self.WebBox]; //copyrightlicense_agreement
	[self.view addSubview:WebBox];
	
}

-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView{
	
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
	
	
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
}

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ) {
		
		self.WebBox.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
		
		
		
	}
	
	else {
		
		self.WebBox.frame = CGRectMake(140, 0,  SCREEN_HEIGHT - 182, SCREEN_WIDTH);
		
		
		
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
    WebBox = nil;
	[super viewDidUnload];
}




@end

