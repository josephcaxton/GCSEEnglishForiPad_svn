//
//  FillTheBlanks.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 30/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lk_QuestionTemplate.h"
#import "Topics.h"
#import "QuestionItems.h"
#import "FillTheBlanks1.h"
#import "EvaluatorAppDelegate.h"
#import "CheckExistingFiles.h"
#import "TrueOrFalseYesOrNo1.h"
#import <MessageUI/MessageUI.h>
#import "WebViewInCell.h"

@interface FillTheBlanks : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate>{
	
	lk_QuestionTemplate *QuestionTemplate;
	Topics  *SelectedTopic;
	
	//Question Header
	//UIWebView *QuestionHeaderBox;
	
	//UILabel *AuthorizeText;
	
	NSArray *fileList;
	
	
	NSString *DirLocation; // Location of Dir
	NSString *SFileName; // Short file name
	
	
	//NSString *DirLocation_Edit; // Location of Dir for edit
	NSString *SFileName_Edit; // Short file name for edit
	QuestionItems	*QItem_Edit;
	
	UITableView *FileListTable;
	
	QuestionItems	*QItem_View;
	
	NSMutableArray *AnswerObjects;
	
	UITextField *Answer1;
	UITextField *Answer2;
	UITextField *Answer3;
	UITextField *Answer4;
	UITextField *Answer5;
	
	NSArray *AnswerControls;
	BOOL ShowAnswer;
    BOOL RemoveContinueButton;
    BOOL Specialflag;
	UIBarButtonItem *Continue;

}
@property (nonatomic, retain) lk_QuestionTemplate *QuestionTemplate;
@property (nonatomic, retain) Topics  *SelectedTopic;

//@property (nonatomic, retain) UIWebView *QuestionHeaderBox;

//@property (nonatomic, retain) UILabel *AuthorizeText;
@property (nonatomic, retain) NSArray *fileList;
@property (nonatomic, retain)  UITableView *FileListTable;

@property (nonatomic, retain) NSString *DirLocation;
@property (nonatomic, retain) NSString *SFileName;

//@property (nonatomic, retain) NSString *DirLocation_Edit;
@property (nonatomic, retain) NSString *SFileName_Edit;
@property (nonatomic, retain) QuestionItems	*QItem_Edit;
@property (nonatomic, retain) QuestionItems	*QItem_View;
@property (nonatomic, retain) NSMutableArray *AnswerObjects;

@property (nonatomic, retain) UITextField   *Answer1;
@property (nonatomic, retain) UITextField	*Answer2;
@property (nonatomic, retain) UITextField	*Answer3;
@property (nonatomic, retain) UITextField	*Answer4;
@property (nonatomic, retain) UITextField	*Answer5;
@property (nonatomic, retain) NSArray *AnswerControls;
@property (nonatomic, assign) BOOL ShowAnswer;
@property (nonatomic, assign) BOOL RemoveContinueButton;
@property (nonatomic, assign) BOOL Specialflag;
@property (nonatomic, retain) UIBarButtonItem *Continue;

//@property (nonatomic, retain) IBOutlet UIWebView *QuestionItemBox;
//@property (nonatomic, retain) IBOutlet UISearchBar *Search;

-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView;
-(IBAction)ContinueToNextQuestion:(id)sender;
- (void)configureCell:(WebViewInCell *)mycell HTMLStr:(NSString *)value;
//- (void)AdjustScreenToSee:(int)value;

@end
