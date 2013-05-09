//
//  TSAppDelegate.h
//  NotificareDemoApp
//
//  Created by Joel Oliveira on 3/22/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificarePushLib.h"

@interface TSAppDelegate : UIResponder <UIApplicationDelegate,NotificarePushLibDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSData * theDeviceToken;
@property (strong, nonatomic) UIAlertView *message;

@end
