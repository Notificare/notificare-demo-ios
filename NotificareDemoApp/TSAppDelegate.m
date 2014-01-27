//
//  TSAppDelegate.m
//  NotificareDemoApp
//
//  Created by Joel Oliveira on 3/22/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import "TSAppDelegate.h"
  
@implementation TSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    [self setTheLog:[NSMutableArray array]];
    [self setTheBeacons:[NSMutableArray array]];
    [[NotificarePushLib shared] launch];
    [[NotificarePushLib shared] setDelegate:self];
    

    [[NotificarePushLib shared] registerForRemoteNotificationsTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    if([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]){
        
        [[NotificarePushLib shared] openNotification:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
    }
    
    
    if([launchOptions objectForKey:@"UIApplicationLaunchOptionsLocalNotificationKey"]){
        NSLog(@"%@",[launchOptions objectForKey:@"UIApplicationLaunchOptionsLocalNotificationKey"]);
        //[[NotificarePushLib shared] openNotification:[launchOptions objectForKey:@"UIApplicationLaunchOptionsLocalNotificationKey"]];
    }
    
    
    // Override point for customization after application launch.
    return YES;
}


- (void)askUser{
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    if([settings objectForKey:@"user"]==nil){
        if([self message]==nil){
            [self setMessage:[[UIAlertView alloc] initWithTitle:@"Your twitter handler:"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue", nil]];
            [[self message] setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[self message] show];
        }
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if([title isEqualToString:@"Continue"]){
        UITextField *username = [alertView textFieldAtIndex:0];
        
        if([username.text isEqualToString:@""]){
            [self setMessage:nil];
            [self askUser];
        }else{
            NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
            [settings setObject:username.text forKey:@"user"];
            [settings synchronize];
            
            [self registerTheDevice];
        }

    }else{
        [self setMessage:nil];
        [self askUser];
        
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [self askUser];
    
    [self setTheDeviceToken:deviceToken];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    if([settings objectForKey:@"user"]!=nil){
        [self registerTheDevice];
    }
    
    
    
}


-(void)registerTheDevice{
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    [[NotificarePushLib shared] registerDevice:[self theDeviceToken] withUserID:[settings objectForKey:@"user"] withUsername:[settings objectForKey:@"user"] completionHandler:^(NSDictionary *info) {
        //yeah
        [[NotificarePushLib shared] startLocationUpdates];
    } errorHandler:^(NSError *error) {
        //error?
    }];
    
}

-(void)startMonitoringBeacons{
    [[NotificarePushLib shared] startMonitoringBeaconRegion:[[NSUUID alloc] initWithUUIDString:@"f7826da6-4fa2-4e98-8024-bc5b71e0893e"]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[NotificarePushLib shared] openNotification:userInfo];

    
    //[[NotificarePushLib shared] clearNotification:[userInfo objectForKey:@"id"]];
}

-(void)openNotification:(NSDictionary *)notification{
    [[NotificarePushLib shared] openBeacon:notification];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

    NSLog(@"APPPPPP %@", [[notification userInfo] objectForKey:@"id"]);
    
    UIAlertView * localNotification = [[UIAlertView alloc] initWithTitle:[[notification userInfo] objectForKey:@"title"]
                                                message:[[notification userInfo] objectForKey:@"message"]
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil];
 //   [localNotification setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [localNotification show];
    
    //[[NotificarePushLib shared] openNotification:userInfo];
    
    //[[NotificarePushLib shared] clearNotification:[userInfo objectForKey:@"id"]];
}


- (void)notificarePushLib:(NotificarePushLib *)library willOpenNotification:(Notification *)notification{
    NSLog(@"%@",notification);
}

- (void)notificarePushLib:(NotificarePushLib *)library didOpenNotification:(Notification *)notification{
    NSLog(@"didOpenNotification: %@",notification);
}

- (void)notificarePushLib:(NotificarePushLib *)library didCloseNotification:(Notification *)notification{
    NSLog(@"%@",notification);
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToOpenNotification:(Notification *)notification{
    NSLog(@"%@",notification);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"%@",error);
}

- (void)notificarePushLib:(NotificarePushLib *)library willExecuteAction:(Notification *)notification{
    NSLog(@"%@",notification);
}

- (void)notificarePushLib:(NotificarePushLib *)library didExecuteAction:(NSDictionary *)info{
    NSLog(@"%@",info);
}

-(void)notificarePushLib:(NotificarePushLib *)library shouldPerformSelector:(NSString *)selector{
    SEL mySelector = NSSelectorFromString(selector);
    if([self respondsToSelector:mySelector]){
        Suppressor([self performSelector:mySelector]);
    }
}

- (void)notificarePushLib:(NotificarePushLib *)library didNotExecuteAction:(NSDictionary *)info{
    NSLog(@"%@",info);
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToExecuteAction:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveLocationServiceAuthorizationStatus:(NSDictionary *)status{
    NSLog(@"Location Services status: %@", status);
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailWithError:(NSError *)error{
     NSLog(@"didFailWithError: %@", error);
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateLocations:(NSArray *)locations{
    
    NSArray * monitoredRegions = [[[[NotificarePushLib shared] locationManager] monitoredRegions] allObjects];
    NSLog(@"didUpdateLocations: %@", monitoredRegions);
    [self setTheLocations:locations];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotData" object:nil];
}


- (void)notificarePushLib:(NotificarePushLib *)library monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"monitoringDidFailForRegion: %@ %@", region, error);
    NSMutableDictionary * theTempDict = [NSMutableDictionary dictionary];
    [theTempDict setObject:@"monitoringDidFailForRegion" forKey:@"title"];
    [theTempDict setObject:region forKey:@"region"];
    [theTempDict setObject:[NSDate date] forKey:@"date"];
    [theTempDict setObject:[error debugDescription] forKey:@"error"];
    if([region isKindOfClass:[CLBeaconRegion class]]){
        [theTempDict setObject:@"beacon" forKey:@"class"];
    } else{
        [theTempDict setObject:@"fence" forKey:@"class"];
    }
    
    [[self theLog] addObject:theTempDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotData" object:nil];
}
- (void)notificarePushLib:(NotificarePushLib *)library didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    NSLog(@"didDetermineState: %i %@", state, region);

    NSString * stateText = @"";
    switch (state) {
        case CLRegionStateInside:
            stateText = @"Entered Region";
            break;
            
        case CLRegionStateOutside:
            stateText = @"Exited Region";
            break;
            
        case CLRegionStateUnknown:
            stateText = @"Unknown state";
            break;
            
        default:
            stateText = @"No state";
            break;
    }
    
    NSMutableDictionary * theTempDict = [NSMutableDictionary dictionary];
    [theTempDict setObject:@"didDetermineState" forKey:@"title"];
    [theTempDict setObject:region forKey:@"region"];
    [theTempDict setObject:[NSDate date] forKey:@"date"];
    [theTempDict setObject:stateText forKey:@"state"];
    if([region isKindOfClass:[CLBeaconRegion class]]){
        [theTempDict setObject:@"beacon" forKey:@"class"];
    } else{
        [theTempDict setObject:@"fence" forKey:@"class"];
    }
    [[self theLog] addObject:theTempDict];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotData" object:nil];
}
- (void)notificarePushLib:(NotificarePushLib *)library didEnterRegion:(CLRegion *)region{
    NSLog(@"didEnterRegion: %@", region);
//    NSMutableDictionary * theTempDict = [NSMutableDictionary dictionary];
//    [theTempDict setObject:@"didEnterRegion" forKey:@"title"];
//    [theTempDict setObject:region forKey:@"region"];
//    [[self theLog] addObject:theTempDict];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotData" object:nil];
    
    //[self sendNotification:@"Welcome! You are invited to pass by our shop now and we check out our latest offers" forRegion:(CLRegion *)region];
}
- (void)notificarePushLib:(NotificarePushLib *)library didExitRegion:(CLRegion *)region{
    
    
    NSLog(@"didExitRegion: %@", region);
    NSMutableDictionary * theTempDict = [NSMutableDictionary dictionary];
    [theTempDict setObject:@"didExitRegion" forKey:@"title"];
    [theTempDict setObject:region forKey:@"region"];
    [theTempDict setObject:[NSDate date] forKey:@"date"];
    if([region isKindOfClass:[CLBeaconRegion class]]){
        [theTempDict setObject:@"beacon" forKey:@"class"];
    } else{
        [theTempDict setObject:@"fence" forKey:@"class"];
    }
    [[self theLog] addObject:theTempDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotData" object:nil];
    
    //[self sendNotification:@"Bye! I hope you enjoyed." forRegion:region];
}

- (void)notificarePushLib:(NotificarePushLib *)library rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
    NSLog(@"rangingBeaconsDidFailForRegion: %@ %@", region, error);
    NSMutableDictionary * theTempDict = [NSMutableDictionary dictionary];
    [theTempDict setObject:@"rangingBeaconsDidFailForRegion" forKey:@"title"];
    [theTempDict setObject:region forKey:@"region"];
    [theTempDict setObject:[NSDate date] forKey:@"date"];
    [theTempDict setObject:@"beacon" forKey:@"class"];
    [theTempDict setObject:[error debugDescription] forKey:@"error"];
    [[self theLog] addObject:theTempDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotData" object:nil];
}
- (void)notificarePushLib:(NotificarePushLib *)library didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    NSLog(@"didRangeBeacons: %@ %@", beacons, region);
    NSMutableDictionary * theTempDict = [NSMutableDictionary dictionary];
    [theTempDict setObject:@"didRangeBeacons" forKey:@"title"];
    [theTempDict setObject:region forKey:@"region"];
    [theTempDict setObject:[NSDate date] forKey:@"date"];
    [theTempDict setObject:beacons forKey:@"beacons"];
    [theTempDict setObject:@"beacon" forKey:@"class"];
    [[self theLog] addObject:theTempDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotData" object:nil];

    for (NSDictionary * beacon in beacons) {

        if([beacon objectForKey:@"info"]){
            
            if([[self theBeacons] count] > 0){
                for (NSDictionary * theBeacon in [self theBeacons]) {
                    
                    if(![[[theBeacon objectForKey:@"info"]  objectForKey:@"_id"] isEqualToString:[[beacon objectForKey:@"info"] objectForKey:@"_id"]]){
                        [[self theBeacons] addObject:beacon];
                    }
                    
                }
            } else {
                [[self theBeacons] addObject:beacon];
            }
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotBeacons" object:nil];
    UITabBarController * tabBarController = (UITabBarController*)self.window.rootViewController;
    [tabBarController setSelectedIndex:1];
    

}


- (void)sendNotification:(NSString *)message forRegion:(CLRegion *)region {
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    [notification setAlertBody:message];
    [notification setAlertAction:@"OK"];
    NSMutableDictionary * infoDict = [NSMutableDictionary dictionary];
    [infoDict setObject:[region identifier] forKey:@"id"];
    [infoDict setObject:@"Your App" forKey:@"title"];
    [infoDict setObject:message forKey:@"message"];
    [notification setUserInfo: infoDict];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

}


-(void)goToSecondTab{
    UITabBarController * tabBarController = (UITabBarController*)self.window.rootViewController;
    [tabBarController setSelectedIndex:1];
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
    
//    NSLog(@"applicationWillEnterForeground");
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end
