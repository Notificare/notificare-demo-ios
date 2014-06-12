//
//  Configuration.h
//  CrossingBorder
//
//  Created by Joel Oliveira on 26/02/14.
//  Copyright (c) 2014 CrossingBorder. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Configuration : NSObject


+(Configuration*)shared;
-(NSString*)getProperty:(NSString *)key;
-(NSArray*)getArray:(NSString *)key;

@end
