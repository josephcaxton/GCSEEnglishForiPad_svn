//
//  LearnersCloudSamplesVideos.h
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 21/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluatorAppDelegate.h"

@interface LearnersCloudSamplesVideos : UITableViewController <UIWebViewDelegate>{

	NSMutableArray *listofItems;
	UIWebView *WebText;
	NSMutableArray *ImageNames;
}

@property (nonatomic, retain) NSMutableArray *listofItems;
@property (nonatomic, retain) UIWebView *WebText;
@property (nonatomic, retain) NSMutableArray *ImageNames;

@end
