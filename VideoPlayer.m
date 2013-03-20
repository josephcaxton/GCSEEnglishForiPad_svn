    //
//  VideoPlayer.m
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 21/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import "VideoPlayer.h"
#import "GANTracker.h"
#import "EvaluatorAppDelegate.h"


@implementation VideoPlayer

@synthesize VideoFileName,ServerLocation,credential,protectionSpace,moviePlayerViewController;

#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950



//Old code
/*- (void)moviePlaybackComplete:(NSNotification *)notification  {  
	
	moviePlayerController = [notification object];  
	[[NSNotificationCenter defaultCenter] removeObserver:self  
													name:MPMoviePlayerPlaybackDidFinishNotification  
												  object:moviePlayerController];  
	
	[moviePlayerController.view removeFromSuperview];  
	[moviePlayerController release]; 
	
	[self.navigationController popViewControllerAnimated:YES];
	
	
} */ 

- (void)movieFinishedCallback:(NSNotification*) notification  {  
	
    NSError *error;
    // Report to  analytics
    if (![[GANTracker sharedTracker] trackEvent:@"Finished playing video"
                                         action:@"Playing Finished"
                                          label:@"Playing Finished"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
    
    
    MPMoviePlayerController *player = [notification object];  
	[[NSNotificationCenter defaultCenter] removeObserver:self  
													name:MPMoviePlayerPlaybackDidFinishNotification  
												  object:player];  
	[player stop];
	[moviePlayerViewController.view removeFromSuperview];  
	
	
	[self.navigationController popViewControllerAnimated:YES];
	
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
}

-(void)viewWillAppear:(BOOL)animated{
	
    EvaluatorAppDelegate *appDelegate = (EvaluatorAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.isDeviceConnectedToInternet){
        
        NSError *error;
        // Report to  analytics
        if (![[GANTracker sharedTracker] trackPageview:@"/VideoPlayer"
                                             withError:&error]) {
            NSLog(@"error in trackPageview");
        }
        
        
        if([VideoFileName isEqualToString:@"Maths"]){
            
            ServerLocation = @"http://learnerscloud.com/iosStreamv2/maths/MathsTtrailerv6";
        }
        else if ([VideoFileName isEqualToString:@"English"]){
            
            ServerLocation = @"http://learnerscloud.com/iosStreamv2/english/EnglishTrailerv5";
            
        }
        else if ([VideoFileName isEqualToString:@"Physics"]){
            
            ServerLocation = @"http://learnerscloud.com/iosStreamv2/Physics/PhysicsTrailerV5";
            
        }
        else if ([VideoFileName isEqualToString:@"Chemistry"]){
            
            ServerLocation = @"http://learnerscloud.com/iosStreamv2/Chemistry/ChemistryPromoFINAL";
            
        }
        else if ([VideoFileName isEqualToString:@"Biology"]){
            
            ServerLocation = @"http://learnerscloud.com/iosStreamv2/Biology/BIO-Trailer";
            
        }
        
        
        //Authentication Details here
        
        NSURLCredential *credential1 = [[NSURLCredential alloc]
                                        initWithUser:@"iosuser"
                                        password:@"letmein2"
                                        persistence: NSURLCredentialPersistenceForSession];
        self.credential = credential1;
        
        NSString *DomainLocation = @"www.learnerscloud.com";
        
        NSURLProtectionSpace *protectionSpace1 = [[NSURLProtectionSpace alloc]
                                                  initWithHost: DomainLocation
                                                  port:443
                                                  protocol:@"https"
                                                  realm: DomainLocation
                                                  authenticationMethod:NSURLAuthenticationMethodDefault];
        self.protectionSpace = protectionSpace1;
        
        
        [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential
                                                            forProtectionSpace:protectionSpace];
        
        
        NSString *Finalpath = [ServerLocation stringByAppendingString:@"/all.m3u8"];
        
        NSURL    *fileURL =   [NSURL URLWithString:Finalpath];
        
        moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
        moviePlayerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:[moviePlayerViewController moviePlayer]];
        
        NSError *_error = nil;
        
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&_error];
        
        [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
        
    }
    
    else{
        
        NSString *message = [[NSString alloc] initWithFormat:@"Your device is not connected to the internet. You need access to the internet to stream our videos "];
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Important Notice"
                                                       message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        [message release];
        [alert release];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
	//old code
	//[moviePlayerController stop];
	
	[moviePlayerViewController.moviePlayer stop];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return  (interfaceOrientation != UIInterfaceOrientationPortrait );
	
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		//old code
		//[[moviePlayerController view] setFrame:CGRectMake(30 ,150, 700, 600)];
        [[moviePlayerViewController view] setFrame:CGRectMake(30 ,150, 700, 600)];
		
	}
	
	else {
		//old code
		//[[moviePlayerController view] setFrame:CGRectMake(180 ,20, 700, 600)];
		
		[[moviePlayerViewController view] setFrame:CGRectMake(180 ,20, 700, 600)];
	}
	
	
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[VideoFileName release];
    [super dealloc];
}


@end
