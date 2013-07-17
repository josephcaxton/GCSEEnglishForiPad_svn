//
//  LocalReporting.m
//  Maths
//
//  Created by Joseph caxton-Idowu on 25/06/2013.
//  Copyright (c) 2013 caxtonidowu. All rights reserved.
//

#import "LocalReporting.h"

@interface LocalReporting ()

@end

@implementation LocalReporting

@synthesize hostView = hostView_;
@synthesize selectedTheme = selectedTheme_;
@synthesize CollectionofArrays,FinalString,graph,MaxValueForYValue,Totals,data,sets,dates,DataDump,ClearLogs;
#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,185,55)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.navigationItem.title;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    self.navigationItem.titleView = label;
    [label sizeToFit];
    
    
    // Theme
	/*NSString *MyLCTheme = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"LCGraphTheme"];
	
	if (MyLCTheme == nil) {
		
		[[NSUserDefaults standardUserDefaults] setObject:kCPTStocksTheme forKey:@"LCGraphTheme"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        SelectedthemeName = kCPTStocksTheme;
	}
    else{
        
         SelectedthemeName = MyLCTheme;
    } */

	
    NSString *HeaderLocation = [[NSBundle mainBundle] pathForResource:@"header_bar" ofType:@"png"];
    UIImage *HeaderBackImage = [[UIImage alloc] initWithContentsOfFile:HeaderLocation];
    [self.navigationController.navigationBar setBackgroundImage:HeaderBackImage forBarMetrics:UIBarMetricsDefault];
    
    UIButton *Clearlogsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [Clearlogsbtn setBackgroundImage:[UIImage imageNamed:@"Clear40.png"] forState:UIControlStateNormal];
    [Clearlogsbtn addTarget:self action:@selector(ClearAllLogs:) forControlEvents:UIControlEventTouchUpInside];
    Clearlogsbtn.frame=CGRectMake(0.0, 0.0, 59.0, 40.0);
     ClearLogs = [[UIBarButtonItem alloc] initWithCustomView: Clearlogsbtn];
    
    
   // UIBarButtonItem *ClearLogs = [[UIBarButtonItem alloc] initWithTitle:@"Clear logs" style:UIBarButtonItemStylePlain target:self action:@selector(ClearAllLogs:)];
   

    /*UIBarButtonItem *ChangeTheme = [[UIBarButtonItem alloc] initWithTitle:@"Change Theme" style:UIBarButtonItemStylePlain target:self action:@selector(themeTapped:)];
    self.navigationItem.rightBarButtonItem = ClearLogs;
    self.navigationItem.leftBarButtonItem = ChangeTheme;*/
   

  }


-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
     self.navigationItem.rightBarButtonItem = ClearLogs;
    
    NSArray *Resultpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ResultdocumentsDirectory = [Resultpaths objectAtIndex:0];
    NSString *result = [ResultdocumentsDirectory stringByAppendingString:@"/Results.xml"];
    
    [self loadDataFromXML:result];
    
    NSString *CorrectValues =  @"";
    NSString *WrongValues = @"";
    
    
    if ([CollectionofArrays count] > 0) {
        
        Totals =[[NSMutableArray alloc]init];
        
        //Due to screen limitation we need to produce graph max 28 results
        if ([CollectionofArrays count] > 21) {
            
            int removeAmount = [CollectionofArrays count] - 21;
            for (int i = 0; i < removeAmount; i++) {
                [CollectionofArrays removeObjectAtIndex:0]; // I am using 0 here because MutableArray reindexes after removing.
            }
            
        }
        
        for (NSArray *arr in CollectionofArrays) {
            
            CorrectValues = [CorrectValues stringByAppendingString:[NSString stringWithFormat:@"%@,",[arr objectAtIndex:0]]];
            WrongValues = [WrongValues stringByAppendingString:[NSString stringWithFormat:@"%@,",[arr objectAtIndex:1]]];
            // Add the values to and put into array
            NSString *Val1 = [arr objectAtIndex:0];
            NSString *Val2 = [arr objectAtIndex:1];
            int TotalTemp = [Val1 intValue] + [Val2 intValue];
            //NSLog(@"Correct Total = %i ",TotalTemp );
            NSNumber *Number = [NSNumber numberWithInt:TotalTemp];
            [Totals addObject:Number];
            
            
        }

        
        //Check for the maximum Correct + Wrong to determine the max for the y axis.
        MaxValueForYValue = [[Totals valueForKeyPath:@"@max.intValue"]intValue];
        [self generateData];
          [self initPlot];
    }
    
        else {
			
			NSString *message = [[NSString alloc] initWithFormat:@"All logs are now cleared"];
			
			UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"You have no results"
														   message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[alert show];
			 self.navigationItem.rightBarButtonItem = nil;
			
		}
    }

- (void)generateData
{
    NSMutableDictionary *dataTemp = [[NSMutableDictionary alloc] init];
    
    //Array containing all the dates that will be displayed on the X axis
    dates = [[NSMutableArray alloc]init];
    for (NSArray *arrayset in CollectionofArrays){
       
            NSString* TempDate = [arrayset objectAtIndex:2];
        
            [dates addObject:TempDate];
        
    }
    
    // Generate all the Correct and Wrong Answers data
    DataDump = [[NSMutableArray alloc] init];
     for (NSArray *arrayset in CollectionofArrays){
         
          NSString* TempDataCorrect = [arrayset objectAtIndex:0];
          NSString* TempDataWrong = [arrayset objectAtIndex:1];
         
         [DataDump addObject:TempDataCorrect];
         [DataDump addObject:TempDataWrong];
         
     }


    
    //Dictionary containing the name of the two sets and their associated color
    sets = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], @"Correct Answers",
            [UIColor redColor], @"Wrong Answers",nil];
    
    //Generate data for each set of data that will be displayed for each day
    // NSLog(@"%@", CollectionofArrays);
    
    int Counter = 0;
        for (NSString *date in dates) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *set in sets) {
             NSNumber *num = [DataDump objectAtIndex:Counter];
            [dict setObject:num forKey:set];
            Counter = Counter + 1;
            }
        [dataTemp setObject:dict forKey:date];
        // NSLog(@"%@", dataTemp);
        }
    
    
        // NSLog(@"%@", dataTemp);
   
    
    data = [dataTemp copy];
   
    
   //NSLog(@"%@", data);
}
    
-(void)loadDataFromXML:(NSString *)FileLocation {
	
	NSString* path = FileLocation;
	
	
	
	NSData* datacontent = [NSData dataWithContentsOfFile: path];
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData: datacontent];
	
	
	[parser setDelegate:self];
	
	[parser parse];
	
	
	
	
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	
	
	CollectionofArrays = [[NSMutableArray alloc]init];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	//NSLog(@"%@", elementName);
	
	if ([elementName isEqualToString:@"Result"]) {
		
		
		NSString* Total = [attributeDict valueForKey:@"Total"];
		NSString* Correct = [attributeDict valueForKey:@"Award"];
		NSString* Date = [attributeDict valueForKey:@"Date"];
        
		NSString* Wrong = [NSString stringWithFormat:@"%i",[Total intValue] - [Correct intValue]];
		
		
		NSArray *A = [[NSArray alloc] initWithObjects:Correct,Wrong,Date,nil];
		[CollectionofArrays addObject:A];
        
        //[A release];
		
	}
	
	
	
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//the parser found some characters inbetween an opening and closing tag
	//what are you going to do?
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
    //	NSLog(@"%@", elementName);
	
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//the parser finished. what are you going to do?
}



-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    
}



-(void)configureHost {
    
    CGRect parentRect = self.view.bounds;
    
    //CGSize toolbarSize = self.navigationController.toolbar.bounds.size;
    parentRect = CGRectMake(parentRect.origin.x,
                            parentRect.origin.y,
                            parentRect.size.width,
                            parentRect.size.height);
    // 2 - Create host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = YES;
    self.hostView.autoresizingMask = YES;
    [self.view addSubview:self.hostView];
    
}

-(void)configureGraph {
    
    graph                               = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    [graph applyTheme:[CPTTheme themeNamed:kCPTStocksTheme]];
   // NSLog(@"%@", SelectedthemeName);
    self.hostView.hostedGraph                    = graph;
    graph.plotAreaFrame.masksToBorder   = NO;
    graph.paddingLeft                   = 0.0f;
    graph.paddingTop                    = 0.0f;
    graph.paddingRight                  = 0.0f;
    graph.paddingBottom                 = 0.0f;
    
    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor               = [CPTColor whiteColor];
    borderLineStyle.lineWidth               = 2.0f;
    graph.plotAreaFrame.borderLineStyle     = borderLineStyle;
    graph.plotAreaFrame.paddingTop          = 10.0;
    graph.plotAreaFrame.paddingRight        = 10.0;
    graph.plotAreaFrame.paddingBottom       = 80.0;
    graph.plotAreaFrame.paddingLeft         = 70.0;
    
   
    
} 

-(void)configurePlots {
    
    CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    //plotSpace.delegate              = self;
    plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0)
                                                                   length:CPTDecimalFromInt(MaxValueForYValue)];
    plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-1)
                                                                   length:CPTDecimalFromInt(8)]; //w
    plotSpace.allowsUserInteraction = YES;
    
    
    //Grid line styles
   CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth            = 0.75;
    majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth            = 0.25;
    minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    //Axises
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    //X axis
    CPTXYAxis *x                    = axisSet.xAxis;
    x.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
    x.majorIntervalLength           = CPTDecimalFromInt(1);
    x.minorTicksPerInterval         = 0;
    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
    x.majorGridLineStyle            = majorGridLineStyle;
    x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
    
    //Y axis
    NSNumberFormatter *yAxisFormat = [[NSNumberFormatter alloc] init];
    [yAxisFormat setNumberStyle:NSNumberFormatterNoStyle];

    CPTXYAxis *y            = axisSet.yAxis;
    y.title                 = @"Number of Questions";
    y.titleOffset           = 50.0f;
    y.labelingPolicy        = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle    = majorGridLineStyle;
    y.minorGridLineStyle    = minorGridLineStyle;
    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
    y.labelFormatter = yAxisFormat;
    
    //X labels
    int labelLocations = 0;
    NSMutableArray *customXLabels = [NSMutableArray array];
    for (NSString *day in dates) {
        // Reformat Date
        NSString* TempDate = day;
        NSRange rangeofemptystring = [TempDate rangeOfString:@" "];
        NSString* FinalDate = [TempDate substringWithRange:NSMakeRange(0, rangeofemptystring.location)];
        
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:FinalDate textStyle:x.labelTextStyle];
        newLabel.tickLocation   = [[NSNumber numberWithInt:labelLocations] decimalValue];
        newLabel.offset         = x.labelOffset + x.majorTickLength;
        newLabel.rotation       = M_PI / 4;
        [customXLabels addObject:newLabel];
        labelLocations++;
     
    }
    x.axisLabels                  = [NSSet setWithArray:customXLabels];
    
    //Create a bar line style
    CPTMutableLineStyle *barLineStyle   = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth              = 1.0;
    barLineStyle.lineColor              = [CPTColor whiteColor];
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
    whiteTextStyle.color                = [CPTColor whiteColor];
    
    //Plot
    BOOL firstPlot = YES;
    for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        CPTBarPlot *plot        = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.lineStyle          = barLineStyle;
        CGColorRef color        = ((UIColor *)[sets objectForKey:set]).CGColor;
        plot.fill               = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
        if (firstPlot) {
            plot.barBasesVary   = NO;
            firstPlot           = NO;
        } else {
            plot.barBasesVary   = YES;
        }
        plot.barWidth           = CPTDecimalFromFloat(0.8f); //w
        plot.barsAreHorizontal  = NO;
        plot.dataSource         = self;
        plot.identifier         = set;
        [graph addPlot:plot toPlotSpace:plotSpace];
        
    }
    
    //Add legend
    
    CPTLegend *theLegend      = [CPTLegend legendWithGraph:graph];
    theLegend.numberOfRows	  = sets.count;
    theLegend.fill	          = [CPTFill fillWithColor:[CPTColor colorWithGenericGray:0.15]];
    theLegend.borderLineStyle = barLineStyle;
    theLegend.cornerRadius	  = 10.0;
    theLegend.swatchSize	  = CGSizeMake(15.0, 15.0);
    whiteTextStyle.fontSize	  = 13.0;
    theLegend.textStyle	  = whiteTextStyle;
    theLegend.rowMargin	  = 5.0;
    theLegend.paddingLeft	  = 10.0;
    theLegend.paddingTop	  = 10.0;
    theLegend.paddingRight	  = 10.0;
    theLegend.paddingBottom	  = 10.0;
    graph.legend              = theLegend;
    graph.legendAnchor        = CPTRectAnchorTopLeft;
    graph.legendDisplacement  = CGPointMake(80.0, -10.0);
    
}


    
   


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
   return dates.count;
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    double num = NAN;
    
    //X Value
    if (fieldEnum == 0) {
        num = index;
    }
    
    else {
        double offset = 0;
        if (((CPTBarPlot *)plot).barBasesVary) {
            for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                if ([plot.identifier isEqual:set]) {
                    break;
                }
                offset += [[[data objectForKey:[dates objectAtIndex:index]] objectForKey:set] doubleValue];
            }
        }
        
        //Y Value
        if (fieldEnum == 1) {
            num = [[[data objectForKey:[dates objectAtIndex:index]] objectForKey:plot.identifier] doubleValue] + offset;
        }
        
        //Offset for stacked bar
        else {
            num = offset;
        }
    }
    
    return num;
}

/*-(IBAction)themeTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Apply a Theme" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:CPDThemeNameDarkGradient, CPDThemeNamePlainBlack, CPDThemeNamePlainWhite, CPDThemeNameSlate, CPDThemeNameStocks, nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}


#pragma mark - UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 1 - Get title of tapped button
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    // 2 - Get theme identifier based on user tap
    NSString *themeName = nil;
    if ([title isEqualToString:CPDThemeNameDarkGradient] == YES) {
        themeName = kCPTDarkGradientTheme;
    } else if ([title isEqualToString:CPDThemeNamePlainBlack] == YES) {
        themeName = kCPTPlainBlackTheme;
    } else if ([title isEqualToString:CPDThemeNamePlainWhite] == YES) {
        themeName = kCPTPlainWhiteTheme;
    } else if ([title isEqualToString:CPDThemeNameSlate] == YES) {
        themeName = kCPTSlateTheme;
    } else if ([title isEqualToString:CPDThemeNameStocks] == YES) {
        themeName = kCPTStocksTheme;
    }
    
    SelectedthemeName = themeName;
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:@"LCGraphTheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 3 - Apply new theme
    [self.hostView.hostedGraph applyTheme:[CPTTheme themeNamed:themeName]];
    //NSLog(@"%@", SelectedthemeName);

   
   
   //	[self initPlot];
} */


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait  || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
      
	  //hostView.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 40.0);
        
        //Lock the orinetation to avoid problems
       
	}
	
	else {
		
       
		
        //hostView.frame  = CGRectMake(0, 120, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
    }

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return  true;
	
	
}

-(IBAction)ClearAllLogs:(id)sender{
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *ResultsXMLDestination = [documentsDir stringByAppendingPathComponent:@"Results.xml"];
	
	NSString *ResultsXML = [[NSBundle mainBundle] pathForResource:@"Results" ofType:@"xml"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error=[[NSError alloc]init] ;
	
	BOOL success=[fileManager fileExistsAtPath:ResultsXMLDestination];
	
	
	if(success)
	{
		[fileManager removeItemAtPath:ResultsXMLDestination error:&error];
		
		success=[fileManager copyItemAtPath:ResultsXML toPath:ResultsXMLDestination error:&error];
		
		if(!success){
			
			NSAssert1(0,@"failed to create database with message '%@'.",[error localizedDescription]);
		}
		else {
			//self.view = nil;
			[self viewWillAppear:YES];
			[CollectionofArrays removeAllObjects];
            [self removeGraph];
			//[ThisTable reloadData];
			
		}
        
	}
	
	
	
}

-(void)removePlot
{
    for(CPTPlot* plot in [graph allPlots])
    {
        plot.dataSource = nil;
        plot.delegate = nil;
        [plot deleteDataInIndexRange:NSMakeRange(0, plot.cachedDataCount)];
        [graph removePlot:plot];
    }
}

-(void)removeGraph
{
   // [axisSet removeFromSuperlayer];
    //axisSet=nil;
    [self removePlot];
   // generationPlot=nil;
    //[graph removePlotSpace:plotSpace];
    //plotSpace=nil;
    [graph removeFromSuperlayer];
    graph=nil;
    [hostView removeFromSuperview];
    hostView=nil;
    //headerList=nil;
    //graphDetailList=nil;
    //graphList=nil;
    //dataList=nil;
    //plotsArray=nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
