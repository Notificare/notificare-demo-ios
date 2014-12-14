//
//  ViewController.h
//  app
//
//  Created by Joel Oliveira on 16/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeLabel.h"
#import "PageOneViewController.h"
#import "PageTwoViewController.h"
#import "PageThreeViewController.h"

@class PageOneViewController;
@class PageTwoViewController;
@class PageThreeViewController;

@interface MainViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIPageControl * pageControl;
@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) IBOutlet UIView * badge;
@property (nonatomic, strong) IBOutlet BadgeLabel * badgeNr;
@property (nonatomic, strong) IBOutlet UIButton * badgeButton;
@property (nonatomic, strong) IBOutlet UIImageView * buttonIcon;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic, strong) UIView * loadingView;
@property (nonatomic, strong) NSMutableArray * imagesArray;
@property (nonatomic, strong) NSMutableArray * viewsArray;
@property (nonatomic, strong) PageOneViewController * pageOneController;
@property (nonatomic, strong) PageTwoViewController * pageTwoController;
@property (nonatomic, strong) PageThreeViewController * pageThreeController;
@property (nonatomic, assign) BOOL pageControlUsed;


@end
