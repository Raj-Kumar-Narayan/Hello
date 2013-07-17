//
//  AppDelegate.m
//  databaseSample
//
//  Created by swati puri on 2/5/13.
//  Copyright (c) 2013 swati puri. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate
@synthesize nameStr,courseStr,rollStr,TempArray;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //================Database===========//
    
    databaseName=@"sampleDB.sqlite";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
    NSString *documentsDir = [documentPaths objectAtIndex:0];
	
    databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    //====================================//
	
    
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    navBar=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = navBar;
    [self checkAndCreateDatabase];
    [self.window makeKeyAndVisible];
    return YES;
    [TestFlight takeOff:@"e2441ca5-dd4f-49d7-a5ce-78bd60448645"];
}
-(void) checkAndCreateDatabase
{
	
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];// Create a FileManager object, we will use this to check the status
	
	// of the database and to copy it over if required
	
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if (success)
	{
		
		if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK)
        {
			NSLog(@"'%s'",sqlite3_errmsg(database));
		}
		
		return;
	}
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
	if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK)
    {
		NSLog(@"'%s'",sqlite3_errmsg(database));
	}
    
    //[fileManager release];
}

//=================================================================================================//

#pragma mark Add Record in Database

//===================================ADD RECORD IN DATABASE=========================================//

-(void)addRecord:(NSString *)name roll:(NSInteger)rollno course:(NSString *)course
{
	
	sqlite3_stmt *addStmt;
	
    const char *sql="INSERT INTO sampleTable(Name,RollNo,Course) Values(?,?,?)";
	if (sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL)!=SQLITE_OK)
    {
        NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		
	}
    
    sqlite3_bind_text(addStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(addStmt, 2, rollno);
    sqlite3_bind_text(addStmt, 3, [course UTF8String], -1, SQLITE_TRANSIENT);

    
  if(SQLITE_DONE != sqlite3_step(addStmt))
	{
		NSLog(@"Error1 while Inserting Record :- '%s'", sqlite3_errmsg(database));
		sqlite3_finalize(addStmt);
		
	}
	else
	{
		NSLog(@"Record Inserted Successfully.");
		sqlite3_finalize(addStmt);
		
	}
   	[self readRecordsFromDatabase];
	
}
-(void) readRecordsFromDatabase
{
    
    TempArray = [[NSMutableArray alloc] init];
    
	const char *sqlStatement = "select * from sampleTable";
	sqlite3_stmt *compiledStatement;
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        //        if(sqlite3_column_text(sqlStatement, 0) != nil)
        //        {
        //            //Data exists
        //        }
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            nameStr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			rollStr=sqlite3_column_int(compiledStatement, 1);
            courseStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
        }
        
    }
	// Release the compiled statement from memory
	sqlite3_finalize(compiledStatement);
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
