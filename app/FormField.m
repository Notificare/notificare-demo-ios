//
//  FormField.m
//  app
//
//  Created by Joel Oliveira on 17/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "FormField.h"
#import <QuartzCore/QuartzCore.h>

@implementation FormField


- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super initWithCoder:decoder]) {

        [self setFont:FIELD_TEXT];
        [self setBackgroundColor:FIELD_BACKGROUND_COLOR];
        [self setTextColor:FIELD_TEXT_COLOR];
        [self setBorderStyle:UITextBorderStyleRoundedRect];

        self.layer.cornerRadius= FIELD_CORNER_RADIUS;
        self.layer.masksToBounds= YES;
        self.layer.borderColor= [FIELD_BORDER_COLOR CGColor];
        self.layer.borderWidth= FIELD_BORDER_WIDTH;

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
