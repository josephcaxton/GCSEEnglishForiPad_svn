//
//  VideoPlayer.h
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 21/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h> 
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayer : UIViewController {
    
	//MPMoviePlayerController *moviePlayerController;
	NSString *VideoFileName;
    
    NSString *ServerLocation;
    NSURLCredential *credential;
    NSURLProtectionSpace *protectionSpace;
    MPMoviePlayerViewController *moviePlayerViewController;
	
}
@property (nonatomic, retain) NSString *VideoFileName;
@property (nonatomic, retain) NSString *ServerLocation;
@property (nonatomic, retain) NSURLCredential *credential;
@property (nonatomic, retain) NSURLProtectionSpace *protectionSpace;
@property (nonatomic, retain) MPMoviePlayerViewController *moviePlayerViewController;
@end
