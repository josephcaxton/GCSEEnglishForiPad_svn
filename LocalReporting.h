//
//  LocalReporting.h
//  Maths
//
//  Created by Joseph caxton-Idowu on 25/06/2013.
//  Copyright (c) 2013 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalReporting : UIViewController <CPTPlotDataSource, NSXMLParserDelegate>{
    
    CPTGraphHostingView *hostView;
    CPTTheme *selectedTheme;
    CPTXYGraph *graph;
    
    NSMutableArray *CollectionofArrays;
	NSString *FinalString;
    
    NSMutableArray *Totals;
    int MaxValueForYValue;
    
    NSDictionary *data;
    NSDictionary *sets;
    NSMutableArray *dates;
    NSMutableArray *DataDump;
    UIBarButtonItem *ClearLogs;
   
}
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;
@property (nonatomic, strong) CPTXYGraph *graph;

@property (nonatomic, retain) NSMutableArray *CollectionofArrays;
@property (nonatomic, retain) NSString *FinalString;

@property (nonatomic, retain) NSMutableArray *Totals;
@property (nonatomic, assign) int MaxValueForYValue;
@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, strong)  NSDictionary *sets;
@property (nonatomic, retain)  NSMutableArray *dates;
@property (nonatomic, retain) NSMutableArray *DataDump;
@property (nonatomic, retain)  UIBarButtonItem *ClearLogs;



//-(IBAction)themeTapped:(id)sender;
-(IBAction)ClearAllLogs:(id)sender;

-(void)loadDataFromXML:(NSString *)FileLocation;
-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configurePlots;



@end