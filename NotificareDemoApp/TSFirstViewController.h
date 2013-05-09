//
//  TSFirstViewController.h
//  NotificareDemoApp
//
//  Created by Joel Oliveira on 3/22/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterEngine.h"


@interface TSFirstViewController : UIViewController

@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) TwitterEngine * twitterEngine;

@end
