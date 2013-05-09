//
//  TestEngine.m
//  NotificareTest2
//
//  Created by Joel Oliveira on 1/29/13.
//  Copyright (c) 2013 Joel Oliveira | Mangrove. All rights reserved.
//

#import "TwitterEngine.h"



@implementation TwitterEngine



-(MKNetworkOperation*)getTweets:(NSString*)path completionHandler:(TweetsResponseBlock)response errorHandler:(MKNKErrorBlock) error{
    
    MKNetworkOperation *op = [self operationWithPath:path params:nil httpMethod:@"GET" ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        [operation responseJSONWithCompletionHandler:^(id jsonObject) {
            
            response(jsonObject);
            
        }];
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        
        NSLog(@"Notificare: %@", error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

@end