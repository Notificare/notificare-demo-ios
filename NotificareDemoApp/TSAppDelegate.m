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
    
    [[NotificarePushLib shared] launch];
    [[NotificarePushLib shared] setDelegate:self];
    

    [[NotificarePushLib shared] registerForRemoteNotificationsTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    if([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]){
        
        [[NotificarePushLib shared] openNotification:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
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
    
    [[NotificarePushLib shared] registerDevice:[self theDeviceToken] withUserID:[settings objectForKey:@"user"] withUsername:[settings objectForKey:@"user"]];
    
    [[NotificarePushLib shared] startLocationUpdates];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[NotificarePushLib shared] openNotification:userInfo];
    
    //[[NotificarePushLib shared] clearNotification:[userInfo objectForKey:@"id"]];
}


- (void)notificarePushLib:(NotificarePushLib *)library willOpenNotification:(Notification *)notification{
    NSLog(@"%@",notification);
}

- (void)notificarePushLib:(NotificarePushLib *)library didOpenNotification:(Notification *)notification{
    NSLog(@"%@",notification);
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
