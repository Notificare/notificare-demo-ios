//
//  InfoLabel.m
//  app
//
//  Created by Joel Oliveira on 17/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "InfoLabel.h"

@implementation InfoLabel


- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super initWithCoder:decoder]) {
        
        self.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [self setFont:LATO_FONT(14)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTextColor:[UIColor blackColor]];
        [self setAdjustsFontSizeToFitWidth:NO];
        [self setNumberOfLines:2];
        
        self.layer.cornerRadius= LABEL_CORNER_RADIUS;
        self.layer.masksToBounds= YES;
        self.layer.borderColor= [LABEL_BORDER_COLOR CGColor];
        self.layer.borderWidth= LABEL_BORDER_WIDTH;
        
        CGRect frameRect = self.frame;
        frameRect.size.height = 45.0f;
        self.frame = frameRect;
    }
    return self;
}


- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
