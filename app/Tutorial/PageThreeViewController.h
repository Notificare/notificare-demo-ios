//
//  PageThreeViewController.h
//  app
//
//  Created by Joel Oliveira on 02/12/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeLabel.h"
#import <MessageUI/MessageUI.h>

@interface PageThreeViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) IBOutlet UILabel * welcome;
@property(nonatomic, strong) IBOutlet UILabel * message;
@property(nonatomic, strong) IBOutlet UIButton * buttonFacebook;
@property(nonatomic, strong) IBOutlet UIButton * buttonTwitter;
@property(nonatomic, strong) IBOutlet UIButton * buttonDashboard;
@property(nonatomic, strong) IBOutlet UIButton * buttonMail;
@property (strong, nonatomic) MFMailComposeViewController *mailComposer;
@property (nonatomic, strong) IBOutlet UIView * badge;
@property (nonatomic, strong) IBOutlet BadgeLabel * badgeNr;
@property (nonatomic, strong) IBOutlet UIButton * badgeButton;
@property (nonatomic, strong) IBOutlet UIImageView * buttonIcon;

-(IBAction)goToFacebook:(id)sender;
-(IBAction)goToTwitter:(id)sender;
-(IBAction)openMail:(id)sender;

@end
