//
//  PageOneViewController.h
//  app
//
//  Created by Joel Oliveira on 02/12/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageTwoViewController;

@interface PageOneViewController : UIViewController

@property(nonatomic, strong) IBOutlet UILabel * welcome;
@property(nonatomic, strong) IBOutlet UILabel * message;
@property(nonatomic, strong) IBOutlet UIButton * button;
@property(nonatomic, strong) PageTwoViewController * pageTwoController;

-(IBAction)registerForNotifications:(id)sender;

@end
