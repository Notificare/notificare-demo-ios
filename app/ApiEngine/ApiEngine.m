//
//  ApiEngine.m
//  TheApp
//
//  Created by Joel Oliveira on 8/7/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import "ApiEngine.h"

@implementation ApiEngine

/*!
 * 
 *
 */
- (void)getEvents:(SuccessBlock)successBlock errorHandler:(ErrorBlock)errorBlock {
    
    MKNetworkOperation *op = [self operationWithPath:@"/_data/db_test.json"
                                              params:nil httpMethod:@"GET" ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            
            successBlock(jsonObject);
            
        }];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        errorBlock(error);
        
    }];
    
    [self enqueueOperation:op];
}

/*!
 *
 *
 */
-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"AppImages"];
    return cacheDirectoryName;
}



@end
