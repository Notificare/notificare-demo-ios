//
//  ViewController.m
//  app
//
//  Created by Joel Oliveira on 16/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "MainViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "Configuration.h"
#import "NotificarePushLib.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (NotificarePushLib *)notificare {
    return (NotificarePushLib *)[[self appDelegate] notificarePushLib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewsArray:[NSMutableArray array]];

    [[self scrollView] setPagingEnabled:YES];
    //float width = [[UIScreen mainScreen] bounds].size.width;
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [[self scrollView] setShowsHorizontalScrollIndicator:NO];
    [[self scrollView] setShowsVerticalScrollIndicator:NO];
    [[self scrollView] setScrollsToTop:NO];
    [[self scrollView] setDelegate:self];
    [[self scrollView] setScrollEnabled:NO];
    
    
    PageOneViewController * pageOne = [[PageOneViewController alloc] initWithNibName:@"PageOneViewController" bundle:nil];
    
    PageTwoViewController * pageTwo = [[PageTwoViewController alloc] initWithNibName:@"PageTwoViewController" bundle:nil];
    
    PageThreeViewController * pageThree = [[PageThreeViewController alloc] initWithNibName:@"PageThreeViewController" bundle:nil];
    
    [self setPageOneController:pageOne];
    [self setPageTwoController:pageTwo];
    [self setPageThreeController:pageThree];
    
    [self initViewsForMainViewController];

    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:@"Notificare"];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
    
    
    [self setPageControlUsed:NO];
    
    [self setupNavigationBar];

    [self setActivityIndicatorView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
    
    [[self activityIndicatorView]  setCenter:CGPointMake(([[UIScreen mainScreen] bounds].size.width /2)-5, ([[UIScreen mainScreen] bounds].size.height /2)-5)];
    [[self activityIndicatorView]  setContentMode:UIViewContentModeCenter];
    [[self activityIndicatorView] setHidden:NO];
    [[self activityIndicatorView] startAnimating];
    
    [self setLoadingView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    [[self loadingView] setBackgroundColor:[UIColor whiteColor]];
    [[self loadingView] addSubview:[self activityIndicatorView]];
    
    
    //For iOS6
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[[self navigationController] navigationBar] setTintColor:MAIN_COLOR];
        
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        
    } else {
        
        [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    }
    

    [[self view] setBackgroundColor:WILD_SAND_COLOR];

}

-(void)registeredDevice{

    [[self navigationController] pushViewController:[self pageTwoController] animated:YES];
  
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:YES forKey:@"tutorialUserRegistered"];
    [settings synchronize];
    
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:2.0];
}

-(void)hideLoadingView{
    [[self loadingView] removeFromSuperview];
}

-(void)showLoadingView{
    [[self view] addSubview:[self loadingView]];
}

-(void)startedLocationUpdates{
    
    [self hideLoadingView];
    [[self navigationController] pushViewController:[self pageThreeController] animated:YES];

}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    
    if([settings boolForKey:@"tutorialUserRegistered"] && [[self notificare] checkLocationUpdates]){
        [self startedLocationUpdates];
        [self showLoadingView];
    }
    
    if([settings boolForKey:@"tutorialUserRegistered"] && ![[self notificare] checkLocationUpdates]){
        [self registeredDevice];
        [self showLoadingView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadge) name:@"incomingNotification" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeredDevice) name:@"registeredDevice" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedLocationUpdates) name:@"startedLocationUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNavigationBar) name:@"rangingBeacons" object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"incomingNotification"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"rangingBeacons"
                                                  object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"registeredDevice"
//                                                  object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"startedLocationUpdate"
//                                                  object:nil];
    
}




-(void)setupNavigationBar{
    int count = [[[self appDelegate] notificarePushLib] myBadge];
    
    if(count > 0){
        [[self buttonIcon] setTintColor:ICONS_COLOR];
        [[self badgeButton] addTarget:[self viewDeckController] action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];

        NSString * badge = [NSString stringWithFormat:@"%i", count];
        [[self badgeNr] setText:badge];
        
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:[self badge]];
        [leftButton setTarget:[self viewDeckController]];
        [leftButton setAction:@selector(toggleLeftView)];
        [leftButton setTintColor:ICONS_COLOR];
        [[self navigationItem] setLeftBarButtonItem:leftButton];
    } else {
        
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenuIcon"] style:UIBarButtonItemStylePlain target:[self viewDeckController] action:@selector(toggleLeftView)];
        [leftButton setTintColor:ICONS_COLOR];
        [[self navigationItem] setLeftBarButtonItem:leftButton];
        
    }
    
    
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RightMenuIcon"] style:UIBarButtonItemStylePlain target:[self viewDeckController] action:@selector(toggleRightView)];
    

    [rightButton setTintColor:ICONS_COLOR];
    
    if([[[self appDelegate] beacons] count] > 0){
        [[self navigationItem] setRightBarButtonItem:rightButton];
    } else {
        [[self navigationItem] setRightBarButtonItem:nil];
    }
    
    
    
}

-(void)changeBadge{
    
    [self setupNavigationBar];
    
}


-(void)initViewsForMainViewController{
    
    //[[self navigationController] pushViewController:[self pageOneController] animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
