//
//  UserDetailsViewController.h
//  app
//
//  Created by Joel Oliveira on 18/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoLabel.h"
#import "FormButton.h"
#import "FormField.h"
#import "BadgeLabel.h"

@interface UserDetailsViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet InfoLabel * userName;
@property (nonatomic, strong) IBOutlet InfoLabel * userToken;
@property (nonatomic, strong) IBOutlet InfoLabel * userEmail;
@property (nonatomic, strong) IBOutlet FormField * password;
@property (nonatomic, strong) IBOutlet FormField * passwordConfirm;
@property (nonatomic, strong) IBOutlet FormButton * changePassButton;
@property (nonatomic, strong) IBOutlet FormButton * generateTokenButton;
@property (nonatomic, strong) IBOutlet FormButton * logoutButton;
@property (nonatomic, strong) IBOutlet UIView * badge;
@property (nonatomic, strong) IBOutlet BadgeLabel * badgeNr;
@property (nonatomic, strong) IBOutlet UIButton * badgeButton;
@property (nonatomic, strong) IBOutlet UIImageView * buttonIcon;

-(IBAction)generateToken:(id)sender;
-(IBAction)changePass:(id)sender;
-(IBAction)logout:(id)sender;

@end
