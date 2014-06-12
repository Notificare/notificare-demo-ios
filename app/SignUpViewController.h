//
//  SignUpViewController.h
//  app
//
//  Created by Joel Oliveira on 17/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormButton.h"
#import "FormField.h"
#import "InfoLabel.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet FormField * name;
@property (nonatomic, strong) IBOutlet FormField * email;
@property (nonatomic, strong) IBOutlet FormField * password;
@property (nonatomic, strong) IBOutlet FormField * passwordConfirm;
@property (nonatomic, strong) IBOutlet FormButton * signupButton;
@property (nonatomic, strong) IBOutlet FormButton * goBackButton;
@property (nonatomic, strong) IBOutlet InfoLabel * infoLabel;

-(IBAction)createAccount:(id)sender;

@end
