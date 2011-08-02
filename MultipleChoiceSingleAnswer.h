//
//  MultipleChoiceSingleAnswer.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 28/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lk_QuestionTemplate.h"
#import "Topics.h"
#import "MultipleChoiceSingleAnswer1.h"
#import "EvaluatorAppDelegate.h"
#import "CheckExistingFiles.h"
#import <MessageUI/MessageUI.h>
#import "WebViewInCell.h"

@interface MultipleChoiceSingleAnswer :  UIViewController <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate> {
	
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
	QuestionItems	*QItem_View;
	
	UITableView *FileListTable;
	
	//Question Item
	//UIWebView *QuestionItemBox;
	
	//UISearchBar *Search;
	
	
	
	NSMutableArray *AnswerObjects;
	NSMutableArray *CorrectAnswers;
	
	NSMutableArray *MultichoiceAnswers;
	NSMutableArray *SelectedAnswers;
	NSMutableArray *AnswerCounter;
	BOOL ShowAnswer;
	UIButton *Continue;
	NSMutableArray *HighlightedAnswers;

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
@property (nonatomic, retain) NSMutableArray *CorrectAnswers;
@property (nonatomic, retain) NSMutableArray *MultichoiceAnswers;
@property (nonatomic, retain) NSMutableArray *SelectedAnswers;
@property (nonatomic, retain) NSMutableArray *AnswerCounter;
@property (nonatomic, assign) BOOL ShowAnswer;
@property (nonatomic, retain) UIButton *Continue;
@property (nonatomic, retain) NSMutableArray *HighlightedAnswers;

//@property (nonatomic, retain) IBOutlet UIWebView *QuestionItemBox;
//@property (nonatomic, retain) IBOutlet UISearchBar *Search;

//-(void)CheckAppDirectory:(NSString *)Location;
//- (NSString *) getApplicationDirectory;
-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView;
-(IBAction)ContinueToNextQuestion:(id)sender;
- (void)configureCell:(WebViewInCell *)mycell HTMLStr:(NSString *)value;

@end





