//
//  FormButton.m
//  app
//
//  Created by Joel Oliveira on 17/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "FormButton.h"

@implementation FormButton

- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super initWithCoder:decoder]) {
        
        [[self titleLabel] setFont:BUTTON_TEXT];
        [[self titleLabel] setTextColor:BUTTON_TEXT_COLOR];
        [self setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [[self titleLabel] setShadowColor:[UIColor blackColor]];
        
        self.layer.cornerRadius= BUTTON_CORNER_RADIUS;
        self.layer.masksToBounds= YES;
        self.layer.borderColor= [BUTTON_BORDER_COLOR CGColor];
        self.layer.borderWidth= BUTTON_BORDER_WIDTH;
        
        
    }
    return self;
}



@end
