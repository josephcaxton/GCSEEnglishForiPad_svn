//
//  Buy.m
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 15/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import "Buy.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@implementation Buy

@synthesize ProductFromIstore,ProductsToIstore,ProductsToIStoreInArray,SortedDisplayProducts,observer,Restore,pass;

int dontShowPriceList = 0;
#pragma mark -
#pragma mark Initialization


- (void) requestProductData
{
	[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
	
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithArray:ProductsToIStoreInArray]];
	request.delegate = self;
	[request start];
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	
	ProductFromIstore = response.products;
	
	
	
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
												  ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	
	SortedDisplayProducts = [ProductFromIstore sortedArrayUsingDescriptors:sortDescriptors]; 
	
	
	
	
	
	[self.tableView reloadData];
	
	[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
	
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *HeaderLocation = [[NSBundle mainBundle] pathForResource:@"header_bar" ofType:@"png"];
    UIImage *HeaderBackImage = [[UIImage alloc] initWithContentsOfFile:HeaderLocation];
    [self.navigationController.navigationBar setBackgroundImage:HeaderBackImage forBarMetrics:UIBarMetricsDefault];
  
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,185,55)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.navigationItem.title;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    self.navigationItem.titleView = label;
    [label sizeToFit];
  
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnLink:)];
    [label setUserInteractionEnabled:YES];
    [label addGestureRecognizer:gesture];

    
	
    observer = [[CustomStoreObserver alloc] init];
    dontShowPriceList = 0;
    

	
    
}
- (void)userTappedOnLink: (UITapGestureRecognizer *)recognizer
{
    
    static NSUInteger numberOfTaps = 0;
    
    if([recognizer state] == UIGestureRecognizerStateEnded){
        
        if(numberOfTaps == 2){
            
            numberOfTaps = 0;
            
            NSString *myTitle = @"Password";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:myTitle message:@"\n \n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            
            
            pass = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 60.0, 260.0, 30.0)];
            pass.placeholder = @"Password";
            
            [pass setBackgroundColor:[UIColor whiteColor]];
            pass.enablesReturnKeyAutomatically = YES;
            [pass setReturnKeyType:UIReturnKeyDone];
            [pass setDelegate:self];
            [alertView addSubview:pass];
            
            [alertView show];
            
        }
        
        numberOfTaps ++;
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1){
        
        if([[pass.text lowercaseString] isEqualToString:@"1ravenroade181hb"]){
            
            //NSLog(@"Pass");
            [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:@"AccessLevel"]; //For testing only
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }
    
}


- (void)AddProgress{
	
	
	UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicator stopAnimating];
	[activityIndicator hidesWhenStopped];
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[self navigationItem].rightBarButtonItem = barButton;
	
	
	
	
	
}

- (BOOL)isDataSourceAvailable{
    static BOOL checkNetwork = YES;
	BOOL _isDataSourceAvailable;
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
		// checkNetwork = NO; don't cache
		
        Boolean success;    
        const char *host_name = "www.apple.com"; // my data source host name
		
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    return _isDataSourceAvailable;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self AddProgress] ;
	
	if ([SKPaymentQueue canMakePayments] == YES && [self isDataSourceAvailable] == YES){
		
		NSString *path=@"";
		
		NSString *AccessLevel = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessLevel"];
		
		if([AccessLevel intValue] == 1){
			
			path = [[NSBundle mainBundle] pathForResource:@"FromFree" ofType:@"plist"];
			
		}
		else if ([AccessLevel intValue] == 2){
			
			path = [[NSBundle mainBundle] pathForResource:@"From250" ofType:@"plist"];
			
		}
		/*else if ([AccessLevel intValue] == 3){
			
			path = [[NSBundle mainBundle] pathForResource:@"From500" ofType:@"plist"];
			
		}
		else if ([AccessLevel intValue] == 4){
			
			path = [[NSBundle mainBundle] pathForResource:@"From750" ofType:@"plist"];
			
		}*/
		
		
		if ([AccessLevel intValue] >  2 ){

			UIAlertView *Alert = [[UIAlertView alloc] initWithTitle: @"You already have all our products" 
															message: @"Press the Questions button to start" delegate: self 
												  cancelButtonTitle: @"OK" otherButtonTitles: nil];
			
			[Alert show];
			
			
			
			dontShowPriceList = 1;
			[self.tableView reloadData];
			
		}
		else {
			NSMutableDictionary *ProductsFromConfig = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
			
			ProductsToIstore = [[NSMutableArray alloc]init];
			
			
			for (id key in ProductsFromConfig){
				
				
				[ProductsToIstore addObject:[ProductsFromConfig objectForKey:key]];
				
			}
			
			ProductsToIStoreInArray = ProductsToIstore;
			
			
			[self requestProductData];
			
			
		}
	}
		else {
		
		UIAlertView *Alert = [[UIAlertView alloc] initWithTitle: @"Cannot use In App purchase" 
														message: @"In-App purchase has been disabled or internet connection is unavailable, please enable" delegate: self 
											  cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[Alert show];
		
		
		
	}
	
	
	
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [SortedDisplayProducts count] + 1;
	
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (dontShowPriceList == 1) {
		
		if ([cell.contentView subviews]){
			for (UIView *subview in [cell.contentView subviews]) {
				[subview removeFromSuperview];
			}
		}
		cell.detailTextLabel.text =@"";
		cell.textLabel.text = @"";
	}
	else{
		
        if (indexPath.row ==  [SortedDisplayProducts count]){
            if(!Restore){
                Restore = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            Restore.frame = CGRectMake(600, 2, 105, 39);
            Restore.tag = indexPath.row + 1;
            UIImage *RestoreImage = [UIImage imageNamed:@"restore.png"];
            [Restore setBackgroundImage:RestoreImage forState:UIControlStateNormal];
            [Restore addTarget:self action:@selector(BuyQuestion:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:Restore];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Restore Purchases";
            cell.detailTextLabel.text = @"0.00";
            
        }
        else{
            
            if ([SortedDisplayProducts count] > 0){

		  
	SKProduct *product = [SortedDisplayProducts objectAtIndex:indexPath.row];
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:product.priceLocale];
	
	UIButton *BuyNow = [UIButton buttonWithType:UIButtonTypeCustom]; 
	
	//[BuyNow setTitle:@"                   >"  forState:UIControlStateNormal];
	BuyNow.frame = CGRectMake(600, 2, 100, 39);
	BuyNow.tag = indexPath.row + 1;
	[BuyNow addTarget:self action:@selector(BuyQuestion:) forControlEvents:UIControlEventTouchUpInside];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"buy_now.png"];
	//UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[BuyNow setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
	
	[cell.contentView addSubview:BuyNow];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.detailTextLabel.text = [numberFormatter stringFromNumber:product.price];
	cell.textLabel.text = [product localizedTitle];
	
	
		
            }
        
        }
    }
    
    return cell;
}


-(void) BuyQuestion: (id)sender{
	
	[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
	EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.buyScreen = self;
	
	NSString *AccessLevel = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessLevel"];
	
	int myTag = [sender tag];
	switch([AccessLevel intValue])
	{
		case 1:   
			
			switch (myTag) {
				case 1:
                {
					SKPayment *payment4 = [SKPayment paymentWithProductIdentifier:@"com.LearnersCloud.iEvaluatorForiPad.English.1040"];
					[[SKPaymentQueue defaultQueue] addPayment:payment4];
					break;
                }
					
				case 2:
                {
					[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
                    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
					break;
                }
				/*case 3:
                {
					SKPayment *payment3 = [SKPayment paymentWithProductIdentifier:@"com.LearnersCloud.iEvaluatorForiPad.English.750"];
					[[SKPaymentQueue defaultQueue] addPayment:payment3];

						break;
                }
				case 4:
                {
					SKPayment *payment4 = [SKPayment paymentWithProductIdentifier:@"com.LearnersCloud.iEvaluatorForiPad.English.1040"];
					[[SKPaymentQueue defaultQueue] addPayment:payment4];
					break;
                }
                case 5:
                {
					[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
                    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
					break;
                }*/
				
			}
			
			
		case 2: 
			
			switch (myTag) {
				case 1:
                {
					SKPayment *payment3 = [SKPayment paymentWithProductIdentifier:@"com.LearnersCloud.iEvaluatorForiPad.English.250To1040"];
					[[SKPaymentQueue defaultQueue] addPayment:payment3];
					
					break;
                }
				case 2:
                {
					[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
                    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
					break;
                }
				/*case 3:
                {
					SKPayment *payment3 = [SKPayment paymentWithProductIdentifier:@"com.LearnersCloud.iEvaluatorForiPad.English.250To1040"];
					[[SKPaymentQueue defaultQueue] addPayment:payment3];
					
					break;
                }
                case 4:
                {
					[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
                    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
					break;
                }*/
				
			}
						
		/*case 3:
			
			switch (myTag) {
				case 1:
                {
					SKPayment *payment1 = [SKPayment paymentWithProductIdentifier:@"com.LearnersCloud.iEvaluatorForiPad.English.500To750"];
					[[SKPaymentQueue defaultQueue] addPayment:payment1];
					
					break;
                }
				case 2:
                {
					SKPayment *payment2 = [SKPayment paymentWithProductIdentifier:@"com.LearnersCloud.iEvaluatorForiPad.English.500To1040"];
					[[SKPaymentQueue defaultQueue] addPayment:payment2];

					break;
                }
                case 3:
                {
					[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
                    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
					break;
                }
			}
			
		case 4:
			
			switch (myTag) {
				case 1:
                {
					SKPayment *payment1 = [SKPayment paymentWithProductIdentifier:@"com.LearnersCloud.iEvaluatorForiPad.English.750To1040"];
					[[SKPaymentQueue defaultQueue] addPayment:payment1];
					break;
                }
                case 2:
                {
					[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
                    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
					break;
                }
				
			}*/
	
	
	}
	
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

