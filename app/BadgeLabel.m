//
//  BadgeLabel.m
//  app
//
//  Created by Joel Oliveira on 11/07/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "BadgeLabel.h"

@implementation BadgeLabel


- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super initWithCoder:decoder]) {
        
        self.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [self setFont:BADGE_TEXT];
        [self setBackgroundColor:BADGE_BACKGROUND_COLOR];
        [self setTextColor:BADGE_TEXT_COLOR];
        [self setAdjustsFontSizeToFitWidth:NO];
        [self setNumberOfLines:1];
        
        self.layer.cornerRadius= BADGE_CORNER_RADIUS;
        self.layer.masksToBounds= YES;
        self.layer.borderColor= [BADGE_BORDER_COLOR CGColor];
        self.layer.borderWidth= BADGE_BORDER_WIDTH;
        self.layer.bounds = CGRectMake(0.0f, 0.0f, BADGE_CORNER_RADIUS *2, BADGE_CORNER_RADIUS *2);
        
    }
    return self;
}


- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {5, 5, 5, 5};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end