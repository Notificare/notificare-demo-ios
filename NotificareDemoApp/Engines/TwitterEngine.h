//
//  TestEngine.h
//  NotificareTest2
//
//  Created by Joel Oliveira on 1/29/13.
//  Copyright (c) 2013 Joel Oliveira | Mangrove. All rights reserved.
//

#import "MKNetworkKit.h"

typedef void (^TweetsResponseBlock)(NSDictionary*response);

@interface TwitterEngine : MKNetworkEngine


-(MKNetworkOperation*)getTweets:(NSString*)path completionHandler:(TweetsResponseBlock)response errorHandler:(MKNKErrorBlock) error;


@end
