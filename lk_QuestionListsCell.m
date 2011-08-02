//
//  lk_QuestionListsCell.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 19/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "lk_QuestionListsCell.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface lk_QuestionListsCell (SubviewFrames)

- (CGRect)_descriptionLabelFrame;
- (CGRect)_logdateFrame;

@end

#pragma mark -
#pragma mark lk_QuestionListsCell implementation

@implementation lk_QuestionListsCell

@synthesize QuestionTemplate, lblDescription,lblLoggedDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
		lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
		[lblDescription setFont:[UIFont boldSystemFontOfSize:14.0]];
		[lblDescription setTextColor:[UIColor blackColor]];
		[lblDescription setHighlightedTextColor:[UIColor whiteColor]];
		[self.contentView addSubview:lblDescription];
		
		
		lblLoggedDate = [[UILabel alloc ] initWithFrame:CGRectZero];
		[lblLoggedDate setFont:[UIFont systemFontOfSize:12.0]];
		[lblLoggedDate setTextColor:[UIColor darkGrayColor]];
		[lblLoggedDate setHighlightedTextColor:[UIColor whiteColor]];
		[self.contentView addSubview:lblLoggedDate];
		
		
		
    }    return self;
}


#pragma mark -
#pragma mark Laying out subviews

- (void)layoutSubviews {
    [super layoutSubviews];
	
    [lblDescription setFrame:[self _descriptionLabelFrame]];
    [lblLoggedDate setFrame:[self _logdateFrame]];
}
#define IMAGE_SIZE          0.0 ///42.0
#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0
#define PREP_TIME_WIDTH     80.0

- (CGRect)_descriptionLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - PREP_TIME_WIDTH, 16.0);
    }
}

- (CGRect)_logdateFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_LEFT_MARGIN, 16.0);
    }
}



-(void)setQuestionTemplate:(lk_QuestionTemplate *)newQuestionTemplate{

    if (newQuestionTemplate != QuestionTemplate) {
		[QuestionTemplate release];
		QuestionTemplate = [newQuestionTemplate retain];
		
		
	} 
	lblDescription.text = QuestionTemplate.Description;
	
	//NSLog(@"%@ testing",lblDescription.text);
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
	lblLoggedDate.text =[dateFormat stringFromDate:QuestionTemplate.LoggedDate]; 
	//NSLog(@"%@",lblLoggedDate.text);
	
	[dateFormat release];
	
	

    // Configure the view for the selected state
}


- (void)dealloc {
	
	[QuestionTemplate release];
	[lblDescription release];
	[lblLoggedDate release];
    [super dealloc];
}


@end
