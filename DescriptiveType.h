//
//  DescriptiveType.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 26/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lk_QuestionTemplate.h"
#import "Topics.h"
#import "QuestionItems.h"
#import "CheckExistingFiles.h"
#import <MessageUI/MessageUI.h>

@interface DescriptiveType : UIViewController <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>{
	
	lk_QuestionTemplate *QuestionTemplate;
	Topics  *SelectedTopic;

	//Question Header
	//UIWebView *QuestionHeaderBox;
	
	NSArray *fileList;
	
	NSString *DirLocation; // Location of Dir
	NSString *SFileName; // Short file name
	
	
	//NSString *DirLocation_Edit; // Location of Dir for edit
	NSString *SFileName_Edit; // Short file name for edit
	QuestionItems	*QItem_Edit;
	QuestionItems	*QItem_View;
	
	UITableView *FileListTable;
	NSMutableArray *AnswerObjects;
	UITextView *Answer1;
	UIButton  *ShowCorrectAnswer;
	//UIButton *newLine;
	
	BOOL ShowAnswer;
	UIButton *ShowAnswerHere;  // To show answer on question page
	UIButton *Continue;
	UIWebView *WebControl;
}

@property (nonatomic, retain) lk_QuestionTemplate *QuestionTemplate;
@property (nonatomic, retain) Topics  *SelectedTopic;

//@property (nonatomic, retain) UIWebView *QuestionHeaderBox;
@property (nonatomic, retain) NSArray *fileList;
@property (nonatomic, retain)  UITableView *FileListTable;

@property (nonatomic, retain) NSString *DirLocation;
@property (nonatomic, retain) NSString *SFileName;


//@property (nonatomic, retain) NSString *DirLocation_Edit;
@property (nonatomic, retain) NSString *SFileName_Edit;
@property (nonatomic, retain) QuestionItems	*QItem_Edit;
@property (nonatomic, retain) QuestionItems	*QItem_View;
@property (nonatomic, retain) NSMutableArray *AnswerObjects;
@property (nonatomic, retain) UITextView *Answer1;
@property (nonatomic, retain) UIButton  *ShowCorrectAnswer;
//@property (nonatomic, retain) UIButton *newLine;
@property (nonatomic, assign) BOOL ShowAnswer;
@property (nonatomic, retain) UIButton *ShowAnswerHere;
@property (nonatomic, retain) UIButton *Continue;
@property (nonatomic, retain) UIWebView *WebControl;

//-(void)CheckAppDirectory:(NSString *)Location;
//- (NSString *) getApplicationDirectory;
-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView;
-(IBAction)ShowCorrectAnswer:(id)sender;
//-(IBAction)AddNewLine:(id)sender;


@end
