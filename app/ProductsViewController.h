//
//  ProductsViewController.h
//  app
//
//  Created by Joel Oliveira on 18/10/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeLabel.h"

@interface ProductsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

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

-(IBAction)closeProductView:(id)sender;

@end
