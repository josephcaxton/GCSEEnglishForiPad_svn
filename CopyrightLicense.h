//
//  CopyrightLicense.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 20/12/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CopyrightLicense : UIViewController  <UIWebViewDelegate> {

	
	UIWebView *WebBox;
}

@property (nonatomic, retain) UIWebView *WebBox;
-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView;

@end
