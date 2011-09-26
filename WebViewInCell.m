//
//  WebViewInCell.m
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 08/03/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import "WebViewInCell.h"


@implementation WebViewInCell

@synthesize HTMLText;

static UIWebView *WebBox = nil;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
       WebBox = [[UIWebView alloc ] initWithFrame:CGRectMake(0, 0, 800, 80)];
		[WebBox	setBackgroundColor:[UIColor clearColor]];
		[WebBox setOpaque:NO];
        WebBox.dataDetectorTypes = 0; // This will remove the underlines i am experiencing
		WebBox.userInteractionEnabled = NO;  // This allow the cell to  
		//self.WebBox.scalesPageToFit = YES;
		[self.contentView addSubview:WebBox];
		WebBox.delegate = nil;
		[WebBox	 release];
	}
    return self;
}

- (void)setHTMLText:(NSString *)HtmlValue {
	
	if (HtmlValue != HTMLText) {
		[HTMLText release];
		HTMLText = [HtmlValue retain];
		
		
	} 
	[WebBox loadHTMLString:HTMLText baseURL:nil]; 
	
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	WebBox = nil;
}


- (void)dealloc {
	
	[HTMLText release];
    [super dealloc];
}


@end
