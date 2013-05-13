//
//  lk_TopicsCell.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 29/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "lk_TopicsCell.h"


#pragma mark -
#pragma mark SubviewFrames category

@interface lk_TopicsCell (SubviewFrames)

- (CGRect)_descriptionLabelFrame;


@end

#pragma mark -
#pragma mark lk_TopicsCell implementation

@implementation lk_TopicsCell


@synthesize OneTopic, lblDescription;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
		[lblDescription setFont:[UIFont boldSystemFontOfSize:14.0]];
		[lblDescription setTextColor:[UIColor blackColor]];
		[lblDescription setHighlightedTextColor:[UIColor whiteColor]];
		[self.contentView addSubview:lblDescription];
		
    }
    return self;
}

#pragma mark -
#pragma mark Laying out subviews

- (void)layoutSubviews {
    [super layoutSubviews];
	
    [lblDescription setFrame:[self _descriptionLabelFrame]];
	
	
}

#define IMAGE_SIZE          0.0  //42.0
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



- (void)setOneTopic:(Topics *)newTopic {

	if (newTopic != OneTopic) {
		
		OneTopic = newTopic;
		
		
	} 
	lblDescription.text = OneTopic.TopicName;
	
}




@end
