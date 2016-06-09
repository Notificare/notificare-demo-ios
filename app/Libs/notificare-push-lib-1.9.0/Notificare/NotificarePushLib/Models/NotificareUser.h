//
//  NotificareUser.h
//  NotificarePushLib
//
//  Created by Joel Oliveira on 10/10/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificareUser : NSObject

@property (strong, nonatomic) NSString * accessToken;
@property (strong, nonatomic) NSString * account;
@property (nonatomic, assign) BOOL active;
@property (strong, nonatomic) NSString * application;
@property (nonatomic, assign) BOOL autoGenerated;
@property (strong, nonatomic) NSMutableArray * segments;
@property (strong, nonatomic) NSString * userID;
@property (strong, nonatomic) NSString * userName;
@property (nonatomic, assign) BOOL validated;

- (void)setValuesWithUserJSON:(NSDictionary *)userJSON;

@end
