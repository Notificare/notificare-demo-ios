//
//  ViewController.h
//  app
//
//  Created by Joel Oliveira on 16/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeLabel.h"

@interface MainViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView * webView;
@property (nonatomic, strong) IBOutlet UIToolbar * toolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * backButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * forwardButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * refreshButton;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic, strong) UIView * loadingView;
@property (nonatomic, strong) NSString * viewTitle;
@property (nonatomic, strong) NSString * targetUrl;
@property (nonatomic, strong) IBOutlet UIView * badge;
@property (nonatomic, strong) IBOutlet BadgeLabel * badgeNr;
@property (nonatomic, strong) IBOutlet UIButton * badgeButton;
@property (nonatomic, strong) IBOutlet UIImageView * buttonIcon;

-(void)goToUrl;

@end
