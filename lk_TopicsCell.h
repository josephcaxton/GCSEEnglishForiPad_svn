//
//  lk_TopicsCell.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 29/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topics.h"





@interface lk_TopicsCell : UITableViewCell {
	
	Topics	*OneTopic;
	UILabel *lblDescription;

}

@property (nonatomic, retain) Topics *OneTopic;
@property (nonatomic, retain) UILabel *lblDescription;

@end
