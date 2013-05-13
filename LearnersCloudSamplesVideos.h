//
//  LearnersCloudSamplesVideos.h
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 21/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluatorAppDelegate.h"

@interface LearnersCloudSamplesVideos : UIViewController <UITableViewDataSource, UITableViewDelegate> {

	NSMutableArray *listofItems;
    NSMutableArray *ImageNames;
	UIButton *LCButton;
    UITableView *FirstTable;
    CGRect FirstViewframe;
    UIImageView *PromoImageView;
	
}

@property (nonatomic, retain) NSMutableArray *listofItems;
@property (nonatomic, retain) NSMutableArray *ImageNames;
@property (nonatomic, retain) UIButton *LCButton;
@property (nonatomic, retain) UITableView *FirstTable;
@property (nonatomic, assign)  CGRect FirstViewframe;
@property (nonatomic, retain)  UIImageView *PromoImageView;

- (void)WebsitebuttonPressed;

@end
