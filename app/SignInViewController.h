//
//  SignInViewController.h
//  app
//
//  Created by Joel Oliveira on 16/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "LostPassViewController.h"
#import "FormButton.h"
#import "FormField.h"
#import "InfoLabel.h"
#import "BadgeLabel.h"

@class SignUpViewController;
@class LostPassViewController;

@interface SignInViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet FormField * email;
@property (nonatomic, strong) IBOutlet FormField * password;
@property (nonatomic, strong) IBOutlet FormButton * signinButton;
@property (nonatomic, strong) IBOutlet FormButton * forgotPasswordButton;
@property (nonatomic, strong) IBOutlet FormButton * createAccountButton;
@property (nonatomic, strong) IBOutlet InfoLabel * infoLabel;
@property (nonatomic, strong) SignUpViewController * signUpView;
@property (nonatomic, strong) LostPassViewController * lostpassView;
@property (nonatomic, strong) IBOutlet UIView * badge;
@property (nonatomic, strong) IBOutlet BadgeLabel * badgeNr;
@property (nonatomic, strong) IBOutlet UIButton * badgeButton;
@property (nonatomic, strong) IBOutlet UIImageView * buttonIcon;

-(IBAction)doLogin:(id)sender;
-(IBAction)forgottenPassword:(id)sender;
-(IBAction)goToCreateAccount:(id)sender;

@end
