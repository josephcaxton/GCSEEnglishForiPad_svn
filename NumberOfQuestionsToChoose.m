//
//  NumberOfQuestionsToChoose.m
//  Biology
//
//  Created by Editor on 01/02/2014.
//  Copyright (c) 2014 LearnersCloud. All rights reserved.
//

#import "NumberOfQuestionsToChoose.h"

@implementation NumberOfQuestionsToChoose

- (id)initWithFrame:(CGRect)frame NoOfQuestions:(int) NumberofQ
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
        message.text = [NSString stringWithFormat:@"Choose %i answers", NumberofQ];
        message.font = [UIFont fontWithName:@"Helvetica" size:12];
        message.textColor =[UIColor whiteColor];
        [self addSubview:message];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
