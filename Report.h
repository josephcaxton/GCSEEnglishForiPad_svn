//
//  Report.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 23/11/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluatorAppDelegate.h"

@interface Report : UIViewController  <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>{

	
	
	//UIWebView *WebBox;
	NSMutableArray *CollectionofArrays;
    UIImageView *imageView;
	NSString *FinalString;
	UITableView *ThisTable;
	UIButton *Refresh;
}

//@property (nonatomic, retain) UIWebView *WebBox;
@property (nonatomic, retain) NSMutableArray *CollectionofArrays;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSString *FinalString;
@property (nonatomic, retain) UITableView *ThisTable;
@property (nonatomic, retain) UIButton *Refresh;

-(UIImage*)loadLink:(NSString*)linkAddress;
-(void)loadDataFromXML:(NSString *)FileLocation;
-(IBAction)ClearAllLogs:(id)sender;
-(IBAction)RefreshTable:(id)sender;
- (BOOL)isDataSourceAvailable;

@end
