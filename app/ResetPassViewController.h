//
//  ResetPassViewController.h
//  app
//
//  Created by Joel Oliveira on 18/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormField.h"
#import "FormButton.h"
#import "InfoLabel.h"

@interface ResetPassViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) IBOutlet FormField * password;
@property (nonatomic, strong) IBOutlet FormField * passwordConfirm;
@property (nonatomic, strong) IBOutlet FormButton * resetPassButton;
@property (nonatomic, strong) IBOutlet InfoLabel * infoLabel;

@property (nonatomic, strong)  NSString * token;

-(IBAction)resetPassword:(id)sender;


@end
