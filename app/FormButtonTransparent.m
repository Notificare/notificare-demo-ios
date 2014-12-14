//
//  FormButtonTransparent.m
//  app
//
//  Created by Joel Oliveira on 02/12/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "FormButtonTransparent.h"

@implementation FormButtonTransparent

- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super initWithCoder:decoder]) {
        
        [[self titleLabel] setFont:BUTTON_TRANSPARENT_TEXT];
        [[self titleLabel] setTextColor:ALTO_COLOR];
        [self setBackgroundColor:WILD_SAND_COLOR];
        [[self titleLabel] setShadowColor:[UIColor clearColor]];
    }
    return self;
}

@end
