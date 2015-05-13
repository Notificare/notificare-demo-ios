//
//  AppDelegate.m
//  app
//
//  Created by Joel Oliveira on 16/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "MainViewController.h"
#import "PageOneViewController.h"
#import "PageTwoViewController.h"
#import "PageThreeViewController.h"
#import "WebViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "LocationViewController.h"
#import "SignInViewController.h"
#import "UserDetailsViewController.h"
#import "ResetPassViewController.h"
#import "ProductsViewController.h"
#import "LogViewController.h"
#import "NSData+Hex.h"
#import "TestFlight.h"
#import "Configuration.h"
#import "NotificareDevice.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    if([[[Configuration shared] getProperty:@"testflight"] length] > 0){
        [TestFlight takeOff:[[Configuration shared] getProperty:@"testflight"]];
    }
    
    if([[[Configuration shared] getProperty:@"host"] length] > 0){
        [self setApiEngine:[[ApiEngine alloc]
                            initWithHostName:[[Configuration shared] getProperty:@"host"]
                            customHeaderFields:nil]];
        
        [[self apiEngine] useCache];
        
        //[UIImageView setDefaultEngine:[self apiEngine]];
    }
    
    
    [self setLog:[NSMutableArray array]];
    [self setCachedNotifications:[NSMutableArray array]];
    [self setBeacons:[NSMutableArray array]];
    [self setRegions:[NSMutableArray array]];
    [[NotificarePushLib shared] launch];
    [[NotificarePushLib shared] setDelegate:self];
    //[[NotificarePushLib shared] setShouldAlwaysLogBeacons:YES];
    
    [[NotificarePushLib shared] handleOptions:launchOptions];
    
    [self setNotificarePushLib:[NotificarePushLib shared]];
    
    IIViewDeckController* deckController = [self generateControllerStack];
    self.leftController = deckController.leftController;
    self.centerController = deckController.centerController;
    [self.window setRootViewController:deckController];
    
    
    //[self performSelector:@selector(createNotification) withObject:nil afterDelay:4.0];
    
    [self.window makeKeyAndVisible];
    return YES;
}


//-(void)createNotification{
//    UIApplication* app = [UIApplication sharedApplication];
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate new];
//    localNotification.alertBody = @"MY Body ";
//    localNotification.alertAction = @"My Title";
//    localNotification.userInfo = @{@"id":@"54c6a6ba8333b10a315e80e1"};
//    localNotification.timeZone = [NSTimeZone defaultTimeZone];
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
//
//    [app scheduleLocalNotification:localNotification];
//}

- (IIViewDeckController*)generateControllerStack {
    
    [self setLeftController:[[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil]];
    [self setRightController:[[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil]];
    
    
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    
    
    
    if(![settings boolForKey:@"tutorialUserRegistered"] && ![[NotificarePushLib shared] checkLocationUpdates]){
        PageOneViewController * controller = [[PageOneViewController alloc] initWithNibName:@"PageOneViewController" bundle:nil];
        [self setCenterController:[[UINavigationController alloc] initWithRootViewController:controller]];
    }
    
    if([settings boolForKey:@"tutorialUserRegistered"] && [[NotificarePushLib shared] checkLocationUpdates]){
        PageThreeViewController * controller = [[PageThreeViewController alloc] initWithNibName:@"PageThreeViewController" bundle:nil];
        [self setCenterController:[[UINavigationController alloc] initWithRootViewController:controller]];
    }
    
    if([settings boolForKey:@"tutorialUserRegistered"] && ![[NotificarePushLib shared] checkLocationUpdates]){
        
        PageTwoViewController * controller = [[PageTwoViewController alloc] initWithNibName:@"PageTwoViewController" bundle:nil];
        [self setCenterController:[[UINavigationController alloc] initWithRootViewController:controller]];
        
        
        
    }
    
    
    
    
    [self setDeckController:[[IIViewDeckController alloc] initWithCenterViewController:[self centerController]
                                                                    leftViewController:[self leftController]
                                                                   rightViewController:[self rightController]]];
    //deckController.rightSize = 100;
    
    //[[self deckController] disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return [self deckController];
    
}


- (void)notificarePushLib:(NotificarePushLib *)library onReady:(NSDictionary *)info{
    
#if TARGET_IPHONE_SIMULATOR
    
    //Simulator
    [[NotificarePushLib shared] registerForWebsockets];
    
#else
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    
    [settings setBool:NO forKey:@"re.notifica.office.prod2"];
    [settings synchronize];
    
    if([settings boolForKey:@"tutorialUserRegistered"]){
        
        [[NotificarePushLib shared] registerForNotifications];
    }
    
    //NSLog(@"%@",[[NotificarePushLib shared] applicationInfo]);
    
#endif
    
}


-(void)refreshMainController{
    //    IIViewDeckController* deckController = [self generateControllerStack];
    //    self.leftController = deckController.leftController;
    //    self.centerController = deckController.centerController;
    //    [self.window setRootViewController:deckController];
}


-(void)handleNavigation:(NSDictionary *)item{
    
    
    [[self deckController] toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        
        
        if ([[item objectForKey:@"url"] hasPrefix:@"http://"] || [[item objectForKey:@"url"] hasPrefix:@"https://"]) {
            
            WebViewController * main = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
            
            [main setViewTitle:LSSTRING([item objectForKey:@"label"])];
            [main setTargetUrl:[item objectForKey:@"url"]];
            [self setCenterController:[[UINavigationController alloc] initWithRootViewController:main]];
            
            [[self deckController] setCenterController:[self centerController]];
            
        } else {
            //Check which Native Action to perform
            
            if ([[item objectForKey:@"url"] hasPrefix:@"IBAction:"]){
                //Call a method in delegate (used for the settings)
                
                NSString * method = [[item objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"IBAction:" withString:@""];
                SEL mySelector = NSSelectorFromString(method);
                if([self respondsToSelector:mySelector]){
                    Suppressor([self performSelector:mySelector]);
                }
                
            } else if ([[item objectForKey:@"url"] hasPrefix:@"Auth:"]){
                //Call a method in delegate (used for the settings)
                
                
                if([[NotificarePushLib shared] isLoggedIn]){
                    
                    UserDetailsViewController * userDetails = [[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
                    [self setCenterController:[[UINavigationController alloc] initWithRootViewController:userDetails]];
                    
                } else {
                    
                    SignInViewController * login = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
                    [self setCenterController:[[UINavigationController alloc] initWithRootViewController:login]];
                }
                
                
                
                [[self deckController] setCenterController:[self centerController]];
                
            } else if ([[item objectForKey:@"url"] hasPrefix:@"MKMapView:"]){
                
                
                LocationViewController * map = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
                
                [self setCenterController:[[UINavigationController alloc] initWithRootViewController:map]];
                [[self deckController] setCenterController:[self centerController]];
                
            } else if ([[item objectForKey:@"url"] hasPrefix:@"Products:"]){
                
                
                ProductsViewController * prods = [[ProductsViewController alloc] initWithNibName:@"ProductsViewController" bundle:nil];
                
                [self setCenterController:[[UINavigationController alloc] initWithRootViewController:prods]];
                [[self deckController] setCenterController:[self centerController]];
                
                //APP_ALERT_DIALOG(LSSTRING(@"alert_inapp_purchase_demo"));
                
            }  else if ([[item objectForKey:@"url"] hasPrefix:@"Log:"]){
                
                
                LogViewController * log = [[LogViewController alloc] initWithNibName:@"LogViewController" bundle:nil];
                
                [self setCenterController:[[UINavigationController alloc] initWithRootViewController:log]];
                [[self deckController] setCenterController:[self centerController]];
                
                
            } else if ([[item objectForKey:@"url"] hasPrefix:@"MainView:"]){
                
                
                NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
                
                if(![settings boolForKey:@"tutorialUserRegistered"] && ![[NotificarePushLib shared] checkLocationUpdates]){
                    PageOneViewController * controller = [[PageOneViewController alloc] initWithNibName:@"PageOneViewController" bundle:nil];
                    [[self deckController] setCenterController:[[UINavigationController alloc] initWithRootViewController:controller]];
                }
                
                
                
                if([settings boolForKey:@"tutorialUserRegistered"] && [[NotificarePushLib shared] checkLocationUpdates]){
                    
                    PageThreeViewController * controller = [[PageThreeViewController alloc] initWithNibName:@"PageThreeViewController" bundle:nil];
                    [[self deckController] setCenterController:[[UINavigationController alloc] initWithRootViewController:controller]];
                }
                
                if([settings boolForKey:@"tutorialUserRegistered"] && ![[NotificarePushLib shared] checkLocationUpdates]){
                    
                    PageTwoViewController * controller = [[PageTwoViewController alloc] initWithNibName:@"PageTwoViewController" bundle:nil];
                    [[self deckController] setCenterController:[[UINavigationController alloc] initWithRootViewController:controller]];
                }
                
            }
            
        }
        
        
    }];
    
    
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[NotificarePushLib shared]  handleOpenURL:url];
    return YES;
}


#pragma General Methods

-(void)openPreferences{
    [[NotificarePushLib shared] openUserPreferences];
}

-(void)openInbox{
    [[NotificarePushLib shared] openInbox];
}

-(void)openBeacons{
    [[NotificarePushLib shared] openBeacons];
}

-(void)addToLog:(NSDictionary *)event{
    NSMutableDictionary * tempLog = [NSMutableDictionary dictionaryWithDictionary:event];
    [tempLog setObject:[NSDate new] forKey:@"date"];
    [[self log] addObject:tempLog];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLog" object:nil];
}

#pragma Notificare OAuth2 delegates

- (void)notificarePushLib:(NotificarePushLib *)library didChangeAccountNotification:(NSDictionary *)info{
    //NSLog(@"didChangeAccountNotification: %@",info);
    
    UserDetailsViewController * userDetailsView = [[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:userDetailsView];
    [self setCenterController:navigationController];
    [[self deckController] setCenterController:[self centerController]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changedAccount" object:nil];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didChangeAccountNotification" forKey:@"event"];
    if(![info isKindOfClass:[NSNull class]] || info != nil){
        [tmpLog setObject:info forKey:@"data"];
    }
    
    [self addToLog:tmpLog];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToRequestAccessNotification:(NSError *)error{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    if([settings boolForKey:@"tutorialUserRegistered"]){
        
        SignInViewController * signInView = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:signInView];
        [self setCenterController:navigationController];
        [[self deckController] setCenterController:[self centerController]];
        
    } else {
        
        NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
        
        if(![settings boolForKey:@"tutorialUserRegistered"] && ![[NotificarePushLib shared] checkLocationUpdates]){
            PageOneViewController * controller = [[PageOneViewController alloc] initWithNibName:@"PageOneViewController" bundle:nil];
            [[self deckController] setCenterController:[[UINavigationController alloc] initWithRootViewController:controller]];
        }
        
        
        
        if([settings boolForKey:@"tutorialUserRegistered"] && [[NotificarePushLib shared] checkLocationUpdates]){
            
            PageThreeViewController * controller = [[PageThreeViewController alloc] initWithNibName:@"PageThreeViewController" bundle:nil];
            [[self deckController] setCenterController:[[UINavigationController alloc] initWithRootViewController:controller]];
        }
        
        if([settings boolForKey:@"tutorialUserRegistered"] && ![[NotificarePushLib shared] checkLocationUpdates]){
            
            PageTwoViewController * controller = [[PageTwoViewController alloc] initWithNibName:@"PageTwoViewController" bundle:nil];
            [[self deckController] setCenterController:[[UINavigationController alloc] initWithRootViewController:controller]];
        }
    }
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changedAccount" object:nil];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didFailToRequestAccessNotification" forKey:@"event"];
    if(![error isKindOfClass:[NSNull class]] || error != nil){
        [tmpLog setObject:error forKey:@"data"];
    }
    
    [self addToLog:tmpLog];
}


- (void)notificarePushLib:(NotificarePushLib *)library didReceiveActivationToken:(NSString *)token{
    
    [[NotificarePushLib shared] validateAccount:token completionHandler:^(NSDictionary *info) {
        
        SignInViewController * signInView = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:signInView];
        [self setCenterController:navigationController];
        [[self deckController] setCenterController:[self centerController]];
        
        APP_ALERT_DIALOG(LSSTRING(@"success_validate"));
        
    } errorHandler:^(NSError *error) {
        
        APP_ALERT_DIALOG(LSSTRING(@"error_validate"));
        
    }];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didReceiveActivationToken" forKey:@"event"];
    [tmpLog setObject:@{@"token": token} forKey:@"data"];
    [self addToLog:tmpLog];
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveResetPasswordToken:(NSString *)token{
    
    SignInViewController * login = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:login];
    [self setCenterController:navigationController];
    [[self deckController] setCenterController:[self centerController]];
    
    ResetPassViewController * resetPassView = [[ResetPassViewController alloc] initWithNibName:@"ResetPassViewController" bundle:nil];
    [resetPassView setToken:token];
    [navigationController pushViewController:resetPassView animated:YES];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didReceiveResetPasswordToken" forKey:@"event"];
    [tmpLog setObject:@{@"token": token} forKey:@"data"];
    [self addToLog:tmpLog];
}

#pragma APNS Delegates
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //If you don't identify users you can just use this
    [[NotificarePushLib shared] registerDevice:deviceToken completionHandler:^(NSDictionary *info) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"registeredDevice" object:nil];
        
        if([[NotificarePushLib shared] checkLocationUpdates]){
            [[NotificarePushLib shared] startLocationUpdates];
        }
        
        [self addTags];
        
        
    } errorHandler:^(NSError *error) {
        //
        //  [self registerForAPNS];
        
    }];
    
    
    
    
}

#pragma APNS Delegates
- (void)notificarePushLib:(NotificarePushLib *)library didRegisterForWebsocketsNotifications:(NSString *)uuid {
    
    
    //If you don't identify users you can just use this
    [[NotificarePushLib shared] registerDeviceForWebsockets:uuid completionHandler:^(NSDictionary *info) {
        
        if([[NotificarePushLib shared] checkLocationUpdates]){
            [[NotificarePushLib shared] startLocationUpdates];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startedLocationUpdate" object:nil];
        }
        
        
        // [self addTags];
        
    } errorHandler:^(NSError *error) {
        //
        //  [self registerForAPNS];
        
    }];
    
}


/////////////////////////////////
///New iOS8 delgates
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completion{
    
    [[NotificarePushLib shared] handleAction:identifier forNotification:userInfo withData:nil completionHandler:^(NSDictionary *info) {
        completion();
    } errorHandler:^(NSError *error) {
        completion();
    }];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"handleActionWithIdentifier" forKey:@"event"];
    if(![userInfo isKindOfClass:[NSNull class]] || userInfo != nil){
        [tmpLog setObject:userInfo forKey:@"data"];
    }
    
    [self addToLog:tmpLog];
}
#endif
/////////////////////////////////


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didFailToRegisterForRemoteNotificationsWithError" forKey:@"event"];
    if(![error isKindOfClass:[NSNull class]] || error != nil){
        [tmpLog setObject:error forKey:@"data"];
    }
    
    [self addToLog:tmpLog];
}



//For iOS6 - No inbox
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[NotificarePushLib shared] openNotification:userInfo];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didReceiveRemoteNotification" forKey:@"event"];
    if(![userInfo isKindOfClass:[NSNull class]] || userInfo != nil){
        [tmpLog setObject:userInfo forKey:@"data"];
    }
    [self addToLog:tmpLog];
}


- (void)notificarePushLib:(NotificarePushLib *)library didReceiveWebsocketNotification:(NSDictionary *)info {
    
    [[NotificarePushLib shared] openNotification:info];
    
}




// If you implement this delegate please add a remote-notification to your UIBackgroundModes in app's plist
// For iOS7 up - No inbox
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [[NotificarePushLib shared] saveToInbox:userInfo forApplication:application completionHandler:^(NSDictionary *info) {
        
        completionHandler(UIBackgroundFetchResultNewData);
    } errorHandler:^(NSError *error) {
        
        completionHandler(UIBackgroundFetchResultNoData);
    }];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didReceiveRemoteNotification" forKey:@"event"];
    if(![userInfo isKindOfClass:[NSNull class]] || userInfo != nil){
        [tmpLog setObject:userInfo forKey:@"data"];
    }
    
    [self addToLog:tmpLog];
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateBadge:(int)badge{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomingNotification" object:nil];
}




- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    if([notification userInfo] && [[notification userInfo] objectForKey:@"notification"]){
        [[NotificarePushLib shared] openNotification:@{@"id":[[notification userInfo] objectForKey:@"notification"]}];
    }
    
    
}



#pragma Tags
-(void)addTags{
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    
    //One time
    if([settings objectForKey:@"notificareAppInstall"] == nil || ![settings objectForKey:@"notificareAppInstall"]){
        
        [[NotificarePushLib shared] addTags:@[@"tag_press",@"tag_events",@"tag_newsletter"] completionHandler:^(NSDictionary *info) {
            //
        } errorHandler:^(NSError *error) {
            //
        }];
    }
    
    
    
}


#pragma Notificare delegates

- (void)notificarePushLib:(NotificarePushLib *)library willOpenNotification:(NotificareNotification *)notification{
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didOpenNotification:(NotificareNotification *)notification{
    
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didCloseNotification:(NotificareNotification *)notification{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closedNotification" object:nil];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToOpenNotification:(NotificareNotification *)notification{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closedNotification" object:nil];
}


- (void)notificarePushLib:(NotificarePushLib *)library willExecuteAction:(NotificareNotification *)notification{
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didExecuteAction:(NSDictionary *)info{
    //NSLog(@"%@",info);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closedNotification" object:nil];
}

-(void)notificarePushLib:(NotificarePushLib *)library shouldPerformSelector:(NSString *)selector{
    SEL mySelector = NSSelectorFromString(selector);
    if([self respondsToSelector:mySelector]){
        Suppressor([self performSelector:mySelector]);
    }
}

- (void)notificarePushLib:(NotificarePushLib *)library didNotExecuteAction:(NSDictionary *)info{
    //NSLog(@"%@",info);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closedNotification" object:nil];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToExecuteAction:(NSError *)error{
    //NSLog(@"%@",error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closedNotification" object:nil];
}


#pragma Notificare Location delegates
- (void)notificarePushLib:(NotificarePushLib *)library didReceiveLocationServiceAuthorizationStatus:(NSDictionary *)status{
    if ([[status objectForKey:@"status"] isEqualToString:@"Location Services are available"]) {
        [self setIsLocationServicesOn:YES];
        
    } else {
        [self setIsLocationServicesOn:NO];
    }
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToStartLocationServiceWithError:(NSError *)error{
    [self setIsLocationServicesOn:NO];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didFailToStartLocationServiceWithError" forKey:@"event"];
    if(![error isKindOfClass:[NSNull class]] || error != nil){
        [tmpLog setObject:[error userInfo] forKey:@"data"];
    }
    
    [self addToLog:tmpLog];
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateLocations:(NSArray *)locations{
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if([settings boolForKey:@"tutorialUserRegistered"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startedLocationUpdate" object:nil];
    }
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didUpdateLocations" forKey:@"event"];
    if(![locations isKindOfClass:[NSNull class]] || locations != nil){
        [tmpLog setObject:locations forKey:@"data"];
    }
    [self addToLog:tmpLog];
    
}

//Use this delegate to know if any region failed to be monitored
- (void)notificarePushLib:(NotificarePushLib *)library monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    
    NSMutableDictionary * regionObj = [NSMutableDictionary dictionary];
    [regionObj setObject:[region identifier] forKey:@"region"];
    if(![error isKindOfClass:[NSNull class]] || error != nil){
        [regionObj setObject:error forKey:@"error"];
    }
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"monitoringDidFailForRegion" forKey:@"event"];
    [tmpLog setObject:regionObj forKey:@"data"];
    [self addToLog:tmpLog];
}

//iOS 7 only delegate. When on iOS7 this delegate will give a status of a monitored region
// You can request a state of a region by doing [[[NotificarePushLib shared] locationManager] requestStateForRegion:(CLRegion *) region];

- (void)notificarePushLib:(NotificarePushLib *)library didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    // NSLog(@"didDetermineState: %i %@", state, region);
    
    if([region isKindOfClass:[CLBeaconRegion class]]){
        [self setSupportsBeacons:YES];
    }
    
    NSMutableDictionary * regionObj = [NSMutableDictionary dictionary];
    [regionObj setObject:[region identifier] forKey:@"region"];
    switch (state) {
        case CLRegionStateInside:
            [regionObj setObject:@"CLRegionStateInside" forKey:@"state"];
            break;
            
        case CLRegionStateOutside:
            [regionObj setObject:@"CLRegionStateOutside" forKey:@"state"];
            break;
        case CLRegionStateUnknown:
            [regionObj setObject:@"CLRegionStateUnknown" forKey:@"state"];
            break;
        default:
            break;
    }
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didDetermineState" forKey:@"event"];
    [tmpLog setObject:regionObj forKey:@"data"];
    [self addToLog:tmpLog];
    
}

//Use this delegate to know when a user entered a region. Notificare will automatically handle the triggers.
//According to the triggers created through the dashboard or API.
- (void)notificarePushLib:(NotificarePushLib *)library didEnterRegion:(CLRegion *)region{
    
    NSMutableDictionary * regionObj = [NSMutableDictionary dictionary];
    [regionObj setObject:[region identifier] forKey:@"region"];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didEnterRegion" forKey:@"event"];
    [tmpLog setObject:regionObj forKey:@"data"];
    [self addToLog:tmpLog];
    
}

//Use this delegate to know when a user exited a region. Notificare will automatically handle the triggers.
//According to the triggers created through the dashboard or API.
- (void)notificarePushLib:(NotificarePushLib *)library didExitRegion:(CLRegion *)region{
    
    
    if([region isKindOfClass:[CLBeaconRegion class]]){
        [[self beacons] removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rangingBeacons" object:nil];
    }
    
    NSMutableDictionary * regionObj = [NSMutableDictionary dictionary];
    [regionObj setObject:[region identifier] forKey:@"region"];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didExitRegion" forKey:@"event"];
    [tmpLog setObject:regionObj forKey:@"data"];
    [self addToLog:tmpLog];
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didStartMonitoringForRegion:(CLRegion *)region{
    // NSLog(@"didStartMonitoringForRegion: %@", region);
    
    if(![region isKindOfClass:[CLBeaconRegion class]]){
        
        [[self regions] removeAllObjects];
        
        for (NSDictionary * fence in [[NotificarePushLib shared] geofences]) {
            [[self regions] addObject:fence];
        }
        
    }
    
    NSMutableDictionary * regionObj = [NSMutableDictionary dictionary];
    [regionObj setObject:[region identifier] forKey:@"region"];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didStartMonitoringForRegion" forKey:@"event"];
    [tmpLog setObject:regionObj forKey:@"data"];
    [self addToLog:tmpLog];
}


//iOS 7 only delegate. Use this delegate to know when ranging beacons for a CLBeaconRegion failed.
- (void)notificarePushLib:(NotificarePushLib *)library rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
    
    NSMutableDictionary * regionObj = [NSMutableDictionary dictionary];
    [regionObj setObject:[region identifier] forKey:@"region"];
    if(![error isKindOfClass:[NSNull class]] || error != nil){
        [regionObj setObject:error forKey:@"error"];
    }
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"rangingBeaconsDidFailForRegion" forKey:@"event"];
    [tmpLog setObject:regionObj forKey:@"data"];
    [self addToLog:tmpLog];
    
}

//iOS 7 only delegate. Use this delegate to know when beacons have been found according to the proximity you set in the dashboard or API.
//When found a beacon it will be included in the array as a NSDictionary with a root property called info
//This will hold all the information of the beacon that is passed by Notificare like settings, content, etc.
//With this object you can alays open the beacon content by doing:
//[[NotificarePushLib shared] openNotification:[beacon objectForKey:@"info"]];

- (void)notificarePushLib:(NotificarePushLib *)library didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rangingBeacons" object:nil];
    [self setBeacons:[NSMutableArray arrayWithArray:beacons]];
    
    NSMutableDictionary * regionObj = [NSMutableDictionary dictionary];
    [regionObj setObject:[region identifier] forKey:@"region"];
    
    NSMutableDictionary * tmpLog = [NSMutableDictionary dictionary];
    [tmpLog setObject:@"didRangeBeacons" forKey:@"event"];
    [tmpLog setObject:regionObj forKey:@"data"];
    [self addToLog:tmpLog];
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailProductTransaction:(SKPaymentTransaction *)transaction withError:(NSError *)error{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
}

- (void)notificarePushLib:(NotificarePushLib *)library didCompleteProductTransaction:(SKPaymentTransaction *)transaction{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
}

- (void)notificarePushLib:(NotificarePushLib *)library didRestoreProductTransaction:(SKPaymentTransaction *)transaction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didLoadStore:(NSArray *)products{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
}


- (void)notificarePushLib:(NotificarePushLib *)library didFailToLoadStore:(NSError *)error{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
}


- (void)notificarePushLib:(NotificarePushLib *)library didStartDownloadContent:(SKPaymentTransaction *)transaction{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
}
- (void)notificarePushLib:(NotificarePushLib *)library didPauseDownloadContent:(SKDownload *)download{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
}
- (void)notificarePushLib:(NotificarePushLib *)library didCancelDownloadContent:(SKDownload *)download{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
}
- (void)notificarePushLib:(NotificarePushLib *)library didReceiveProgressDownloadContent:(SKDownload *)download{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
}
- (void)notificarePushLib:(NotificarePushLib *)library didFailDownloadContent:(SKDownload *)download{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
}
- (void)notificarePushLib:(NotificarePushLib *)library didFinishDownloadContent:(SKDownload *)download{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProducts" object:nil];
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
