//
//  EvaluatorAppDelegate.h
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 15/09/2010.
//  Copyright caxtonidowu 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AudioToolbox/AudioServices.h>
#import "Sqlite3.h"
#import "CustomStoreObserver.h"
#import "GANTracker.h"
#import <netinet/in.h>


@interface EvaluatorAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UITabBarController *tabBarController;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSNumber *AllocatedMarks;
	NSString *Difficulty;
	NSString *Topic;
	NSString *TypeOfQuestion;
	NSNumber *NumberOfQuestions;
	NSNumber *NumberOfQuestionsDisplayed;
	
	NSNumber *PossibleScores;
	NSNumber *ClientScores;
	UIImageView *splashView;
	UITableViewController *buyScreen;
	NSThread *SecondThread;
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSNumber *AllocatedMarks;
@property (nonatomic, retain) NSString *Difficulty;
@property (nonatomic, retain) NSString *Topic;
@property (nonatomic, retain) NSString *TypeOfQuestion;
@property (nonatomic, retain) NSNumber *NumberOfQuestions;
@property (nonatomic, retain) NSNumber *NumberOfQuestionsDisplayed;

@property (nonatomic, retain) NSNumber *PossibleScores;
@property (nonatomic, retain) NSNumber *ClientScores;
@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) UITableViewController *buyScreen;
@property (nonatomic, retain) NSThread *SecondThread;

- (NSString *)applicationDocumentsDirectory;
- (void)PlaySound:(NSString *)FileName;
-(BOOL)CopyDataBase;
-(void) AddSplashScreen;
-(void) Removesplash;
//-(void) removeBuyTabIfNotNeededFromTabController:(UITabBarController *)tbController;

@end

