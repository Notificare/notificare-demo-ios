//
//  AppDelegate.h
//  app
//
//  Created by Joel Oliveira on 16/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificarePushLib.h"
#import "ApiEngine.h"


@class RightViewController;
@class LeftViewController;
@class IIViewDeckController;
@class MainViewController;
@class LocationViewController;
@class SignInViewController;
@class UserDetailsViewController;
@class ResetPassViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NotificarePushLibDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navController;

@property (strong, nonatomic) NotificarePushLib * notificarePushLib;

@property (strong, nonatomic) NSMutableArray * cachedNotifications;

@property (strong, nonatomic) NSMutableArray * regions;
@property (strong, nonatomic) NSMutableArray * beacons;

@property (assign, nonatomic) BOOL isLocationServicesOn;

@property (retain, nonatomic) UIViewController *rightController;
@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *leftController;
@property (retain, nonatomic) IIViewDeckController* deckController;

@property (strong, nonatomic) ApiEngine * apiEngine;


-(void)handleNavigation:(NSDictionary *)item;
-(void)openBeacon:(NSDictionary *)info;

@end
