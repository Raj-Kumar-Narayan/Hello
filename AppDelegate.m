
//
//  AppDelegate.m
//  MyWeatherFinder
//
//  Created by Baljeet Singh on 22/02/13.
//  Copyright (c) 2013 Baljeet Singh. All rights reserved.
//

/*
 * Copyright 2012 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AppDelegate.h"
#import "JSON.h"
#import <FacebookSDK/FacebookSDK.h>
#define GoogleAPI @"AIzaSyBEfR_Zn8Lg-2HGZ4fFtjuGXCJjGG0xEQg"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import "LocationsTable.h"
#import "RecentSearchTable.h"
#import "RecentWeatherTable.h"
#import "PreviousWeatherTable.h"
#import "ForecastWeatherTable.h"
#import "NearByTable.h"
#import "DayHourHistoryTable.h"
#import "UserSettings.h"
#import "TodayForecastWeatherTable.h"
#import "HistoryWeatherViewController.h"


#import <CoreData/CoreData.h>
@class LocationsTable;
@class NearByTable;
@class UserSettings;
@implementation AppDelegate
@synthesize allreadyAdded;
@synthesize textToshare;
@synthesize isdirectlog;
@synthesize shareback;
@synthesize UnableHourlyView;
@synthesize lat1;
@synthesize lon1;
@synthesize IsintervalOn;
@synthesize ischangeTheme;
@synthesize ismanageLoc;
@synthesize isAddToRecord;
@synthesize signalOfRecordDelete;
@synthesize fav_locationDetailDictAll;
@synthesize fav_locationDetailDict;

@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;
@synthesize CurrentRegion;
@synthesize fbPostImageGlobal;
@synthesize offCurrentLocation;
@synthesize CurrentWeatherForMap;
@synthesize isCurrentLocationMap;
@synthesize isMapWeather;
@synthesize WeatherForMap;
@synthesize CompassDAll;
@synthesize MapSearchplacemarksArray;
@synthesize MapSearchPlaceInfo;
@synthesize geocoder1;
@synthesize countryCurrent;
@synthesize nearPlaces1;
@synthesize NearWeatherAll;
@synthesize ctemp_F;
@synthesize winddirdegree;
@synthesize windspeedKm;
@synthesize address;
@synthesize wrong;
@synthesize enableAddfav;
@synthesize cloudcoverD;
@synthesize weatherForcast;
@synthesize precipitationD;
@synthesize pressureD;
@synthesize visibility;
@synthesize observationTimeD;
@synthesize humidityD;
@synthesize tempMaxC;
@synthesize tempMinC;
@synthesize currentlocationlbl;
@synthesize tempratureClbl;
@synthesize winddir16Point;
@synthesize locationManager;
@synthesize status;
@synthesize tz;
@synthesize placemarksArray;
@synthesize geocoder;
@synthesize fav_location;
@synthesize dayofweak;
@synthesize allprepD;
@synthesize alltempMaxF;
@synthesize alltempMinF;
@synthesize allwindD;
@synthesize allwinddirDegree;
@synthesize allwindspeedKm;
@synthesize allwindspeedM;
@synthesize allwinddir16Point;
@synthesize dbcounter;
- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
   
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}
#pragma mark -application didFinishLaunchingWithOptions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    internetReach = [Reachability reachabilityForInternetConnection];
    isSplashScreen=YES;
    
   

    [self startLoadingAnimationWithMessage];

    BOOL isInternetAvailable;
    isInternetAvailable=[self updateInterfaceWithReachability:internetReach];
    if(isInternetAvailable==YES)
    {
       [self performSelector:@selector(InitialFetchFromDBandLocationManager) withObject:nil];  
    }
    else{
        UIAlertView*internetNot=[[UIAlertView alloc]initWithTitle:@"Weather Finder" message:@"Your Device Not Connected to the Internet Would to like to see Previous results" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        //[activityView addSubview:internetNot];
        [internetNot show];
      
    }
          
    

   return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([alertView tag]==7)
    {
        if (buttonIndex==0) {
            exit(1);
        }
    }
    else if ([alertView tag]==545251)
    {
        if (buttonIndex==0) {
            [self GetDataFromDatabase];
        }
        else
        {
            exit(1);
        }
    }
    else
    {
    if(buttonIndex==0)
    {
        exit(1);
    }
    else
    {
        [self GetDataFromDatabase];
    }
    }
}
-(void)GetDataFromDatabase
{
    NSMutableArray*tables=[[NSMutableArray alloc]initWithObjects:@"LocationsTable",@"RecentWeatherTable",@"TodayForecastWeatherTable", nil];
    NSArray *DataTable=[self CommonGetFromDB:[tables objectAtIndex:0] locID:nil];
  fav_location=[[NSMutableArray alloc]init];
    self.currentlocationlbl=[[NSMutableArray alloc]init];
    loc_ids=[[NSMutableArray alloc]init];
    if ([DataTable count] > 0){
        
        NSUInteger counter = 1;
        for (LocationsTable *theLoc in DataTable){
            [fav_location addObject:theLoc.location_Name];
            [loc_ids addObject:theLoc.location_ID];
            [self.currentlocationlbl addObject:theLoc.location_Name];
            counter++; }
       // //NSlog(@"%@",self.fav_location);
    }
    
//    else {
//        
//
//            }
   // //NSlog(@"%@",self.currentlocationlbl);
    if([fav_location count]==0)
    {
        UIAlertView*NoSavedData=[[UIAlertView alloc]initWithTitle:@"Weather Finder" message:@"Unable to Find the Previous Results Try lator" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        NoSavedData.tag=7;
       // [activityView addSubview:NoSavedData];
        [NoSavedData show];
    }
    else
    {
        NSArray*DataTable2=[self CommonGetFromDB:[tables objectAtIndex:1]locID:nil];
        
        self.ctemp_F=[[NSMutableArray alloc]init];
        self.tz=[[NSMutableArray alloc]init];
        self.tempratureClbl=[[NSMutableArray alloc]init];
       
        self.status=[[NSMutableArray alloc]init];
        self.humidityD=[[NSMutableArray alloc]init];
        self.observationTimeD=[[NSMutableArray alloc]init];
        self.precipitationD=[[NSMutableArray alloc]init];
        self.pressureD=[[NSMutableArray alloc]init];
        self.visibility=[[NSMutableArray alloc]init];
        self.cloudcoverD=[[NSMutableArray alloc]init];
        self.tempMaxC=[[NSMutableArray alloc]init];
        self.tempMinC=[[NSMutableArray alloc]init];
        NSMutableArray*CMaxtemp=[[NSMutableArray alloc]init];
        NSMutableArray*CMintemp=[[NSMutableArray alloc]init];
        if ([DataTable2 count] > 0){
            
            NSUInteger counter = 1;
            for (RecentWeatherTable *theLoc in DataTable2){
                ////NSlog(@"%@",[self.cloudcoverD objectAtIndex:count]);
                [self.cloudcoverD addObject:theLoc.cloudcover_DataModel];
                [self.humidityD addObject:theLoc.humidity_DataModel];
                [self.visibility addObject:theLoc.visibility_DataModel];
                [self.precipitationD addObject:theLoc.precipitation_DataModel];
                [self.pressureD addObject:theLoc.pressure_DataModel];
                [self.tempratureClbl addObject:theLoc.temp_DataModel];
                [self.observationTimeD addObject:theLoc.observeTime_DataModel];
                [self.status addObject:theLoc.weatherStatus_DataModel];
                [self.ctemp_F addObject:theLoc.tempF_DataModel];
                NSString*date=theLoc.dateToday_DataModel;
                date=[date stringByAppendingString:@" "];
                date=[date stringByAppendingString:theLoc.timeNow_DataModel];
                [self.tz addObject:date];
                [CMaxtemp addObject:theLoc.maxTemp_DataModel];
                [CMintemp addObject:theLoc.minTemp_DataModel];
               
                counter++; }
            [self.tempMaxC addObject:CMaxtemp];
            [self.tempMinC addObject:CMintemp];
        }
        else {
            //NSlog(@"Could not find ");
          }
        [CMaxtemp release];
        [CMintemp release];
        self.windspeedKm=[[NSMutableArray alloc]init];
        self.winddirdegree =[[NSMutableArray alloc]init];
        self.winddir16Point=[[NSMutableArray alloc]init];
        self.allwindspeedKm=[[NSMutableArray alloc]init];
        self.allwindD=[[NSMutableArray alloc]init];
        self.allwinddir16Point=[[NSMutableArray alloc]init];
        self.allwinddirDegree=[[NSMutableArray alloc]init];
        self.allprepD=[[NSMutableArray alloc]init];
        self.alltempMaxF=[[NSMutableArray alloc]init];
        self.alltempMinF=[[NSMutableArray alloc]init];
        self.allwindspeedM=[[NSMutableArray alloc]init];
        self.dayofweak=[[NSMutableArray alloc]init];
        self.weatherForcast=[[NSMutableArray alloc]init];
        self.tempMaxC=[[NSMutableArray alloc]init];
        self.tempMinC=[[NSMutableArray alloc]init];
        
        for (int a=0; a<[loc_ids count]; a++) {
            NSArray*DataTable3=[self CommonGetFromDB:[tables objectAtIndex:2] locID:[loc_ids objectAtIndex:a]];
            if ([DataTable3 count] > 0){
                NSMutableArray*day=[[NSMutableArray alloc]init];
                NSMutableArray*tempMax=[[NSMutableArray alloc]init];
                NSMutableArray*tempMin=[[NSMutableArray alloc]init];
                NSMutableArray*tempMaxF=[[NSMutableArray alloc]init];
                NSMutableArray*tempMinF=[[NSMutableArray alloc]init];
                NSMutableArray*w1=[[NSMutableArray alloc]init];
                NSMutableArray*prep=[[NSMutableArray alloc]init];
                NSMutableArray*w2=[[NSMutableArray alloc]init];
                NSMutableArray*w3=[[NSMutableArray alloc]init];
                NSMutableArray*w4=[[NSMutableArray alloc]init];
                NSMutableArray*w5=[[NSMutableArray alloc]init];
                NSMutableArray*weather=[[NSMutableArray alloc]init];
                NSUInteger counter = 1;
                for (TodayForecastWeatherTable *theLoc in DataTable3){
                    
                    [day addObject:theLoc.dateForecast_Datamodel];
                    //NSlog(@"%@",day);
                    [tempMax addObject:theLoc.maxTempForecast_DataModel];
                    
                    [tempMin addObject:theLoc.minTempForecast_DataModel];
                    [tempMaxF addObject:theLoc.maxTempForecast_DataModel];
                    [tempMinF addObject:theLoc.minFTempForecast_DataModel];
                    [w1 addObject:theLoc.wSpeedMileForecast_Datamodel];
                    [prep addObject:theLoc.prcipForecast_Datamodel];
                    [w2 addObject:theLoc.wSpeedKmForecast_Datamodel];
                    [w3 addObject:theLoc.windStatusForecast_Datamodel];
                    [w4 addObject:theLoc.windDirForecast_DataModel];
                    [w5 addObject:theLoc.wind16Forecast_DataModel];
                    [weather addObject:theLoc.weatherStatus];
                    counter++;
                }
                
                [self.dayofweak addObject:day];
                
                [self.tempMaxC addObject:tempMax];
                [self.tempMinC addObject:tempMin];
                [self.allprepD addObject:prep];
                [self.alltempMaxF addObject:tempMaxF];
                [self.alltempMinF addObject:tempMinF];
                [self.allwindspeedM addObject:w1];
                [self.allwindspeedKm addObject:w2];
                [self.allwindD addObject:w3];
                [self.allwinddirDegree addObject:w4];
                [self.allwinddir16Point addObject:w5];
                [self.weatherForcast addObject:weather];
                [day release];
                [tempMax release];
                [tempMin release];
                [prep release];
                [tempMaxF release];
                [tempMinF release];
                [w1 release];
                [w2 release];
                [w3 release];
                [w4 release];
                [w5 release];
                [weather release];
                [self tabbarcall];
            }
        }
        //NSlog(@"%@",allwindspeedKm);
        for (int a=0; a<[self.allwinddirDegree count]; a++) {
            [self.winddirdegree addObject:[[self.allwinddirDegree objectAtIndex:a] objectAtIndex:0]];
            [self.winddir16Point addObject:[[self.allwinddir16Point objectAtIndex:a] objectAtIndex:0]];
            [self.windspeedKm addObject:[[self.allwindspeedKm objectAtIndex:a] objectAtIndex:0]];
        }

        }
    //NSlog(@"%@",currentlocationlbl);
    
                
}
-(NSArray*)CommonGetFromDB:(NSString*)TableName locID:(NSNumber*)loc_id1
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription
                                   entityForName:TableName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    if([TableName isEqualToString:@"TodayForecastWeatherTable"])
    {
        //NSlog(@"%@",loc_id1);
        NSPredicate *lid=[NSPredicate predicateWithFormat:@"location_ID== %@",loc_id1];
        [fetchRequest setPredicate:lid];
        NSError *requestError = nil;
        NSArray *DataTable =
        [self.managedObjectContext executeFetchRequest:fetchRequest
                                                 error:&requestError];
        //NSlog(@"%@",DataTable);
        return DataTable;
        
    }
    else if([TableName isEqualToString:@"DayHourHistoryTable"])
    {
        //NSlog(@"%@",loc_id1);
        NSPredicate *lid=[NSPredicate predicateWithFormat:@"location_ID=%@",loc_id1];
        [fetchRequest setPredicate:lid];
        NSError *requestError = nil;
        NSArray *DataTable =
        [self.managedObjectContext executeFetchRequest:fetchRequest
                                                 error:&requestError];
        //NSlog(@"%@",DataTable);
        return DataTable;
   
        }
    else
    {
    NSError *requestError = nil;
    NSArray *DataTable =
    [self.managedObjectContext executeFetchRequest:fetchRequest
                                             error:&requestError];
    //NSlog(@"%@",DataTable);
    return DataTable;
    }
    
}
-(BOOL) updateInterfaceWithReachability: (Reachability*) curReach
{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
    //    BOOL connectionRequired= [curReach connectionRequired];
	BOOL connectionStatus = NO;
	
    switch (netStatus)
    {
        case NotReachable:
        {
            //   connectionRequired = NO;
			connectionStatus = NO;
            break;
        }
            
        case ReachableViaWWAN:
        {
			connectionStatus = YES;
			break;
        }
        case ReachableViaWiFi:
        {
			connectionStatus = YES;
			break;
		}
    }
	return connectionStatus;
}


-(void)InitialFetchFromDBandLocationManager
{
    isFirstlaunch=YES;
    dbcounter=0;//counter for database enteries
    self.fav_location=[[NSMutableArray alloc]init];
   /*23 NSFetchRequest *fetchRequest0 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity0 =[NSEntityDescription
                                   entityForName:@"LocationsTable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest0 setEntity:entity0];
    NSError *requestError0 = nil;
    //And execute the fetch request on the context 
    NSArray *DataTable0 =
    [self.managedObjectContext executeFetchRequest:fetchRequest0
    */                                       //  error:&requestError0];
    //NSlog(@"%@",DataTable0);
    NSArray *DataTable0=[self CommonGetFromDB:@"LocationsTable" locID:nil];
    favData=[[NSMutableArray alloc]init];
    if ([DataTable0 count] > 0){
        
        
        for (LocationsTable *theLoc in DataTable0){
            
            NSString*name=theLoc.location_Name;
           
            [favData addObject:name];
            
             }
    }
    else {
        //NSlog(@"Could not find any Student entities in the context.");
 }
   if([favData count]>0)
   {
       for (int s=0; s<[favData count]; s++) {
           //NSlog(@"%@",[favData objectAtIndex:s]);
           [self.fav_location addObject:[favData objectAtIndex:s]];
       }
         //NSlog(@"%@",fav_location);
   }
   
   else
   {
       
   }
    NSArray *DataTable1=[self CommonGetFromDB:@"UserSettings" locID:nil];
//   NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity1 =[NSEntityDescription
//                                   entityForName:@"UserSettings" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest1 setEntity:entity1];
//    NSError *requestError1 = nil;
//    
//   //  And execute the fetch request on the context 
//    NSArray *DataTable1 =
//    [self.managedObjectContext executeFetchRequest:fetchRequest1
//                                             error:&requestError1];
    //NSlog(@"%@",DataTable1);
    
    if ([DataTable1 count] > 0){
        
       
    }
    else {
        NSManagedObjectContext *objManagedObjectContext = nil;
        //NSlog(@"%@", [self managedObjectContext]);
        objManagedObjectContext=[self managedObjectContext];
        
        UserSettings *r=(UserSettings*)[NSEntityDescription insertNewObjectForEntityForName:@"UserSettings" inManagedObjectContext:objManagedObjectContext];
                
        
        [r setValue:@"bg.png" forKey:@"framename"];
        [r setValue:@"50000" forKey:@"nearbyRange"];
        
        
        NSError *error=nil;
        if(![_managedObjectContext save:&error])
        {
            //NSlog(@"Can't save! %@ %@",error,[error localizedDescription]);
        }

        }

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    

  
}
-(void)startLoadingAnimationWithMessage
{
    // new transparent view to disable user interaction during operation.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480){
            activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
        }
        else if(result.height==568)
        {
           activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 568)];
        }
    }
        activityView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    //activityView.tag = tag;
    //activityView.backgroundColor=[UIColor grayColor];
  //  activityView.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(59.0/255.0) blue:(102.0/255.0) alpha:1.0];
    //activityView.alpha = 0.75;
   // UIImageView*SplashImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
   // SplashImage.frame=CGRectMake(20, 100, 280, 250);
    //[activityView addSubview: SplashImage];
    CGFloat activityIndicatorPadding = 15.0f;
    
    //Loader spinner
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView addSubview:activityIndicator];
    [activityIndicator release];
    
    UILabel *requestingInformation = [[UILabel alloc] init];
    requestingInformation.text = @"Loading...";
    requestingInformation.backgroundColor = [UIColor clearColor];
    [activityView addSubview:requestingInformation];
    [requestingInformation release];
    
    CGSize requestingInformationSize = [requestingInformation.text sizeWithFont:requestingInformation.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:requestingInformation.lineBreakMode];
    CGFloat totalWidthOfUIELements = (requestingInformationSize.width + activityIndicator.frame.size.width + activityIndicatorPadding);
    
    CGFloat activityIndicatorStartX = (activityView.frame.size.width - totalWidthOfUIELements)/2;
    
    activityIndicator.center = CGPointMake(activityIndicatorStartX,(activityView.frame.size.height/2));
    requestingInformation.frame = CGRectMake((activityIndicator.frame.origin.x + activityIndicator.frame.size.width + activityIndicatorPadding), (activityView.frame.size.height/2)-10, requestingInformationSize.width, requestingInformation.font.lineHeight);
    
    //[self.view addSubview:activityView];
    //[self.view bringSubviewToFront:activityView];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window addSubview:activityView];
    [self.window makeKeyAndVisible];
    [activityView release];
    [activityIndicator startAnimating];
    
}
-(void)tabbarcall
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480){
          currentWeather=[[MyCurrentWeatherViewController alloc]initWithNibName:@"MyCurrentWeatherViewController" bundle:nil];
            mapWeather=[[MapWeatherViewController alloc]initWithNibName:@"MapWeatherViewController" bundle:nil];
            history=[[HistoryWeatherViewController alloc]initWithNibName:@"HistoryWeatherViewController" bundle:nil];
            social=[[SocialViewController alloc]initWithNibName:@"SocialViewController" bundle:nil];
        }
        else if(result.height==568)
        {
          currentWeather=[[MyCurrentWeatherViewController alloc]initWithNibName:@"MyCurrentWeatherVC_iphoneLarge" bundle:nil];
            
         mapWeather=[[MapWeatherViewController alloc]initWithNibName:@"MapWeatherVC_iphoneLarge" bundle:nil];
            history=[[HistoryWeatherViewController alloc]initWithNibName:@"HistoryWeatherVC_iphoneLarge" bundle:nil];
            social=[[SocialViewController alloc]initWithNibName:@"SocialVC_iphoneLarge" bundle:nil];
        }
    tabBarController=[[UITabBarController alloc]init];
    
    
    UINavigationController*navctr=[[UINavigationController alloc]initWithRootViewController:currentWeather];
    UITabBarItem*tab1=[[UITabBarItem alloc]init];
                      // WithTitle:@"Weather" tag:1];
    [tab1 setFinishedSelectedImage:[UIImage imageNamed:@"weather_hover.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"weather.png"]];
   tab1.imageInsets = UIEdgeInsetsMake(6, 0, -8, 0);
    [navctr setTabBarItem:tab1];
    
    
    
    UINavigationController*navctr1=[[UINavigationController alloc]initWithRootViewController:mapWeather];
    UITabBarItem*tab2=[[UITabBarItem alloc]init ];//WithTitle:@"Map" image:[UIImage imageNamed:@"map.png" ] tag:2];
    [tab2 setFinishedSelectedImage:[UIImage imageNamed:@"map_hover.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"map.png"]];
    tab2.imageInsets = UIEdgeInsetsMake(6, 0, -8, 0);
    [navctr1 setTabBarItem:tab2];
    
    
    
    UINavigationController*navctr2=[[UINavigationController alloc]initWithRootViewController:history];
    UITabBarItem*tab3=[[UITabBarItem alloc]init ];//WithTitle:@"Daily" image:[UIImage imageNamed:@"history.png" ] tag:3];
    [tab3 setFinishedSelectedImage:[UIImage imageNamed:@"history_hover.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"history.png"]];
    tab3.imageInsets = UIEdgeInsetsMake(6, 0, -8, 0);
    [navctr2 setTabBarItem:tab3];
    
    
    UINavigationController*navctr3=[[UINavigationController alloc]initWithRootViewController:social];
    UITabBarItem*tab4=[[UITabBarItem alloc]init ];//WithTitle:@"Social" image:[UIImage imageNamed:@"rsz_1361810794_social_network.png" ] tag:4];
    [tab4 setFinishedSelectedImage:[UIImage imageNamed:@"social_hover.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"social.png"]];
    tab4.imageInsets = UIEdgeInsetsMake(6, 0, -8, 0);
    [navctr3 setTabBarItem:tab4];
    
    
    NSArray *arrayNavController=[NSArray arrayWithObjects:navctr,navctr1,navctr2,navctr3,nil];
    [tabBarController setViewControllers:arrayNavController];
    //[self.window addSubview:tabBarController.view];

    // Override point for customization after application launch.
    // self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    //self.window.rootViewController = self.viewController;
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSlog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    lat = [NSString stringWithFormat:@"%.20f", newLocation.coordinate.latitude];
    lon=[NSString stringWithFormat:@"%.20f", newLocation.coordinate.longitude];
    //NSlog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    //NSlog(@"address%@", newLocation.description);
        [self getAddress];
    
}
- (void)getAddress{
    self.countryCurrent=[[NSString alloc]init];
    //Init your coordinated with CLLocation object
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lon floatValue]];
    //NSlog(@"lat==%f",[lat floatValue]);
    lat1=[lat doubleValue];
    lon1=[lon doubleValue];
    //instance menthod of CLGeocoder for reverse geocoding
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //copy instance variable with placemarks array
        self.placemarksArray = placemarks;
        
        //enumurate the objects from the array and create the address to show in textview
        //the placemarks is an array and it returns the objects of the class CLPlacemark.
        //most of the time the array returns only single address but at some situation it may
        //return multiple addresses
        [self.placemarksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            placeInfo = obj;
            
           self.address = [NSString stringWithFormat:@"%@",placeInfo.name];
            //NSlog(@"%@",self.address);
            if ([placeInfo.subLocality length]>0) {
                address = [address stringByAppendingFormat:@",%@",placeInfo.subLocality];
                //NSlog(@"%@",address);
            }
            if ([placeInfo.locality length]>0) {
                self.address = [address stringByAppendingFormat:@",%@",placeInfo.locality];
                 //NSlog(@"%@",self.address);
            }
            if ([placeInfo.country length]>0) {
                self.address = [address stringByAppendingFormat:@",%@",placeInfo.country];
                self.countryCurrent=placeInfo.country;
                //NSlog(@"%@",self.address);
            }
            if ([placeInfo.postalCode length]>0) {
                self.address = [address stringByAppendingFormat:@",%@",placeInfo.postalCode];
            }
            
 
        }];
        [self currentloc];
        [self callplaceMarkArray];
        //NSlog(@"%@",error);
    }];
    
    
}
-(void) currentloc
{
      //NSlog(@"%@",fav_location);
    if([placeInfo.locality length]>0)
    {
   self.address = [NSString stringWithFormat:@"%@",placeInfo.locality];
    self.address=[self.address stringByAppendingString:@","];
    self.address=[self.address stringByAppendingString:placeInfo.country];
    }
      //NSlog(@"%@",fav_location);
    dbcounter=0;
    //NSlog(@"%@",self.address);
    if ([favData count]>0)
    {
        
        if ([[self.fav_location objectAtIndex:0] isEqualToString:self
            .address]) {
            isCurrentLocationChanged=NO;
        }
        else{
            isCurrentLocationChanged=YES;
            
        [self.fav_location replaceObjectAtIndex:0 withObject:self.address];
        
          }
    
    }
      else
        {   if([self.fav_location count]>0)
          {
            if ([[self.fav_location objectAtIndex:0] isEqualToString:self
                 .address]) {
                isCurrentLocationChanged=NO;
            }
            else{
                isCurrentLocationChanged=YES;
            [self.fav_location replaceObjectAtIndex:0 withObject:self.address];

            }
          }
           else
         {
             
         [self.fav_location addObject:self.address];
         }
        }

}
#pragma mark - Near By location Search
-(void)Google_PlaceApI_For_NearLocations:(double)l lng:(double)ln radius:(NSString*)radius
{
   // NSURL *url = [NSURL URLWithString:@"http://www.worldweatheronline.com/mani-majra-weather/haryana/in.aspx"];
    //NSString *webData1= [NSString stringWithContentsOfURL:url];
   // //NSlog(@"%@",webData1);
   // NSMutableArray*nearPlaces=[[NSMutableArray alloc]init];
    NSString *googleurl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", l, ln, radius, @"train_station", GoogleAPI];
                           //
    NSMutableURLRequest *Grequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",googleurl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //NSlog(@"urlRequest %@",Grequest);
    
    NSHTTPURLResponse* GurlResponse = nil;
    NSError *Gerror = nil;
    
    NSData *GnewData = [NSURLConnection sendSynchronousRequest:Grequest returningResponse:&GurlResponse error:&Gerror];
    //Google place api
    if([GnewData length] && Gerror == nil ){
        NSString *GresponseString = [[[NSString alloc] initWithData:GnewData encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *GjsonObject = [GresponseString JSONValue];
        //Accessing JSON content
        //NSlog(@"Dictionay %@",GjsonObject);
        NSArray*data=[GjsonObject objectForKey:@"results"];
        //NSlog(@"%@",data);
        CompassDAll=[[NSMutableDictionary alloc]init];
        self.nearPlaces1=[[NSMutableArray alloc]init];
        MapSearchplacemarksArray=[[NSArray alloc]init];
        for (int i=0; i<[data count]; i++) {
            //Retrieve the NSDictionary object in each index of the array.
            NSDictionary* place = [data objectAtIndex:i];
            NSDictionary *geo = [place objectForKey:@"geometry"];
            
            NSDictionary *loc = [geo objectForKey:@"location"];
            
          
            // Set the lat and long.
            
                    NSMutableDictionary*latlonDict=[[NSMutableDictionary alloc]init];
        
            double Dlat =  [[loc objectForKey:@"lat"]doubleValue]-l;
            //NSlog(@"%f",Dlat);
            double Dlon = [[loc objectForKey:@"lng"]doubleValue]-ln;
          double margin = 3.14159/90; // 2 degree tolerance for cardinal directions

            double angle = atan2(Dlat,Dlon);
            NSString *vicinity;NSString *subString;
            vicinity=[place objectForKey:@"vicinity"];
            //NSlog(@"Areaaaaa==%@",vicinity);
            subString = [[vicinity componentsSeparatedByString:@","] lastObject];
            //NSlog(@"%@",subString);

            if (angle > -margin && angle < margin)
            {
                //NSlog(@"E");
                if([CompassDAll objectForKey:@"E"]==NULL)
                    
                {
                [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                [latlonDict setObject:subString forKey:@"address"];
                [CompassDAll setObject:latlonDict forKey:@"E"];
                }
                else{
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                    [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                    [latlonDict setObject:subString forKey:@"address"];
                    [CompassDAll setObject:latlonDict forKey:@"E1"];
                }
               
            }
            
            else if ((angle > 3.14159/2 - margin) && (angle < 3.14159/2 + margin))
            {
                //NSlog(@"N");
                if([CompassDAll objectForKey:@"N"]==NULL)
                    
                {
                [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                [latlonDict setObject:subString forKey:@"address"];
                [CompassDAll setObject:latlonDict forKey:@"N"];
                }
                else{
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                    [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                    [latlonDict setObject:subString forKey:@"address"];
                    [CompassDAll setObject:latlonDict forKey:@"N1"];
 
                }
                
            }
            
            else if (angle > 3.14159 - margin && angle < -3.14159 + margin)
            {
                //NSlog(@"W");
                if([CompassDAll objectForKey:@"W"]==NULL)
                    
                {
                [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                [latlonDict setObject:subString forKey:@"address"];
                [CompassDAll setObject:latlonDict forKey:@"W"];
                }
                else{
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                    [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                    [latlonDict setObject:subString forKey:@"address"];
                    [CompassDAll setObject:latlonDict forKey:@"W1"];
                }
                
            }
            
            else if (angle > -3.14159/2 - margin && angle < -3.14159/2 + margin)
            {
                //NSlog(@"S");
                if([CompassDAll objectForKey:@"S"]==NULL)
                    
                {
                [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                 [latlonDict setObject:subString forKey:@"address"];
                [CompassDAll setObject:latlonDict forKey:@"S"];
                }
                else{
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                    [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                    [latlonDict setObject:subString forKey:@"address"];
                    [CompassDAll setObject:latlonDict forKey:@"S1"];

                }
            }
            
            
            if (angle > 0 && angle < 3.14159/2)
            {
                //NSlog(@"NE");
                if([CompassDAll objectForKey:@"NE"]==NULL)
                    
                {
                [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                [latlonDict setObject:subString forKey:@"address"];
                [CompassDAll setObject:latlonDict forKey:@"NE"];
                }
                else if([CompassDAll objectForKey:@"NE"]!=NULL && [CompassDAll objectForKey:@"NE1"]==NULL){
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                    [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                    [latlonDict setObject:subString forKey:@"address"];
                    [CompassDAll setObject:latlonDict forKey:@"NE1"];
                }
                else if([CompassDAll objectForKey:@"NE"]!=NULL && [CompassDAll objectForKey:@"NE1"]!=NULL)
                         {
                             [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                             [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                             [latlonDict setObject:subString forKey:@"address"];
                             [CompassDAll setObject:latlonDict forKey:@"NE2"];
   
                         }
            }
            else if (angle > 3.14159/2 && angle < 3.14159)
            {
                if([CompassDAll objectForKey:@"NW"]==NULL)
                    
                {
                //NSlog(@"NW");
                [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                [latlonDict setObject:subString forKey:@"address"];
                [CompassDAll setObject:latlonDict forKey:@"NW"];
                }
                else if([CompassDAll objectForKey:@"NW"]!=NULL && [CompassDAll objectForKey:@"NW1"]==NULL){
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                    [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                    [latlonDict setObject:subString forKey:@"address"];
                    [CompassDAll setObject:latlonDict forKey:@"NW1"];
                }
                else if ([CompassDAll objectForKey:@"NW"]!=NULL && [CompassDAll objectForKey:@"NW1"]!=NULL)

                {
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                    [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                    [latlonDict setObject:subString forKey:@"address"];
                    [CompassDAll setObject:latlonDict forKey:@"NW2"];
                }
            }
            else if (angle > -3.14159/2 && angle < 0) {
                 //NSlog(@"SE");
                if([CompassDAll objectForKey:@"SE"]==NULL)
                    
                {
               [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                [latlonDict setObject:subString forKey:@"address"];
                [CompassDAll setObject:latlonDict forKey:@"SE"];
                }
                else if([CompassDAll objectForKey:@"SE"]!=NULL && [CompassDAll objectForKey:@"SE1"]==NULL){
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                    [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                    [latlonDict setObject:subString forKey:@"address"];
                    [CompassDAll setObject:latlonDict forKey:@"SE1"];
  
                }
                else if ([CompassDAll objectForKey:@"SE"]!=NULL && [CompassDAll objectForKey:@"SE1"]!=NULL)
                {
                   
                        [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                        [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                        [latlonDict setObject:subString forKey:@"address"];
                        [CompassDAll setObject:latlonDict forKey:@"SE2"];
                        
 
                }
                
            }
            else {
                //NSlog(@"SW");
                if([CompassDAll objectForKey:@"SW"]==NULL)
                
                {
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                [latlonDict setObject:subString forKey:@"address"];
                [CompassDAll setObject:latlonDict forKey:@"SW"];
                }
                else if ([CompassDAll objectForKey:@"SW"]!=NULL && [CompassDAll objectForKey:@"SW1"]==NULL)
                {
                    [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                    [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                    [latlonDict setObject:subString forKey:@"address"];
                    [CompassDAll setObject:latlonDict forKey:@"SW1"];
                }
                 else if ([CompassDAll objectForKey:@"SW1"]!=NULL && [CompassDAll objectForKey:@"SW"]!=NULL)
                 {
                     [latlonDict setObject:[loc objectForKey:@"lat"] forKey:@"lat"];
                     [latlonDict setObject:[loc objectForKey:@"lng"] forKey:@"lon"];
                     [latlonDict setObject:subString forKey:@"address"];
                     [CompassDAll setObject:latlonDict forKey:@"SW2"];
                     
                 }
               
            }
        }
        //NSlog(@"%@",CompassDAll);
        //NSlog(@"%@",fav_location);
        int j=0;
        self.NearWeatherAll=[[NSMutableDictionary alloc]init];
        for (NSString* key in CompassDAll) {
            
            id value = [CompassDAll objectForKey:key];
            //NSlog(@"%@",value);
            //NSlog(@"%@",[value objectForKey:@"lat"]);
            [self jsonParsingNear:[value objectForKey:@"lat"] lng:[value objectForKey:@"lon"] index:j];
            j++;
            
        }
       
    }
[CompassDAll release];
}
#pragma mark - CallplaceMarkArray
-(void)callplaceMarkArray
{  [locationManager stopUpdatingLocation];
    
    //cutom Search
    if([currentWeather.searchText length]>0)
    {
        NSArray*separate;
        
        for (int q=0; q<[fav_location count]; q++) {
            separate=[[self.fav_location objectAtIndex:q] componentsSeparatedByString:@","];
            NSString *trimmedString = [currentWeather.searchText stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
            //NSlog(@"%@",separate);
            if([[trimmedString uppercaseString] isEqualToString:[[self.fav_location objectAtIndex:q]uppercaseString]]||[[[separate objectAtIndex:0] uppercaseString]isEqualToString:[trimmedString uppercaseString]])
            {
               
                allreadyAdded=YES;
            }
            else
            {
                
                
            }
        }
        if (allreadyAdded==YES) {
            
        }
        else
        {
             UnableHourlyView=YES;
             enableAddfav=YES;
            [self.fav_location replaceObjectAtIndex:0 withObject:currentWeather.searchText];
            
        }
        
        }

          //****************************
    
       if (allreadyAdded==NO||[currentWeather.searchText length]==0) {
           // for map weather
           self.allwindspeedKm=[[NSMutableArray alloc]init];
           self.allwindD=[[NSMutableArray alloc]init];
           self.allwinddir16Point=[[NSMutableArray alloc]init];
           self.allwinddirDegree=[[NSMutableArray alloc]init];
           self.allprepD=[[NSMutableArray alloc]init];
           self.alltempMaxF=[[NSMutableArray alloc]init];
           self.alltempMinF=[[NSMutableArray alloc]init];
           self.allwindspeedM=[[NSMutableArray alloc]init];
           self.windspeedKm=[[NSMutableArray alloc]init];
           self.winddirdegree =[[NSMutableArray alloc]init];
           self.ctemp_F=[[NSMutableArray alloc]init];
           self.winddir16Point=[[NSMutableArray alloc]init];
           self.tz=[[NSMutableArray alloc]init];
           self.tempratureClbl=[[NSMutableArray alloc]init];
           self.currentlocationlbl=[[NSMutableArray alloc]init];
           self.status=[[NSMutableArray alloc]init];
           self.humidityD=[[NSMutableArray alloc]init];
           self.observationTimeD=[[NSMutableArray alloc]init];
           self.precipitationD=[[NSMutableArray alloc]init];
           self.pressureD=[[NSMutableArray alloc]init];
           self.visibility=[[NSMutableArray alloc]init];
           self.cloudcoverD=[[NSMutableArray alloc]init];
           self.tempMaxC=[[NSMutableArray alloc]init];
           self.tempMinC=[[NSMutableArray alloc]init];
           self.dayofweak=[[NSMutableArray alloc]init];
           self.weatherForcast=[[NSMutableArray alloc]init];
           self.fav_locationDetailDictAll=[[NSMutableArray alloc]init];
           //NSlog(@"%@",fav_location);
           
           if(IsintervalOn==YES)
           {
               dbcounter=0;
           }
           
           //NSlog(@"place%@",placemarksArray);
           //NSlog(@"place%@",self.fav_location);
           
           int i;
           for(i=0;i<[self.fav_location count];i++)
           {
               
               [self jsonParsing:[fav_location objectAtIndex:i]];
           }
           
           if(isSplashScreen==YES) {
               [activityView removeFromSuperview];
               isSplashScreen=NO;
           }

    }
    else
    {
        
    }
      
     [self tabbarcall];
}
-(void)jsonParsingNear:(NSString*) lat0 lng:(NSString*)ln0 index:(int)j
{
    NSString *Nurl = [NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?key=8fd1b046af051040132202&includeLocation=yes&q=%@,%@&num_of_days=%d&format=json",lat0,ln0,1];
    NSMutableURLRequest *Nrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",Nurl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //NSlog(@"urlRequest %@",Nrequest);
    
    NSHTTPURLResponse* NurlResponse = nil;
    NSError *Nerror = nil;
    
    NSData *NnewData = [NSURLConnection sendSynchronousRequest:Nrequest returningResponse:&NurlResponse error:&Nerror];
    //Google place api
    if([NnewData length] && Nerror == nil ){
        NSString *NresponseString = [[[NSString alloc] initWithData:NnewData encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *NjsonObject = [NresponseString JSONValue];
        //Accessing JSON content
        //NSlog(@"Dictionay %@",NjsonObject);
        NSArray*Neardata=[NjsonObject objectForKey:@"data"];
        //NSlog(@"%@",Neardata);
        NSArray*errorR=[Neardata valueForKey:@"error"];
        NSString*errorS=[[errorR objectAtIndex:0]valueForKey:@"msg"];
        if([errorS length]>0 || errorS!=nil)
        {
            
           // [remove addObject:[NSNumber numberWithInt:j] ];
            //[nearPlaces1 removeObjectAtIndex:j];
            ////NSlog(@"%@",remove);
        }
        else{
        NSMutableDictionary*near1weather=[[NSMutableDictionary alloc]init];
           
            if ([[[Neardata valueForKey:@"nearest_area"]objectAtIndex:0] objectForKey:@"region"]) {
                [near1weather setObject:[[[[[Neardata valueForKey:@"nearest_area"]objectAtIndex:0]valueForKey:@"region"] objectAtIndex:0] valueForKey:@"value"] forKey:@"region"];
            }
            else{
                [near1weather setObject:@"NA" forKey:@"region"];
            }
            [near1weather setObject:[[[Neardata valueForKey:@"nearest_area"]objectAtIndex:0]valueForKey:@"latitude"]forKey:@"lat"];
           [near1weather setObject:[[[Neardata valueForKey:@"nearest_area"]objectAtIndex:0]valueForKey:@"longitude"]forKey:@"lon"];
            [near1weather setObject:[[[[[Neardata valueForKey:@"nearest_area"]objectAtIndex:0]valueForKey:@"country"] objectAtIndex:0] valueForKey:@"value"] forKey:@"location"];
            //NSlog(@"DICTO%@",near1weather);
            [ near1weather setObject:[[[Neardata valueForKey:@"current_condition"] objectAtIndex:0]valueForKey:@"temp_C"] forKey:@"temp_C"];
            //NSlog(@"DICTO%@",near1weather);
            //NSDictionary*r=[Neardata valueForKey:@"current_"]
            [near1weather setObject:[[[[[Neardata valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"weatherDesc"]objectAtIndex:0]valueForKey:@"value"] forKey:@"weather"];
            
            [self.nearPlaces1 addObject:[[[[[Neardata valueForKey:@"nearest_area"]objectAtIndex:0]valueForKey:@"areaName"] objectAtIndex:0] valueForKey:@"value"]];
            //NSlog(@"%@",self.nearPlaces1);
            //NSlog(@"DICTO%@",near1weather);
            [self.NearWeatherAll setObject:near1weather forKey:[[[[[Neardata valueForKey:@"nearest_area"]objectAtIndex:0]valueForKey:@"areaName"] objectAtIndex:0] valueForKey:@"value"]];
            //NSlog(@"%@",self.NearWeatherAll);
            [near1weather release];
        }
        
    }
}
-(void)jsonParsing:(NSString*)locaddress
{
    tzData = [[NSMutableData data] retain];
   webData = [[NSMutableData data] retain];
    
    NSString*timezoneurl=[NSString stringWithFormat:@"http://www.worldweatheronline.com/feed/tz.ashx?key=8fd1b046af051040132202&q=%@&format=json",locaddress];
    
    NSString* urlString=[NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?key=8fd1b046af051040132202&includeLocation=yes&q=%@&num_of_days=%d&format=json",locaddress,5];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //NSlog(@"urlRequest %@",request);
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",timezoneurl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //NSlog(@"urlRequest %@",request1);
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  //  NSURLResponse *response = nil;
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSHTTPURLResponse* urlResponse1 = nil;
    NSError *error1 = nil;
    //getting the data
    NSData *newData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSData *newData1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:&urlResponse1 error:&error1];
    if (nil == urlResponse || nil == urlResponse1) {
        if (error || error1)
        {
            UIAlertView*alertDanger=[[UIAlertView alloc]initWithTitle:@"Weather Finder" message:@"Service Not Available Try Lator" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertDanger show];
            
        }
            NSLog(@"Connection failed! Error - %@ %@",
                  [error localizedDescription],
                  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }
else
{
    if([newData length] && error == nil && [newData1 length] && error1 == nil ){
        NSString *responseString = [[[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *jsonObject = [responseString JSONValue];
        //Accessing JSON content
        //NSlog(@"Dictionay %@",jsonObject);
        if ([jsonObject isKindOfClass:[NSNull class]]) {
            UIAlertView*alertNoservice=[[UIAlertView alloc]initWithTitle:@"Weather Finder" message:@"Service Unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNoservice show];
            exit(1);
        }
        else
        {
            NSDictionary*city=[jsonObject objectForKey:@"data"];
            //NSlog(@"%@",city);
            NSArray*errorReport=[city objectForKey:@"error"];
            NSString*errorstatus=[[errorReport objectAtIndex:0]valueForKey:@"msg"];
            if([errorstatus length]>0 || errorstatus!=nil)
            {
                wrong=YES;
                enableAddfav=NO;
            }
            else{
                NSMutableArray*data=[city objectForKey:@"request"];
                //NSlog(@"%@",data);
                //Get summary info
               // NSString*summaryUrl=[[NSString alloc]init];
                //NSlog(@"%@",[city valueForKey:@"nearest_area"]);
                //summaryUrl=[[[[[city valueForKey:@"nearest_area"]objectAtIndex:0]valueForKey:@"weatherUrl"] objectAtIndex:0] valueForKey:@"value"];
                //NSlog(@"%@",summaryUrl);
                // [self loadSummary:summaryUrl];
                mapWeather=[[MapWeatherViewController alloc]init];
                //NSlog(isCurrentLocationMap ? @"Yes" : @"No");
                if( isCurrentLocationMap==YES)
                {
                    self.CurrentWeatherForMap=[[NSMutableDictionary alloc]init];
                    
                    [self.CurrentWeatherForMap setObject:[[data objectAtIndex:0]valueForKey:@"query"] forKey:@"location"];
                    NSDictionary*temp=[city valueForKey:@"current_condition"];
                    // //NSlog(@"%@",temp);
                    
                    [self.CurrentWeatherForMap setObject:[[temp valueForKey:@"temp_C"]objectAtIndex:0] forKey:@"temp"];
                    
                    [self.CurrentWeatherForMap setObject:[[[[[city objectForKey:@"current_condition"]valueForKey:@"weatherDesc"]objectAtIndex:0]objectAtIndex:0]valueForKey:@"value"] forKey:@"weather"];
                    ////NSlog(@"%@",self.CurrentWeatherForMap);
                    
                }
                
                
                else if (isMapWeather==YES) {
                    self.WeatherForMap=[[NSMutableDictionary alloc]init];
                    
                    [self.WeatherForMap setObject:[[data objectAtIndex:0]valueForKey:@"query"] forKey:@"location"];
                    NSDictionary*temp=[city valueForKey:@"current_condition"];
                    // //NSlog(@"%@",temp);
                    [self.tempratureClbl addObject:[[temp valueForKey:@"temp_C"]objectAtIndex:0]];
                    [self.WeatherForMap setObject:[[temp valueForKey:@"temp_C"]objectAtIndex:0] forKey:@"temp"];
                    NSString*condition=[[[[[city objectForKey:@"current_condition"]valueForKey:@"weatherDesc"]objectAtIndex:0]objectAtIndex:0]valueForKey:@"value"];
                    [self.WeatherForMap setObject:condition forKey:@"weather"];
                    // //NSlog(@"%@",self.WeatherForMap);
                    
                }
                else{
                    NSMutableArray*next=[city objectForKey:@"weather"];
                    //  //NSlog(@"weather%@",next);
                    NSMutableArray*prepall=[[NSMutableArray alloc]init];
                    [prepall addObject:[[next objectAtIndex:0] valueForKey:@"precipMM"] ];
                    [prepall addObject:[[next objectAtIndex:1]valueForKey:@"precipMM"] ];
                    
                    [prepall addObject:[[next objectAtIndex:2]valueForKey:@"precipMM"] ];
                    //NSlog(@"next..%@",prepall);
                    [prepall addObject:[[next objectAtIndex:3]valueForKey:@"precipMM"] ];
                    // //NSlog(@"next1..%@",prepall);
                    [prepall addObject:[[next objectAtIndex:4]valueForKey:@"precipMM"]];
                    ////NSlog(@"next1..%@",prepall);
                    [self.allprepD addObject:prepall];
                    [prepall release];
                    //     //NSlog(@"%@",self.allprepD);
                    NSMutableArray*tempall=[[NSMutableArray alloc]init];
                    [tempall addObject:[[next objectAtIndex:0] valueForKey:@"tempMaxF"] ];
                    [tempall addObject:[[next objectAtIndex:1]valueForKey:@"tempMaxF"] ];
                    
                    [tempall addObject:[[next objectAtIndex:2]valueForKey:@"tempMaxF"] ];
                    
                    [tempall addObject:[[next objectAtIndex:3]valueForKey:@"tempMaxF"] ];
                    // //NSlog(@"next1..%@",tempall);
                    [tempall addObject:[[next objectAtIndex:4]valueForKey:@"tempMaxF"]];
                    // //NSlog(@"next1..%@",tempall);
                    [self.alltempMaxF addObject:tempall];
                    //NSlog(@"%@",self.alltempMaxF);
                    [tempall release];
                    NSMutableArray*tempallN=[[NSMutableArray alloc]init];
                    [tempallN addObject:[[next objectAtIndex:0] valueForKey:@"tempMinF"] ];
                    [tempallN addObject:[[next objectAtIndex:1]valueForKey:@"tempMinF"] ];
                    
                    [tempallN addObject:[[next objectAtIndex:2]valueForKey:@"tempMinF"] ];
                    //NSlog(@"next..%@",tempallN);
                    [tempallN addObject:[[next objectAtIndex:3]valueForKey:@"tempMinF"] ];
                    //  //NSlog(@"next1..%@",tempallN);
                    [tempallN addObject:[[next objectAtIndex:4]valueForKey:@"tempMinF"]];
                    
                    [self.alltempMinF addObject:tempallN];
                    //    //NSlog(@"minnnnnnn%@",self.alltempMinF);
                    [tempallN release];
                    //wind
                    NSMutableArray*w=[[NSMutableArray alloc]init];
                    [w addObject:[[next objectAtIndex:0] valueForKey:@"winddir16Point"] ];
                    [w addObject:[[next objectAtIndex:1]valueForKey:@"winddir16Point"] ];
                    
                    [w addObject:[[next objectAtIndex:2]valueForKey:@"winddir16Point"] ];
                    // //NSlog(@"next..%@",tempallN);
                    [w addObject:[[next objectAtIndex:3]valueForKey:@"winddir16Point"] ];
                    // //NSlog(@"next1..%@",tempallN);
                    [w addObject:[[next objectAtIndex:4]valueForKey:@"winddir16Point"]];
                    
                    [self.allwinddir16Point addObject:w];
                    [w release];
                    //NSlog(@"%@",self.allwinddir16Point);
                    
                    NSMutableArray*w1=[[NSMutableArray alloc]init];
                    [w1 addObject:[[next objectAtIndex:0] valueForKey:@"winddirDegree"] ];
                    [w1 addObject:[[next objectAtIndex:1]valueForKey:@"winddirDegree"] ];
                    
                    [w1 addObject:[[next objectAtIndex:2]valueForKey:@"winddirDegree"] ];
                    //NSlog(@"next..%@",tempallN);
                    [w1 addObject:[[next objectAtIndex:3]valueForKey:@"winddirDegree"] ];
                    //  //NSlog(@"next1..%@",tempallN);
                    [w1 addObject:[[next objectAtIndex:4]valueForKey:@"winddirDegree"]];
                    
                    [self.allwinddirDegree addObject:w1];
                    //NSlog(@"%@",self.allwinddirDegree);
                    [w1 release];
                    NSMutableArray*w2=[[NSMutableArray alloc]init];
                    [w2 addObject:[[next objectAtIndex:0] valueForKey:@"winddirection"] ];
                    [w2 addObject:[[next objectAtIndex:1]valueForKey:@"winddirection"] ];
                    
                    [w2 addObject:[[next objectAtIndex:2]valueForKey:@"winddirection"] ];
                    //  //NSlog(@"next..%@",tempallN);
                    [w2 addObject:[[next objectAtIndex:3]valueForKey:@"winddirection"] ];
                    // //NSlog(@"next1..%@",tempallN);
                    [w2 addObject:[[next objectAtIndex:4]valueForKey:@"winddirection"]];
                    
                    [self.allwindD addObject:w2];
                    //     //NSlog(@"%@",self.allwindD);
                    [w2 release];
                    NSMutableArray*w3=[[NSMutableArray alloc]init];
                    [w3 addObject:[[next objectAtIndex:0] valueForKey:@"windspeedKmph"] ];
                    [w3 addObject:[[next objectAtIndex:1]valueForKey:@"windspeedKmph"] ];
                    
                    [w3 addObject:[[next objectAtIndex:2]valueForKey:@"windspeedKmph"] ];
                    
                    [w3 addObject:[[next objectAtIndex:3]valueForKey:@"windspeedKmph"] ];
                    //  //NSlog(@"next1..%@",tempallN);
                    [w3 addObject:[[next objectAtIndex:4]valueForKey:@"windspeedKmph"]];
                    
                    [self.allwindspeedKm addObject:w3];
                    //      //NSlog(@"%@",self.allwindspeedKm);
                    [w3 release];
                    //  //NSlog(@"%@",self.allwindspeedKm);
                    NSMutableArray*w4=[[NSMutableArray alloc]init];
                    [w4 addObject:[[next objectAtIndex:0] valueForKey:@"windspeedMiles"] ];
                    [w4 addObject:[[next objectAtIndex:1]valueForKey:@"windspeedMiles"] ];
                    
                    [w4 addObject:[[next objectAtIndex:2]valueForKey:@"windspeedMiles"] ];
                    // //NSlog(@"next..%@",tempallN);
                    [w4 addObject:[[next objectAtIndex:3]valueForKey:@"windspeedMiles"] ];
                    //  //NSlog(@"next1..%@",tempallN);
                    [w4 addObject:[[next objectAtIndex:4]valueForKey:@"windspeedMiles"]];
                    
                    [self.allwindspeedM addObject:w4];
                    //    //NSlog(@"%@",self.allwindspeedM);
                    [w4 release];
                    NSMutableArray*next1=[[NSMutableArray alloc]init];
                    [next1 addObject:[[next objectAtIndex:0] valueForKey:@"tempMaxC"] ];
                    //    //NSlog(@"next1..%@",next1);
                    [next1 addObject:[[next objectAtIndex:1]valueForKey:@"tempMaxC"] ];
                    //    //NSlog(@"next1..%@",next1);
                    [next1 addObject:[[next objectAtIndex:2]valueForKey:@"tempMaxC"] ];
                    //   //NSlog(@"next..%@",next1);
                    [next1 addObject:[[next objectAtIndex:3]valueForKey:@"tempMaxC"] ];
                    //  //NSlog(@"next1..%@",next1);
                    [next1 addObject:[[next objectAtIndex:4]valueForKey:@"tempMaxC"]];
                    //    //NSlog(@"next1..%@",next1);
                    [self.tempMaxC addObject:next1];
                    [next1 release];
                    NSMutableArray*nextLow=[[NSMutableArray alloc]init];
                    [nextLow addObject:[[next objectAtIndex:0] valueForKey:@"tempMinC"] ];
                    //      //NSlog(@"next1..%@",nextLow);
                    [nextLow addObject:[[next objectAtIndex:1]valueForKey:@"tempMinC"] ];
                    //      //NSlog(@"next1..%@",nextLow);
                    [nextLow addObject:[[next objectAtIndex:2]valueForKey:@"tempMinC"] ];
                    //     //NSlog(@"next..%@",nextLow);
                    [nextLow addObject:[[next objectAtIndex:3]valueForKey:@"tempMinC"] ];
                    //     //NSlog(@"next1..%@",nextLow);
                    [nextLow addObject:[[next objectAtIndex:4]valueForKey:@"tempMinC"]];
                    //     //NSlog(@"next1..%@",nextLow);
                    [self.tempMinC addObject:nextLow];
                    [nextLow release];
                    //day of weak
                    NSMutableArray*nextdate=[[NSMutableArray alloc]init];
                    [nextdate addObject:[[next objectAtIndex:0] valueForKey:@"date"] ];
                    //     //NSlog(@"next1..%@",nextdate);
                    [nextdate addObject:[[next objectAtIndex:1]valueForKey:@"date"] ];
                    //     //NSlog(@"next1..%@",nextdate);
                    [nextdate addObject:[[next objectAtIndex:2]valueForKey:@"date"] ];
                    //    //NSlog(@"next..%@",nextdate);
                    [nextdate addObject:[[next objectAtIndex:3]valueForKey:@"date"] ];
                    //NSlog(@"next1..%@",nextdate);
                    [nextdate addObject:[[next objectAtIndex:4]valueForKey:@"date"]];
                    //     //NSlog(@"next1..%@",nextdate);
                    [self.dayofweak addObject:nextdate];
                    //       //NSlog(@"%@",self.dayofweak);
                    [nextdate release];
                    //..............................
                    //weather Forcast icon
                    NSMutableArray*nextweather=[[NSMutableArray alloc]init];
                    [nextweather addObject:[[[[next objectAtIndex:0] valueForKey:@"weatherDesc"] objectAtIndex:0]valueForKey:@"value"]];
                    //   //NSlog(@"next1..%@",nextweather);
                    [nextweather addObject:[[[[next objectAtIndex:1] valueForKey:@"weatherDesc"] objectAtIndex:0]valueForKey:@"value"]];
                    
                    //    //NSlog(@"next1..%@",nextweather);
                    [nextweather addObject:[[[[next objectAtIndex:2] valueForKey:@"weatherDesc"] objectAtIndex:0]valueForKey:@"value"]];
                    
                    //   //NSlog(@"next..%@",nextweather);
                    [nextweather addObject:[[[[next objectAtIndex:3] valueForKey:@"weatherDesc"] objectAtIndex:0]valueForKey:@"value"]];
                    
                    //   //NSlog(@"next1..%@",nextweather);
                    [nextweather addObject:[[[[next objectAtIndex:4] valueForKey:@"weatherDesc"] objectAtIndex:0]valueForKey:@"value"]];
                    
                    //NSlog(@"next1..%@",nextweather);
                    
                    [self.weatherForcast addObject:nextweather];
                    [nextweather release];
                    //..............................
                    [self.currentlocationlbl addObject: [[data objectAtIndex:0]valueForKey:@"query"]];
                    //NSlog(@"%@",self.currentlocationlbl);
                    
                    NSDictionary*temp=[city valueForKey:@"current_condition"];
                    //    //NSlog(@"%@",temp);
                    [self.tempratureClbl addObject:[[temp valueForKey:@"temp_C"]objectAtIndex:0]];
                    [self.ctemp_F addObject:[[temp valueForKey:@"temp_F"]objectAtIndex:0]];
                    //NSlog(@"FFFF%@",self.ctemp_F);
                    //NSlog(@"%@",self.tempratureClbl);
                    //   mine=@"fwerwer";
                    //    //NSlog(@"%@",self.currentlocationlbl);
                    NSString*condition=[[[[[city objectForKey:@"current_condition"]valueForKey:@"weatherDesc"]objectAtIndex:0]objectAtIndex:0]valueForKey:@"value"];
                    [self.status addObject:[NSString stringWithFormat:@"%@",condition]];
                    //NSlog(@"%@",self.status);
                    [self.cloudcoverD addObject:[[[city valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"cloudcover"]];
                    //   //NSlog(@"%@",self.cloudcoverD);
                    [self.humidityD addObject:[[[city valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"humidity"]];
                    //  //NSlog(@"%@",self.humidityD);
                    [self.observationTimeD addObject:[[[city valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"observation_time"]];
                    // //NSlog(@"%@",self.observationTimeD);
                    [self.precipitationD addObject:[[[city valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"precipMM"]];
                    //  //NSlog(@"%@",self.precipitationD);
                    [self.pressureD addObject:[[[city valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"pressure"]];
                    //   //NSlog(@"%@",self.pressureD);
                    [self.visibility addObject:[[[city valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"visibility"]];
                    //   //NSlog(@"%@",self.visibility);
                    [self.winddirdegree addObject:[[[city valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"winddirDegree"]];
                    [self.windspeedKm addObject:[[[city valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"windspeedKmph"]];
                    [self.winddir16Point addObject:[[[city valueForKey:@"current_condition"]objectAtIndex:0]valueForKey:@"winddir16Point"]];
                    // //NSlog(@"%@",self.winddirdegree);
                    // //NSlog(@"%@",self.windspeedKm);
                    
                    
                    NSString *responseString1 = [[[NSString alloc] initWithData:newData1 encoding:NSUTF8StringEncoding]autorelease];
                    NSDictionary *jsonObject1 = [responseString1 JSONValue];
                    //Accessing JSON content
                    //  //NSlog(@"Dictionay %@",jsonObject1);
                    
                    NSDictionary*temp1=[jsonObject1 objectForKey:@"data"];
                    // //NSlog(@"%@",temp1);
                    NSMutableArray*tempArray=[temp1 valueForKey:@"time_zone"];
                    //NSlog(@"timezone......%@",tempArray);
                    NSString*temp2=[[tempArray objectAtIndex:0]valueForKey:@"localtime" ];
                    //        NSMutableArray*data=[city objectForKey:@"request"];
                    //  //NSlog(@"%@",temp2);
                    [self.tz addObject:temp2];
                    //   //NSlog(@"timeZone%@",self.tz);
                    //Getloatlons of favlocation and other related info
                    NSString *Searchurl = [NSString stringWithFormat:@"http://www.worldweatheronline.com/feed/search.ashx?key=8fd1b046af051040132202&query=%@&num_of_results=3&format=json",locaddress];
                    
                    NSMutableURLRequest *Srequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",Searchurl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    //NSlog(@"urlRequest %@",Srequest);
                    
                    NSHTTPURLResponse* SurlResponse = nil;
                    NSError *Serror = nil;
                    
                    NSData *SnewData = [NSURLConnection sendSynchronousRequest:Srequest returningResponse:&SurlResponse error:&Serror];
                    
                    if([SnewData length] && Serror == nil ){
                        NSString *SresponseString = [[[NSString alloc] initWithData:SnewData encoding:NSUTF8StringEncoding]autorelease];
                        NSDictionary *SjsonObject = [SresponseString JSONValue];
                        //Accessing JSON content
                        //NSlog(@"Dictionay %@",SjsonObject);
                        
                        NSMutableArray*Sdata=[[SjsonObject objectForKey:@"search_api"]objectForKey:@"result"];
                        //NSlog(@"%@",Sdata);
                        self.fav_locationDetailDict=[[NSMutableDictionary alloc]init];
                        //   //NSlog(@"%@",[[Sdata objectAtIndex:0]valueForKey:@"latitude"]);
                        [fav_locationDetailDict setObject:[[Sdata objectAtIndex:0]valueForKey:@"latitude"] forKey:@"latitude"];
                        
                        [fav_locationDetailDict setObject:[[Sdata objectAtIndex:0]valueForKey:@"longitude"] forKey:@"longitude"];
                        if([[Sdata objectAtIndex:0]valueForKey:@"areaName"])
                        {
                            NSString*concat=[[[[Sdata objectAtIndex:0]valueForKey:@"areaName"] objectAtIndex:0]valueForKey:@"value"];
                            concat=[concat stringByAppendingString:@","];
                            concat=[concat stringByAppendingString:[[[[Sdata objectAtIndex:0]valueForKey:@"country"] objectAtIndex:0]valueForKey:@"value"]];
                            
                            [fav_locationDetailDict setObject:concat forKey:@"area"];
                        }
                        
                        if([[Sdata objectAtIndex:0]valueForKey:@"country"])
                        {
                            [fav_locationDetailDict setObject:[[[[Sdata objectAtIndex:0]valueForKey:@"country"] objectAtIndex:0]valueForKey:@"value"] forKey:@"country"];
                        }
                        
                        if([[Sdata objectAtIndex:0]valueForKey:@"region"])
                        {
                            [fav_locationDetailDict setObject:[[[[Sdata objectAtIndex:0]valueForKey:@"region"]objectAtIndex:0] valueForKey:@"value"] forKey:@"region"]; 
                        }
                        
                        
                        //   //NSlog(@"%@",fav_locationDetailDict);
                        [fav_locationDetailDictAll addObject:self.fav_locationDetailDict];
                        
                        //NSlog(@"%@",fav_locationDetailDictAll);
                        [self recentSearch:dbcounter];
                        if([currentWeather.searchText length]==0)
                        {
                            if (isAddToRecord==YES) {
                                dbcounter=0;
                            }
                            [self addNewData:dbcounter];
                            isAddToRecord=NO;
                            dbcounter++;
                            
                        }
                    }
                    
                }
                
            }
        }
       }
}
}
#pragma mark-location Manager
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    //NSlog(@"error");
    
    UIAlertView*alerterror=[[UIAlertView alloc]initWithTitle:@"Weather Finder" message:@"Unable to Find the Location! Would you like to See Previous Weather?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alerterror.tag=545251;
    [activityView addSubview:alerterror];
    [alerterror show];
     //[self tabbarcall];
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
     [FBSession.activeSession handleDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSlog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataBase" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataBase.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        //NSlog(@"Unresolved error %@, %@", error, [error userInfo]);
        //Don't use abort() in a production environment. It is better to use an UIAlertView
        UIAlertView*alertabort=[[UIAlertView alloc]initWithTitle:@"Weather Finder" message:@"Application Aborted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
          [activityView addSubview:alertabort];
           [alertabort show];
        exit(1);
        //and ask users to quick app using the home button.
       // abort();
    }
    
    return _persistentStoreCoordinator;
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma Store Data Using Core data...

-(void)addNewData:(int)count
{
    [locationManager stopUpdatingLocation];
//fetch records from locationstable
//    NSFetchRequest *fetchRequest0 = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity0 =[NSEntityDescription
//                                   entityForName:@"LocationsTable" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest0 setEntity:entity0];
//    NSError *requestError0 = nil;
//    /* And execute the fetch request on the context */
//    NSArray *DataTable0 =
//    [self.managedObjectContext executeFetchRequest:fetchRequest0
//                                             error:&requestError0];
   NSArray*DataTable0=[self CommonGetFromDB:@"LocationsTable" locID:nil];
   // //NSlog(@"%@",DataTable0);
    NSMutableArray*locid0=[[NSMutableArray alloc]init];
    NSMutableArray*locAddress=[[NSMutableArray alloc]init];
    NSUInteger counter=0;
     if ([DataTable0 count] > 0){
        
         
        for (LocationsTable *theLoc in DataTable0){
            
            [locid0 addObject:theLoc.location_ID];
            [locAddress addObject:theLoc.location_Name];
            counter++;
        }
    }
    else {
        ////NSlog(@"Could not find any entities in the context.");
    }
    BOOL isNotReadyToAdd=NO;
    if ([locAddress count]>0) {
      // //NSlog(@"%@",locid0);
       // //NSlog(@"%@",fav_locationDetailDictAll);
        if (isCurrentLocationChanged==YES) {
            isNotReadyToAdd=YES;
           [self updatelocationsDataBase:[NSNumber numberWithInt:0]];
            [self upDateRecentDataBase:0 counter:0];
            [self upDatePreviousDataBase:0 counter:0];
            [self upDateForecastDataBase:0 counter:0];
            [self updateDayHistory:0 counter:0];
           
        }
       else
        {
        
        for (int t=0; t<[locAddress count]; t++) {
            if ([[[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"area"] isEqualToString:[locAddress objectAtIndex:t]])
            {
              //  //NSlog(@"%d",count);
                //NSlog(@"%@",[locid0 objectAtIndex:t]);
                isNotReadyToAdd=YES;
                [self upDateRecentDataBase:[locid0 objectAtIndex:t] counter:count];
                [self upDatePreviousDataBase:[locid0 objectAtIndex:t]counter:count];
                [self upDateForecastDataBase:[locid0 objectAtIndex:t]counter:count];
                [self updateDayHistory:[locid0 objectAtIndex:t]counter:count];
              //  [self DayHourHistorydatabase:[locid0 objectAtIndex:t] loc:<#(LocationsTable *)#>]
                //isNotReadyToAdd=NO;
                
                
            }
        }
    }
    }
     isCurrentLocationChanged=NO;
    if(isNotReadyToAdd==NO || [locid0 count]==0)
    {
        int counterAdd=count;
        ////NSlog(@"%d",count);
        if ([loc_ids count]>0) {
            counterAdd=[[loc_ids lastObject] intValue]+1;
        }
        //NSlog(@"%@",fav_locationDetailDictAll);
        //[self AddNewRowToDb:counterAdd:counter1:count];
        [self AddNewRowToDb:counterAdd counter1:count];
        
    }
    
     else
     {
         
     }
    [locid0 release];
    [locAddress release];
    [locationManager stopUpdatingLocation];
}
-(void)AddNewRowToDb:(int)countAdd counter1:(int)count
{
    LocationsTable *place=[self locationsDataBase:count counterAdd:countAdd];
    [self recentdatabase:count loc:place];
    [self previousdatabase:count loc:place];
    [ self forecaste:count loc:place];
    [self DayHourHistorydatabase:count loc:place];
}
-(void)updatelocationsDataBase:(NSNumber*)loc_id
{
    NSManagedObjectContext *objManagedObjectContext = nil;
    //NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    
    NSEntityDescription *uLoc=[NSEntityDescription entityForName:@"LocationsTable" inManagedObjectContext:objManagedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:uLoc];
    //[fetch setFetchLimit:5];
    //NSlog(@"%@",loc_id);
    NSPredicate *lid=[NSPredicate predicateWithFormat:@"location_ID== %@", loc_id];
    [fetch setPredicate:lid];
    //... add sorts if you want them
    NSError *fetchError;
    NSMutableArray *fetchedResult1=[[self.managedObjectContext executeFetchRequest:fetch error:&fetchError] mutableCopy];
    [fetch release];
    //NSlog(@"%@",fetchedResult1);

    for (NSManagedObject *result in fetchedResult1) {
        //NSlog(@"%@",result);
        if([[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"area"])
        {
            [result setValue:[[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"area"] forKey:@"location_Name"];
            

        }
        else
        {
            [result setValue:@"NA" forKey:@"location_Name"];
            

        }
        //NSlog(@"%@",[[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"area"]);
        if([[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"region"])
        {
          [result setValue:[[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"region"] forKey:@"region_DataModel"];
        }
        else
        {
            [result setValue:@"NA"forKey:@"region_DataModel"];
        }
        if([[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"country"])
        {
            [result setValue:[[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"country"] forKey:@"country_DataModel"];
        }
        else
        {
            [result setValue:@"NA" forKey:@"country_DataModel"];
        }
        [result setValue:[[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"latitude"]forKey:@"latitude_DataModel"];
       
        [result setValue:[[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"longitude"] forKey:@"longitude_DataModel"];
        [self.managedObjectContext save:nil];
    }
    
}
-(void)upDateForecastDataBase:(NSNumber*)loc_id counter:(int)count
{
  
    NSManagedObjectContext *objManagedObjectContext = nil;
   // //NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    
    NSEntityDescription *forcast=[NSEntityDescription entityForName:@"TodayForecastWeatherTable" inManagedObjectContext:objManagedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:forcast];
        //[fetch setFetchLimit:5];
    ////NSlog(@"%@",loc_id);
    NSPredicate *lid=[NSPredicate predicateWithFormat:@"location_ID=%@", loc_id];
    [fetch setPredicate:lid];
    //... add sorts if you want them
    NSError *fetchError;
    NSMutableArray *fetchedResult1=[[self.managedObjectContext executeFetchRequest:fetch error:&fetchError] mutableCopy];
        [fetch release];
   // //NSlog(@"%@",fetchedResult1);
    int d=0;
    
    for (NSManagedObject *result in fetchedResult1) {
       
        [result setValue:[[self.dayofweak objectAtIndex:count] objectAtIndex:d]forKey:@"dateForecast_Datamodel"];
        
        
        [result setValue:[[self.tempMaxC objectAtIndex:count]objectAtIndex:d]forKey:@"maxTempForecast_DataModel"];
        [result setValue:[[self.tempMinC objectAtIndex:count]objectAtIndex:d]forKey:@"minTempForecast_DataModel"];
        [result setValue:[[self.alltempMaxF objectAtIndex:count]objectAtIndex:d]forKey:@"maxFTempForecast_DataModel"];
       // //NSlog(@"%@",[[self.alltempMinF objectAtIndex:count]objectAtIndex:d]);
        [result setValue:[[self.alltempMinF objectAtIndex:count]objectAtIndex:d]forKey:@"minFTempForecast_DataModel"];
        [result setValue:[[self.allwindspeedM objectAtIndex:count]objectAtIndex:d]forKey:@"wSpeedMileForecast_Datamodel"];
        [result setValue:[[self.allprepD objectAtIndex:count]objectAtIndex:d]forKey:@"prcipForecast_Datamodel"];
        [result setValue:[NSNumber numberWithInt:d]forKey:@"srNo"];
        [result setValue:[[self.allwindspeedKm objectAtIndex:count]objectAtIndex:d] forKey:@"wSpeedKmForecast_Datamodel"];
        [result setValue:[[self.allwindD objectAtIndex:count]objectAtIndex:d]forKey:@"windStatusForecast_Datamodel"];
        [result setValue:[[self.allwindD objectAtIndex:count]objectAtIndex:d] forKey:@"windDirForecast_DataModel"];
        [result setValue:[[self.allwinddir16Point objectAtIndex:count]objectAtIndex:d]forKey:@"wind16Forecast_DataModel"];
        [result setValue:[[self.weatherForcast objectAtIndex:count]objectAtIndex:d]forKey:@"weatherStatus"];
        [self.managedObjectContext save:nil];
        d++;
    
    }
}

-(void)upDatePreviousDataBase:(NSNumber*)loc_id counter:(int)count
{
    NSFetchRequest *fetchRequest0 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity0 =[NSEntityDescription
                                   entityForName:@"PreviousWeatherTable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest0 setEntity:entity0];
    NSPredicate *lid=[NSPredicate predicateWithFormat:@"location_ID=%@",loc_id];
    [fetchRequest0 setPredicate:lid];
   // //NSlog(@"%@",loc_id);
    NSError *requestError0 = nil;
    /* And execute the fetch request on the context */
    NSArray *DataTable0 =
    [self.managedObjectContext executeFetchRequest:fetchRequest0
                                             error:&requestError0];
   // //NSlog(@"%@",DataTable0);
    if ([DataTable0 count]==10) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PreviousWeatherTable" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *lid=[NSPredicate predicateWithFormat:@"location_ID=%@",loc_id];
        [fetchRequest setPredicate:lid];
        [fetchRequest setFetchLimit:1];
        
        NSError *error;
        NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
        [fetchRequest release];
        
        
        for (NSManagedObject *managedObject in items) {
            [_managedObjectContext deleteObject:managedObject];
            
            
        }
        if (![_managedObjectContext save:&error]) {
            
        }
    }

    NSString*LatedDate=[[NSString alloc]init];
    NSNumber*locID=[[NSNumber alloc]init];
   
    if ([DataTable0 count] > 0 && [DataTable0 count]<10){
        
        NSUInteger counter = 1;
        for (PreviousWeatherTable *theLoc in DataTable0){
            ////NSlog(@"%@",theLoc.datePrevious_Datamodel);
            
            LatedDate=[NSString stringWithFormat:@"%@",theLoc.datePrevious_Datamodel];
            
            locID=theLoc.location_ID;
            counter++; }
    }
    else {
       // //NSlog(@"Could not find any Student entities in the context.");
    }
    /*
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:LatedDate];
    //NSlog(@"date///%@",date);
   
    NSDate *date1 = [dateFormatter dateFromString:[listItems objectAtIndex:0]];
    //NSlog(@"date///%@",date1);
*/
    NSString *time = [self.tz objectAtIndex:0];
    NSArray *listItems = [time componentsSeparatedByString:@" "];
    if (![LatedDate isEqualToString:[listItems objectAtIndex:0]])
    {
        NSManagedObjectContext *objManagedObjectContext = nil;
        //NSlog(@"%@", [self managedObjectContext]);
        objManagedObjectContext=[self managedObjectContext];
        PreviousWeatherTable *previous=(PreviousWeatherTable*)[NSEntityDescription insertNewObjectForEntityForName:@"PreviousWeatherTable" inManagedObjectContext:objManagedObjectContext];
       // //NSlog(@"%@",place);
        previous.previouslocationID=nil;
        
        [previous setValue:locID forKey:@"location_ID"];
        [previous setValue:[self.tempratureClbl objectAtIndex:count] forKey:@"tempPrevious_Datamodel"];
        
       // //NSlog(@"%@",[self.cloudcoverD objectAtIndex:count]);
        NSString *time = [self.tz objectAtIndex:0];
        NSArray *listItems = [time componentsSeparatedByString:@" "];
        
        [previous setValue:[listItems objectAtIndex:0]forKey:@"datePrevious_Datamodel"];
        [previous setValue:[self.cloudcoverD objectAtIndex:count]forKey:@"cloudcoverPrevious"];
        [previous setValue:[self.humidityD objectAtIndex:count]forKey:@"humidityPrevious"];
        [previous setValue:[self.pressureD objectAtIndex:count]forKey:@"pressurePrevious"];
        [previous setValue:[[self.tempMaxC objectAtIndex:count] objectAtIndex:0]forKey:@"maxTempPrevious_DataModel"];
        [previous setValue:[[self.tempMinC objectAtIndex:count]objectAtIndex:0]forKey:@"minTempPrevious_DataModel"];
        [previous setValue:[self.visibility objectAtIndex:count]forKey:@"visibilityPrevious"];
        [previous setValue:[self.precipitationD objectAtIndex:count]forKey:@"prcipPrevious_Datamodel"];
        //NSlog(@"%@",[[self.allwindspeedM objectAtIndex:count]objectAtIndex:0]);
        [previous setValue:[[self.allwindspeedM objectAtIndex:count]objectAtIndex:0 ]forKey:@"windSpeedMilePrevious_Datamodel"];
        [previous setValue:[NSNumber numberWithInt:count] forKey:@"srNo"];
        [previous setValue:[[self.allwindD objectAtIndex:count]objectAtIndex:0]forKey:@"windStatusPrevious_Datamodel"];
        [previous setValue:[[self.allwinddirDegree objectAtIndex:count]objectAtIndex:0] forKey:@"windDirPrevious_DataModel"];
        [previous setValue:[[self.allwinddir16Point objectAtIndex:count]objectAtIndex:0]forKey:@"wind16Previous_DataModel"];
        [previous setValue:[[self.weatherForcast objectAtIndex:count]objectAtIndex:0]forKey:@"weatherStatusPrevious_DataModel"];
        [previous setValue:[[self.allwindspeedKm objectAtIndex:count]objectAtIndex:0]forKey:@"windSpeedKmPrevious_Datamodel"];
        //
        
        NSError *error1=nil;
        if(![_managedObjectContext save:&error1])
        {
            //NSlog(@"Can't save! %@ %@",error1,[error1 localizedDescription]);
        }
        

    }
    else
    {
    
    NSManagedObjectContext *objManagedObjectContext = nil;
    ////NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    
    NSEntityDescription *previous=[NSEntityDescription entityForName:@"PreviousWeatherTable" inManagedObjectContext:objManagedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:previous];
        NSPredicate *lid=[NSPredicate predicateWithFormat:@"location_ID==%@", loc_id];
        [fetch setPredicate:lid];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datePrevious_Datamodel" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetch setSortDescriptors:sortDescriptors];
    [fetch setFetchLimit:1];
    [sortDescriptor release];
        //... add sorts if you want them
    NSError *fetchError;
    NSArray *fetchedResult=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    ////NSlog(@"%@",fetchedResult);
    for (NSManagedObject *result in fetchedResult) {
      //  //NSlog(@"%@",result);
       // //NSlog(@"%@",[self.tempratureClbl objectAtIndex:count]);
        [result setValue:[self.tempratureClbl objectAtIndex:count] forKey:@"tempPrevious_Datamodel"];
        
       // //NSlog(@"%@",[self.cloudcoverD objectAtIndex:count]);
       // NSString *time = [self.tz objectAtIndex:0];
       
        [result setValue:[self.cloudcoverD objectAtIndex:count]forKey:@"cloudcoverPrevious"];
        [result setValue:[self.humidityD objectAtIndex:count]forKey:@"humidityPrevious"];
        [result setValue:[self.pressureD objectAtIndex:count]forKey:@"pressurePrevious"];
        [result setValue:[[self.tempMaxC objectAtIndex:count] objectAtIndex:0]forKey:@"maxTempPrevious_DataModel"];
        [result setValue:[[self.tempMinC objectAtIndex:count]objectAtIndex:0]forKey:@"minTempPrevious_DataModel"];
        [result setValue:[self.visibility objectAtIndex:count]forKey:@"visibilityPrevious"];
        [result setValue:[self.precipitationD objectAtIndex:count]forKey:@"prcipPrevious_Datamodel"];
       // //NSlog(@"%@",[[self.allwindspeedM objectAtIndex:count]objectAtIndex:0]);
        [result setValue:[[self.allwindspeedM objectAtIndex:count]objectAtIndex:0 ]forKey:@"windSpeedMilePrevious_Datamodel"];
        [result setValue:[NSNumber numberWithInt:count] forKey:@"srNo"];
        [result setValue:[[self.allwindD objectAtIndex:count]objectAtIndex:0]forKey:@"windStatusPrevious_Datamodel"];
        [result setValue:[[self.allwinddirDegree objectAtIndex:count]objectAtIndex:0] forKey:@"windDirPrevious_DataModel"];
        [result setValue:[[self.allwinddir16Point objectAtIndex:count]objectAtIndex:0]forKey:@"wind16Previous_DataModel"];
        [result setValue:[[self.weatherForcast objectAtIndex:count]objectAtIndex:0]forKey:@"weatherStatusPrevious_DataModel"];
        [result setValue:[[self.allwindspeedKm objectAtIndex:count]objectAtIndex:0]forKey:@"windSpeedKmPrevious_Datamodel"];
        [self.managedObjectContext save:nil];
    }
    }
}

-(void)upDateRecentDataBase:(NSNumber*)loc_id counter:(int)count
{
    NSManagedObjectContext *objManagedObjectContext = nil;
    //NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];

    NSEntityDescription *recent=[NSEntityDescription entityForName:@"RecentWeatherTable" inManagedObjectContext:objManagedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:recent];
    NSPredicate *lid=[NSPredicate predicateWithFormat:@"location_ID== %@", loc_id];
    [fetch setPredicate:lid];
    //... add sorts if you want them
    NSError *fetchError;
    NSArray *fetchedResults=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    //NSlog(@"%@",fetchedResults);
    
    for (NSManagedObject *result in fetchedResults) {
        //NSlog(@"%@",result);
        //NSlog(@"%@",[self.cloudcoverD objectAtIndex:count]);
        [result setValue:[self.cloudcoverD objectAtIndex:count] forKey:@"cloudcover_DataModel"];
        
        //NSlog(@"%@",[self.cloudcoverD objectAtIndex:count]);
        
        NSString *time = [self.tz objectAtIndex:count];
        NSArray *listItems = [time componentsSeparatedByString:@" "];
        //
        [result setValue:[listItems objectAtIndex:0]forKey:@"dateToday_DataModel"];
        [result setValue:[self.humidityD objectAtIndex:count]forKey:@"humidity_DataModel"];
        [result setValue:[[self.tempMaxC objectAtIndex:count]objectAtIndex:0]forKey:@"maxTemp_DataModel"];
        [result setValue:[[self.tempMinC objectAtIndex:count]objectAtIndex:0]forKey:@"minTemp_DataModel"];
        [result setValue:[self.observationTimeD objectAtIndex:count]forKey:@"observeTime_DataModel"];
        [result setValue:[self.precipitationD objectAtIndex:count]forKey:@"precipitation_DataModel"];
        [result setValue:[self.pressureD objectAtIndex:count]forKey:@"pressure_DataModel"];
        ////    [recent setValue:count forKey:@"srNo"];
        [result setValue:[self.tempratureClbl objectAtIndex:count]forKey:@"temp_DataModel"];
        [result setValue:[listItems objectAtIndex:1] forKey:@"timeNow_DataModel"];
        [result setValue:[self.visibility objectAtIndex:count]forKey:@"visibility_DataModel"];
        [result setValue:[self.status objectAtIndex:count]forKey:@"weatherStatus_DataModel"];
        [result setValue:[self.ctemp_F objectAtIndex:count]forKey:@"tempF_DataModel"];
          [self.managedObjectContext save:nil];
  
    }

    
      

}
-(LocationsTable*)locationsDataBase:(int)count counterAdd:(int)countAdd
{
    
    NSManagedObjectContext *objManagedObjectContext = nil;
    ////NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    LocationsTable *place=(LocationsTable*)[NSEntityDescription insertNewObjectForEntityForName:@"LocationsTable" inManagedObjectContext:objManagedObjectContext];
    
    
    [place setValue:[NSNumber numberWithInt:countAdd] forKey:@"location_ID"];
    if([[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"area"])
    {
      
        [place setValue:[[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"area"] forKey:@"location_Name"];
    }
    else
    {
       [place setValue:@"NA" forKey:@"location_Name"];
    }
    
    //NSlog(@"%@",[[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"area"]);
    if([[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"region"])
    {
      [place setValue:[[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"region"] forKey:@"region_DataModel"];   
    }
   else
   {
       [place setValue:@"NA" forKey:@"region_DataModel"];
   }
    if([[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"country"])
    {
        [place setValue:[[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"country"] forKey:@"country_DataModel"];
    }
    else{
        [place setValue:@"NA" forKey:@"country_DataModel"];
    }
    
    [place setValue:[[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"latitude"]forKey:@"latitude_DataModel"];
    [place setValue:[[fav_locationDetailDictAll objectAtIndex:count]valueForKey:@"longitude"] forKey:@"longitude_DataModel"];
    NSError *error=nil;
    if(![_managedObjectContext save:&error])
    {
        //NSlog(@"Can't save! %@ %@",error,[error localizedDescription]);
    }
    return place;
}
-(void)forecaste:(int)count loc:(LocationsTable*)place
{
    NSManagedObjectContext *objManagedObjectContext = nil;
    //NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    for (int d=0; d<5; d++) {
        TodayForecastWeatherTable*forecast=(TodayForecastWeatherTable*)[NSEntityDescription insertNewObjectForEntityForName:@"TodayForecastWeatherTable" inManagedObjectContext:objManagedObjectContext];
        
        
        forecast.tR=place;
        [forecast setValue:place.location_ID forKey:@"location_ID"];
        
        [forecast setValue:[[self.dayofweak objectAtIndex:count] objectAtIndex:d]forKey:@"dateForecast_Datamodel"];
        
        [forecast setValue:[[self.tempMaxC objectAtIndex:count]objectAtIndex:d]forKey:@"maxTempForecast_DataModel"];
        [forecast setValue:[[self.tempMinC objectAtIndex:count]objectAtIndex:d]forKey:@"minTempForecast_DataModel"];
        [forecast setValue:[[self.alltempMaxF objectAtIndex:count]objectAtIndex:d]forKey:@"maxFTempForecast_DataModel"];
        //NSlog(@"%@",[[self.alltempMinF objectAtIndex:count]objectAtIndex:d]);
        [forecast setValue:[[self.alltempMinF objectAtIndex:count]objectAtIndex:d]forKey:@"minFTempForecast_DataModel"];
        [forecast setValue:[[self.allwindspeedM objectAtIndex:count]objectAtIndex:d]forKey:@"wSpeedMileForecast_Datamodel"];
        [forecast setValue:[[self.allprepD objectAtIndex:count]objectAtIndex:d]forKey:@"prcipForecast_Datamodel"];
        [forecast setValue:[NSNumber numberWithInt:d]forKey:@"srNo"];
        [forecast setValue:[[self.allwindspeedKm objectAtIndex:count]objectAtIndex:d] forKey:@"wSpeedKmForecast_Datamodel"];
        [forecast setValue:[[self.allwindD objectAtIndex:count]objectAtIndex:d]forKey:@"windStatusForecast_Datamodel"];
        [forecast setValue:[[self.allwindD objectAtIndex:count]objectAtIndex:d] forKey:@"windDirForecast_DataModel"];
        [forecast setValue:[[self.allwinddir16Point objectAtIndex:count]objectAtIndex:d]forKey:@"wind16Forecast_DataModel"];
        //NSlog(@"%@",[[self.weatherForcast objectAtIndex:count]objectAtIndex:d]);
        [forecast setValue:[[self.weatherForcast objectAtIndex:count]objectAtIndex:d]forKey:@"weatherStatus"];
        NSError *error=nil;
        if(![_managedObjectContext save:&error])
        {
            //NSlog(@"Can't save! %@ %@",error,[error localizedDescription]);
        }
    }
    
    

}
-(void)previousdatabase:(int)count loc:(LocationsTable*)place
{
    NSManagedObjectContext *objManagedObjectContext = nil;
   // //NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    PreviousWeatherTable *previous=(PreviousWeatherTable*)[NSEntityDescription insertNewObjectForEntityForName:@"PreviousWeatherTable" inManagedObjectContext:objManagedObjectContext];
   // //NSlog(@"%@",place);
    previous.previouslocationID=place;
    
    [previous setValue:place.location_ID forKey:@"location_ID"];
    [previous setValue:[self.tempratureClbl objectAtIndex:count] forKey:@"tempPrevious_Datamodel"];
    
  //  //NSlog(@"%@",[self.cloudcoverD objectAtIndex:count]);
    NSString *time = [self.tz objectAtIndex:0];
    NSArray *listItems = [time componentsSeparatedByString:@" "];

    [previous setValue:[listItems objectAtIndex:0]forKey:@"datePrevious_Datamodel"];
    [previous setValue:[self.cloudcoverD objectAtIndex:count]forKey:@"cloudcoverPrevious"];
    [previous setValue:[self.humidityD objectAtIndex:count]forKey:@"humidityPrevious"];
    [previous setValue:[self.pressureD objectAtIndex:count]forKey:@"pressurePrevious"];
    [previous setValue:[[self.tempMaxC objectAtIndex:count] objectAtIndex:0]forKey:@"maxTempPrevious_DataModel"];
    [previous setValue:[[self.tempMinC objectAtIndex:count]objectAtIndex:0]forKey:@"minTempPrevious_DataModel"];
    [previous setValue:[self.visibility objectAtIndex:count]forKey:@"visibilityPrevious"];
    [previous setValue:[self.precipitationD objectAtIndex:count]forKey:@"prcipPrevious_Datamodel"];
    //NSlog(@"%@",[[self.allwindspeedM objectAtIndex:count]objectAtIndex:0]);
    [previous setValue:[[self.allwindspeedM objectAtIndex:count]objectAtIndex:0 ]forKey:@"windSpeedMilePrevious_Datamodel"];
    [previous setValue:[NSNumber numberWithInt:count] forKey:@"srNo"];
    [previous setValue:[[self.allwindD objectAtIndex:count]objectAtIndex:0]forKey:@"windStatusPrevious_Datamodel"];
    [previous setValue:[[self.allwinddirDegree objectAtIndex:count]objectAtIndex:0] forKey:@"windDirPrevious_DataModel"];
    [previous setValue:[[self.allwinddir16Point objectAtIndex:count]objectAtIndex:0]forKey:@"wind16Previous_DataModel"];
    [previous setValue:[[self.weatherForcast objectAtIndex:count]objectAtIndex:0]forKey:@"weatherStatusPrevious_DataModel"];
    [previous setValue:[[self.allwindspeedKm objectAtIndex:count]objectAtIndex:0]forKey:@"windSpeedKmPrevious_Datamodel"];
    //
    
    NSError *error1=nil;
    if(![_managedObjectContext save:&error1])
    {
     //   //NSlog(@"Can't save! %@ %@",error1,[error1 localizedDescription]);
    }
  
}
-(void)recentdatabase:(int)count loc:(LocationsTable*)place
{
    NSManagedObjectContext *objManagedObjectContext = nil;
   // //NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    RecentWeatherTable *recent=(RecentWeatherTable*)[NSEntityDescription insertNewObjectForEntityForName:@"RecentWeatherTable" inManagedObjectContext:objManagedObjectContext];
     ////NSlog(@"%@",place);
    recent.locationID=place;
    [recent setValue:place.location_ID forKey:@"location_ID"];
    [recent setValue:[self.cloudcoverD objectAtIndex:count] forKey:@"cloudcover_DataModel"];
    
   // //NSlog(@"%@",[self.cloudcoverD objectAtIndex:count]);
    
    NSString *time = [self.tz objectAtIndex:count];
    NSArray *listItems = [time componentsSeparatedByString:@" "];
    
    [recent setValue:[listItems objectAtIndex:0]forKey:@"dateToday_DataModel"];
    [recent setValue:[self.humidityD objectAtIndex:count]forKey:@"humidity_DataModel"];
    [recent setValue:[[self.tempMaxC objectAtIndex:count]objectAtIndex:0]forKey:@"maxTemp_DataModel"];
    [recent setValue:[[self.tempMinC objectAtIndex:count]objectAtIndex:0]forKey:@"minTemp_DataModel"];
    [recent setValue:[self.observationTimeD objectAtIndex:count]forKey:@"observeTime_DataModel"];
    [recent setValue:[self.precipitationD objectAtIndex:count]forKey:@"precipitation_DataModel"];
    [recent setValue:[self.pressureD objectAtIndex:count]forKey:@"pressure_DataModel"];
   [recent setValue:[NSNumber numberWithInt:count] forKey:@"srNo"];
    [recent setValue:[self.tempratureClbl objectAtIndex:count]forKey:@"temp_DataModel"];
    [recent setValue:[listItems objectAtIndex:1] forKey:@"timeNow_DataModel"];
    [recent setValue:[self.visibility objectAtIndex:count]forKey:@"visibility_DataModel"];
    [recent setValue:[self.status objectAtIndex:count]forKey:@"weatherStatus_DataModel"];
    [recent setValue:[self.ctemp_F objectAtIndex:count]forKey:@"tempF_DataModel"];
    NSError *error=nil;
    if(![_managedObjectContext save:&error])
    {
       // //NSlog(@"Can't save! %@ %@",error,[error localizedDescription]);
    }
    

}
-(void)updateDayHistory:(NSNumber*)loc_id counter:(int)count
{
    
    //NSFetchRequest *fetchRequest0 = [[NSFetchRequest alloc] init];
    //NSEntityDescription *entity0 =[NSEntityDescription
//                                   entityForName:@"DayHourHistoryTable" inManagedObjectContext:self.managedObjectContext];
//    //[fetchRequest0 setEntity:entity0];
    //NSPredicate *lid=[NSPredicate predicateWithFormat:@"location_ID=%@", loc_id];
   // [fetchRequest0 setPredicate:lid];
   // //NSlog(@"%@",loc_id);
   // NSError *requestError0 = nil;
    /* And execute the fetch request on the context */
    
   // NSArray *DataTable0 =
   // [self.managedObjectContext executeFetchRequest:fetchRequest0
                                            // error:&requestError0];
    NSArray*DataTable0=[self CommonGetFromDB:@"DayHourHistoryTable" locID:loc_id];
    ////NSlog(@"%@",DataTable0);
    NSString*LatedTime=[[[NSString alloc]init]autorelease];
    NSNumber*locID=[[[NSNumber alloc]init]autorelease];
    NSString*day=[[[NSString alloc]init]autorelease];
    
    NSArray *listItems1,*stime;
    
    NSString *time = [self.tz objectAtIndex:count];
    NSArray *listItems = [time componentsSeparatedByString:@" "];
    ////NSlog(@"%@",listItems);
    
    
   if ([DataTable0 count] > 0){
        
        NSUInteger counter = 1;
        for (DayHourHistoryTable *theLoc in DataTable0){
          //  //NSlog(@"%@",theLoc.timeNow_DataModel);
            day=theLoc.dateToday_DataModel;
            LatedTime=[NSString stringWithFormat:@"%@",theLoc.timeNow_DataModel];
            locID=theLoc.location_ID;
           // dayHOBJ=theLoc;
            counter++; }
        
        stime=[[listItems objectAtIndex:1] componentsSeparatedByString:@":"];
        
        listItems1 = [LatedTime componentsSeparatedByString:@":"];
      //  //NSlog(@"%@",[listItems1 objectAtIndex:0]);
      //  //NSlog(@"%@",[stime objectAtIndex:0]);
        //Insert New Row if time Changed
       /*
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormatter dateFromString:day];
        //NSlog(@"date///%@",date);
        //NSString *day1 = [listItems objectAtIndex:0];
        //NSArray *listItems = [time componentsSeparatedByString:@" "];
        date1 = [dateFormatter dateFromString:[listItems objectAtIndex:0]];
        //NSlog(@"date///%@",date1);
        
*/
        
    }
    else {
       // //NSlog(@"Could not find  entities in the context.");
    }
   
    if ([DataTable0 count]==0||([[listItems1 objectAtIndex:0]intValue]<[[stime objectAtIndex:0]intValue]&& [day isEqualToString:[listItems objectAtIndex:0]]))
    {
        [self updateDayHistory:count loc:loc_id];
    }
    
    else if(![day isEqualToString:[listItems objectAtIndex:0]])
    {
    //[self deleteAllObjects:@"DayHourHistoryTable"];
        DataTable0 =[self CommonGetFromDB:@"DayHourHistoryTable" locID:loc_id];
        for (NSManagedObject *managedObject in DataTable0) {
            [_managedObjectContext deleteObject:managedObject];
           // //NSlog(@"%@ object deleted",entityDescription);
        }
        NSError *error;
        if (![_managedObjectContext save:&error]) {
           // //NSlog(@"Error deleting %@ - error:%@",entityDescription,error);
        }

//                                                 error:&requestError0];
        //NSlog(@"%@",DataTable0);
        [self updateDayHistory:count loc:loc_id];
    }
 
}
-(void)updateDayHistory:(int)count loc:(NSNumber*)loc_id
{
    NSString *time = [self.tz objectAtIndex:count];
    NSArray *listItems = [time componentsSeparatedByString:@" "];
    //NSlog(@"%@",listItems);
    NSManagedObjectContext *objManagedObjectContext = nil;
    //NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    DayHourHistoryTable *recent=(DayHourHistoryTable*)[NSEntityDescription insertNewObjectForEntityForName:@"DayHourHistoryTable" inManagedObjectContext:objManagedObjectContext];
    recent.dayH=nil;
    [recent setValue:loc_id forKey:@"location_ID"];
    [recent setValue:[self.cloudcoverD objectAtIndex:count] forKey:@"cloudcover_DataModel"];
    
   // //NSlog(@"%@",[self.cloudcoverD objectAtIndex:count]);
    
    
    [recent setValue:[listItems objectAtIndex:0]forKey:@"dateToday_DataModel"];
    [recent setValue:[self.humidityD objectAtIndex:count]forKey:@"humidity_DataModel"];
    [recent setValue:[[self.tempMaxC objectAtIndex:count]objectAtIndex:0]forKey:@"maxTemp_DataModel"];
    [recent setValue:[[self.tempMinC objectAtIndex:count]objectAtIndex:0]forKey:@"minTemp_DataModel"];
    [recent setValue:[self.observationTimeD objectAtIndex:count]forKey:@"observeTime_DataModel"];
    [recent setValue:[self.precipitationD objectAtIndex:count]forKey:@"precipitation_DataModel"];
    [recent setValue:[self.pressureD objectAtIndex:count]forKey:@"pressure_DataModel"];
    [recent setValue:[self.tempratureClbl objectAtIndex:count]forKey:@"temp_DataModel"];
    [recent setValue:[listItems objectAtIndex:1] forKey:@"timeNow_DataModel"];
    [recent setValue:[self.visibility objectAtIndex:count]forKey:@"visibility_DataModel"];
    [recent setValue:[self.status objectAtIndex:count]forKey:@"weatherStatus_DataModel"];
    [recent setValue:[self.ctemp_F objectAtIndex:count]forKey:@"tempF_DataModel"];
    NSError *error=nil;
    if(![_managedObjectContext save:&error])
    {
        //NSlog(@"Can't save! %@ %@",error,[error localizedDescription]);
    }

}
-(void)DayHourHistorydatabase:(int)count loc:(LocationsTable*)place
{
    NSManagedObjectContext *objManagedObjectContext = nil;
    ////NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    DayHourHistoryTable *recent=(DayHourHistoryTable*)[NSEntityDescription insertNewObjectForEntityForName:@"DayHourHistoryTable" inManagedObjectContext:objManagedObjectContext];
   // //NSlog(@"%@",place);
    NSString *time = [self.tz objectAtIndex:count];
    NSArray *listItems = [time componentsSeparatedByString:@" "];
    recent.dayH=place;
    [recent setValue:place.location_ID forKey:@"location_ID"];
    [recent setValue:[self.cloudcoverD objectAtIndex:count] forKey:@"cloudcover_DataModel"];
    
   // //NSlog(@"%@",[self.cloudcoverD objectAtIndex:count]);
    
    
    [recent setValue:[listItems objectAtIndex:0]forKey:@"dateToday_DataModel"];
    [recent setValue:[self.humidityD objectAtIndex:count]forKey:@"humidity_DataModel"];
    [recent setValue:[[self.tempMaxC objectAtIndex:count]objectAtIndex:0]forKey:@"maxTemp_DataModel"];
    [recent setValue:[[self.tempMinC objectAtIndex:count]objectAtIndex:0]forKey:@"minTemp_DataModel"];
    [recent setValue:[self.observationTimeD objectAtIndex:count]forKey:@"observeTime_DataModel"];
    [recent setValue:[self.precipitationD objectAtIndex:count]forKey:@"precipitation_DataModel"];
    [recent setValue:[self.pressureD objectAtIndex:count]forKey:@"pressure_DataModel"];
    [recent setValue:[self.tempratureClbl objectAtIndex:count]forKey:@"temp_DataModel"];
    [recent setValue:[listItems objectAtIndex:1] forKey:@"timeNow_DataModel"];
    [recent setValue:[self.visibility objectAtIndex:count]forKey:@"visibility_DataModel"];
    [recent setValue:[self.status objectAtIndex:count]forKey:@"weatherStatus_DataModel"];
    [recent setValue:[self.ctemp_F objectAtIndex:count]forKey:@"tempF_DataModel"];
    NSError *error=nil;
    if(![_managedObjectContext save:&error])
    {
     //   //NSlog(@"Can't save! %@ %@",error,[error localizedDescription]);
    }
    
    

}

-(void)nearWeatherDataBase
{
    NSString*cloc;
    NSArray *DataTable=[self CommonGetFromDB:@"NearByTable" locID:nil];
    //fav_location=[[NSMutableArray alloc]init];
    //self.currentlocationlbl=[[NSMutableArray alloc]init];
    
    if ([DataTable count] > 0){

        NSUInteger counter = 1;
        for (NearByTable *theLoc in DataTable){
            cloc=[NSString stringWithFormat:@"%@",theLoc.currentLocation_Datamodel];
          
            counter++; }
        if([self.address isEqualToString:cloc])
        {
            [self updateNearWeather];
            
        }
        else
        {
            NSManagedObjectContext *objManagedObjectContext = nil;
            //NSlog(@"%@", [self managedObjectContext]);
            objManagedObjectContext=[self managedObjectContext];
            NSFetchRequest * alldata = [[NSFetchRequest alloc] init];
            [alldata setEntity:[NSEntityDescription entityForName:@"Car" inManagedObjectContext:objManagedObjectContext]];
            [alldata setIncludesPropertyValues:NO]; //only fetch the managedObjectID
            
            NSError * error = nil;
            NSArray * data = [objManagedObjectContext executeFetchRequest:alldata error:&error];
            [alldata release];
            //error handling goes here
            for (NSManagedObject * d in data) {
                [objManagedObjectContext deleteObject:d];
            }
            NSError *saveError = nil;
            [objManagedObjectContext save:&saveError];
            [self insertInNearTable];
        }


    }
    else
    {
        [self insertInNearTable];
    }
    
        
 
}
-(void)insertInNearTable
{
    NSManagedObjectContext *objManagedObjectContext = nil;
    //NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    for(int y=0;y<[self.nearPlaces1 count];y++)
    {
        
        NearByTable *near=(NearByTable*)[NSEntityDescription insertNewObjectForEntityForName:@"NearByTable" inManagedObjectContext:objManagedObjectContext];
        [near setValue:self.address forKey:@"currentLocation_Datamodel"];
        [near setValue:[self.nearPlaces1 objectAtIndex:y] forKey:@"nearbyCityName"];
        [near setValue:[[self.NearWeatherAll valueForKey:[self.nearPlaces1 objectAtIndex:y]]valueForKey:@"temp_C"] forKey:@"nearbyTemp"];
        [near setValue:[[self.NearWeatherAll valueForKey:[self.nearPlaces1 objectAtIndex:y]]valueForKey:@"weather"] forKey:@"nearbyWeatherStatus"];
        
        NSError *error=nil;
        if(![_managedObjectContext save:&error])
        {
            //NSlog(@"Can't save! %@ %@",error,[error localizedDescription]);
        }
        
    }

}
-(void)updateNearWeather
{
    
    NSManagedObjectContext *objManagedObjectContext = nil;
    //NSlog(@"%@", [self managedObjectContext]);
    objManagedObjectContext=[self managedObjectContext];
    
    NSEntityDescription *previous=[NSEntityDescription entityForName:@"NearByTable" inManagedObjectContext:objManagedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:previous];
    //... add sorts if you want them
    NSError *fetchError;
    NSArray *fetchedResult=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    //NSlog(@"%@",fetchedResult);
    for(int y=0;y<[self.nearPlaces1 count];y++)
    {
    for (NSManagedObject *result in fetchedResult) {
        [result setValue:self.address forKey:@"currentLocation_Datamodel"];
        [result setValue:[self.nearPlaces1 objectAtIndex:y] forKey:@"nearbyCityName"];
        [result setValue:[[self.NearWeatherAll valueForKey:[self.nearPlaces1 objectAtIndex:y]]valueForKey:@"temp_C"] forKey:@"nearbyTemp"];
        [result setValue:[[self.NearWeatherAll valueForKey:[self.nearPlaces1 objectAtIndex:y]]valueForKey:@"weather"] forKey:@"nearbyWeatherStatus"];
        

        [self.managedObjectContext save:nil];
    }
    }
 
}
-(void)recentSearch:(int)count
{
//    /* Create the fetch request first */
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    /* Here is the entity whose contents we want to read */
//    NSEntityDescription *entity =[NSEntityDescription
//                                  entityForName:@"RecentSearchTable" inManagedObjectContext:self.managedObjectContext];
//    /* Tell the request that we want to read the contents of the Student entity */
//    [fetchRequest setEntity:entity];
//    NSError *requestError = nil;
//    /* And execute the fetch request on the context */
    NSArray *DataTable =[self CommonGetFromDB:@"RecentSearchTable" locID:nil];
    //[self.managedObjectContext executeFetchRequest:fetchRequest
                               //              error:&requestError];
    //NSlog(@"%@",DataTable);
    NSMutableArray*recentlocs=[[NSMutableArray alloc]init];
    /* Make sure we get the array */
    if ([DataTable count] > 0){
        /* Go through the persons array one by one */
        NSUInteger counter = 1;
        for (RecentSearchTable *theLoc in DataTable){
            //NSlog(@"Student %lu Rollno = %@", (unsigned long)counter, theLoc.locationNameSearch);
            [recentlocs addObject:theLoc.locationNameSearch];
          
            counter++; }
    } else {
        //NSlog(@"Could not find any Student entities in the context.");
    }
    BOOL isalready=NO;
    if ([recentlocs count]>0) {
        for (int k=0; k<[recentlocs count]; k++) {
            if ([[fav_locationDetailDict valueForKey:@"area"] isEqualToString:[recentlocs objectAtIndex:k]]) {
                isalready=YES;
            }
        }
    }
    if (isalready==NO ||[recentlocs count]==0) {
        NSManagedObjectContext *objManagedObjectContext = nil;
        //NSlog(@"%@", [self managedObjectContext]);
        objManagedObjectContext=[self managedObjectContext];
        
        RecentSearchTable *rSearch=(RecentSearchTable*)[NSEntityDescription insertNewObjectForEntityForName:@"RecentSearchTable" inManagedObjectContext:objManagedObjectContext];
        [rSearch setValue:[NSNumber numberWithInt:count] forKey:@"srNo"];
        if([[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"area"])
        {
        [rSearch setValue:[fav_locationDetailDict valueForKey:@"area"] forKey:@"locationNameSearch"];
        }
        else
        {
            [rSearch setValue:@"NA" forKey:@"locationNameSearch"];
        }
        if([[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"region"])
        {
        [rSearch setValue:[fav_locationDetailDict valueForKey:@"region"] forKey:@"regionSearch"];
        }
        else
        {
          [rSearch setValue:@"NA" forKey:@"regionSearch"];
        }
        if([[fav_locationDetailDictAll objectAtIndex:0]valueForKey:@"country"])
        {
            [rSearch setValue:[fav_locationDetailDict valueForKey:@"country"] forKey:@"countrySearch"];
        }
        else
        {
           [rSearch setValue:@"NA" forKey:@"countrySearch"];
        }
        
        
        NSError *error=nil;
        if(![_managedObjectContext save:&error])
        {
            //NSlog(@"Can't save! %@ %@",error,[error localizedDescription]);
        }
   
    }
    }


@end
