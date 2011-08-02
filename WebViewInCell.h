//
//  WebViewInCell.h
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 08/03/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewInCell : UITableViewCell {

	NSString *HTMLText;
	//UIWebView *WebBox;
}

@property (nonatomic, retain) NSString *HTMLText;
//@property (nonatomic, retain) UIWebView *WebBox;
@end
