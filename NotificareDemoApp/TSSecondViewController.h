//
//  TSSecondViewController.h
//  NotificareDemoApp
//
//  Created by Joel Oliveira on 3/22/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSSecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *beacons;


@end
