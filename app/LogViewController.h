//
//  LogViewController.h
//  app
//
//  Created by Joel Oliveira on 12/05/15.
//  Copyright (c) 2015 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeLabel.h"
#import <MessageUI/MessageUI.h>

@interface LogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UITableViewController * tableViewController;
@property (nonatomic, strong) IBOutlet UIView * loadingScreen;
@property (nonatomic, strong) NSMutableArray * navSections;
@property (nonatomic, strong) NSMutableArray * sectionTitles;
@property (nonatomic, strong) IBOutlet UIView * badge;
@property (nonatomic, strong) IBOutlet BadgeLabel * badgeNr;
@property (nonatomic, strong) IBOutlet UIButton * badgeButton;
@property (nonatomic, strong) IBOutlet UIImageView * buttonIcon;
@property (nonatomic, strong) UILabel * emptyMessage;
@property (nonatomic, strong) UIView * loadingView;
@property (nonatomic, strong) IBOutlet UIView * productView;
@property (nonatomic, strong) IBOutlet UIImageView * productImage;

@end
