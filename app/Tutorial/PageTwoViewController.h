//
//  PageTwoViewController.h
//  app
//
//  Created by Joel Oliveira on 02/12/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageThreeViewController;

@interface PageTwoViewController : UIViewController


@property(nonatomic, strong) IBOutlet UILabel * welcome;
@property(nonatomic, strong) IBOutlet UILabel * message;
@property(nonatomic, strong) IBOutlet UIButton * button;
@property(nonatomic, strong) IBOutlet UIImageView * image;
@property(nonatomic, strong) PageThreeViewController * pageThreeController;

-(IBAction)startLocationUpdates:(id)sender;

@end
