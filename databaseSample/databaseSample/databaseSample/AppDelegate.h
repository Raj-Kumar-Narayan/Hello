//
//  AppDelegate.h
//  databaseSample
//
//  Created by swati puri on 2/5/13.
//  Copyright (c) 2013 swati puri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "TestFlight.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *nameStr;
    NSString *courseStr;
    NSInteger rollStr;
    UINavigationController *navBar;
    
    //==============Database Variables=============//
    
    
    NSString *databaseName;       //These Variables are used to store database name,database path
	NSString *databasePath;
	sqlite3 *database;
    
    NSMutableArray *TempArray;
    
    
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property(nonatomic,retain)NSString *nameStr;

@property(nonatomic,retain)NSString *courseStr;

@property(nonatomic,readwrite) NSInteger rollStr;

@property(nonatomic,retain) NSMutableArray *TempArray;

-(void) checkAndCreateDatabase;
-(void) readRecordsFromDatabase;
-(void)addRecord:(NSString *)name roll:(NSInteger)rollno course:(NSString *)course;


@end
