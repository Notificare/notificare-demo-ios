//
//  UserDetailsOptionsViewController.h
//  app
//
//  Created by Joel Oliveira on 11/10/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificareUserPreference.h"
#import "NotificareSegment.h"


@interface UserDetailsOptionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UITableViewController * tableViewController;
@property (nonatomic, strong) NSMutableArray * navSections;
@property (nonatomic, strong) NSMutableArray * sectionTitles;
@property (nonatomic, strong) NotificareUserPreference * preference;

@end
