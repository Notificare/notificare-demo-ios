//
//  APIEngine
//  Crossing Border
//
//  Created by Joel Oliveira on 8/7/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import "MKNetworkEngine.h"


@interface ApiEngine : MKNetworkEngine

typedef void (^SuccessBlock)(NSDictionary* info);
typedef void (^ErrorBlock)(NSError * error);

/*!
 * @abstract Get Events
 *
 * @discussion
 * Retrieves the list of events
 */

-(void)getEvents:(SuccessBlock)successBlock errorHandler:(ErrorBlock)errorBlock;

@end
