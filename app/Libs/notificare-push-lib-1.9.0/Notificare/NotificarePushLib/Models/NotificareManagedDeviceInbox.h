//
//  NotificareManagedDeviceInbox.h
//  app
//
//  Created by Aernout Peeters on 29-04-2016.
//  Copyright © 2016 Notificare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NotificareDeviceInbox.h"

@interface NotificareManagedDeviceInbox : NSManagedObject

@property (strong, nonatomic) NSString * inboxId;
@property (strong, nonatomic) NSString * applicationId;
@property (strong, nonatomic) NSString * deviceID;
@property (strong, nonatomic) NSDictionary * data;
@property (strong, nonatomic) NSString * message;
@property (strong, nonatomic) NSString * notification;
@property (strong, nonatomic) NSDate * time;
@property (strong, nonatomic) NSString * userID;
@property (assign, nonatomic) BOOL opened;

+ (NotificareManagedDeviceInbox *)ManagedDeviceInbox:(NotificareDeviceInbox *)nonManaged inContext:(NSManagedObjectContext *)managedObjectContext;
- (NotificareDeviceInbox *)toNonManaged;

@end
