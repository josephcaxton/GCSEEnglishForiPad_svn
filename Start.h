//
//  Start.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 31/10/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerDataSource_Num_Questions.h"
#import "SelectDifficulty.h"
#import "SelectTopic.h"
#import "SelectQuestionTemplate.h"
#import "ClientEngine.h"

@interface Start : UIViewController  <UITableViewDataSource, UITableViewDelegate>{  //UIPickerViewDelegate, UIPickerViewDataSource
	
	UIView *FirstView;
	UIView *SecondView;
	UITableView *FirstTable;
	UITableView *SecondTable;
	
	UIPickerView *QuestionPickerView;
	CustomPickerDataSource_Num_Questions *CustomDataSource;
	
	UISwitch *Sound;
	UISwitch *ShowAnswers;
	
	UIImageView *logoView;
	UILabel *Copyright;
	UITextView *WebText;
	UIButton *StartPractice;
	UIButton *btnStartTest;
	
}

@property (nonatomic, retain) UIView *FirstView;
@property (nonatomic, retain) UIView *SecondView;
@property (nonatomic, retain) UITableView *FirstTable;
@property (nonatomic, retain) UITableView *SecondTable;
@property (nonatomic, retain) UIPickerView *QuestionPickerView;

@property (nonatomic, retain) CustomPickerDataSource_Num_Questions *CustomDataSource;
@property (nonatomic, retain) UISwitch *Sound;
@property (nonatomic, retain) UISwitch *ShowAnswers;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UILabel *Copyright;
@property (nonatomic, retain) UITextView *WebText;
@property (nonatomic, assign) UIButton *StartPractice;
@property (nonatomic, assign) UIButton *btnStartTest;

-(IBAction)Practice:(id)sender;
-(IBAction)StartTest:(id)sender;
-(void)PageButton:(int)sender;
@end
