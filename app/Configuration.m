//
//  Configuration.m
//  CrossingBorder
//
//  Created by Joel Oliveira on 26/02/14.
//  Copyright (c) 2014 CrossingBorder. All rights reserved.
//


#import "Configuration.h"

@implementation Configuration


// Get the shared instance and create it if necessary.
+(Configuration*)shared {
    
    static Configuration *shared = nil;
    
    if (shared == nil) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            shared = [[Configuration alloc] init];
            
        });
    }
    return shared;
}


-(NSString*)getProperty:(NSString *)key{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *pfile = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return [pfile objectForKey:key];
}

-(NSArray*)getArray:(NSString *)key{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *pfile = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return [pfile objectForKey:key];
}

@end
