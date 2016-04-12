//
//  AssetsViewController.h
//  app
//
//  Created by Joel Oliveira on 28/03/16.
//  Copyright © 2016 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeLabel.h"

@interface AssetsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIWebViewDelegate>

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
@property (nonatomic, strong) NSString * searchTerms;


@end
