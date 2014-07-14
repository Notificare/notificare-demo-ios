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

@interface MainViewController ()

@end

@implementation MainViewController


- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitleView:[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Logo"]]];
    
    [self setupNavigationBar];
    
    
    [self setActivityIndicatorView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
    
    
    [[self activityIndicatorView] setHidden:YES];
    [[self activityIndicatorView]  setCenter:CGPointMake( self.view.frame.size.width /2-5, self.view.frame.size.height /2-5)];
    [[self activityIndicatorView]  setContentMode:UIViewContentModeCenter];
    
    [self setLoadingView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]];
    [[self loadingView] setBackgroundColor:[UIColor whiteColor]];
    [[self loadingView] addSubview:[self activityIndicatorView]];
    [[self view] addSubview:[self loadingView]];
    
    [[self backButton] setImage:[UIImage imageNamed: @"BackButton"]];
    [[self forwardButton] setImage:[UIImage imageNamed: @"ForwardButton"]];
    [[self refreshButton] setImage:[UIImage imageNamed: @"RefreshButton"]];
    
    [[self backButton] setEnabled:NO];
    [[self forwardButton] setEnabled:NO];
    [[self refreshButton] setEnabled:YES];
    
    [[self toolbar] setBackgroundColor:[UIColor whiteColor]];
    [[self toolbar] setTintColor:[UIColor blackColor]];
    [[self toolbar] setTranslucent:NO];
    
    
    //For iOS6
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[[self navigationController] navigationBar] setTintColor:MAIN_COLOR];
        
        [[self toolbar] setTintColor:MAIN_COLOR];
        
        [[self backButton] setTintColor:[UIColor blackColor]];
        [[self forwardButton] setTintColor:[UIColor blackColor]];
        [[self refreshButton] setTintColor:[UIColor blackColor]];
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        
    } else {
        
        [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    }
    
    [self goToUrl];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadge) name:@"incomingNotification" object:nil];
}


-(void)setupNavigationBar{
    int count = [[[self appDelegate] notificarePushLib] myBadge];
    if(count > 0){
        [[self buttonIcon] setTintColor:[UIColor whiteColor]];
        [[self badgeButton] addTarget:[self viewDeckController] action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        NSString * badge = [NSString stringWithFormat:@"%i", count];
        [[self badgeNr] setText:badge];
        
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:[self badge]];
        [leftButton setTarget:[self viewDeckController]];
        [leftButton setAction:@selector(toggleLeftView)];
        [leftButton setTintColor:[UIColor blackColor]];
        [[self navigationItem] setLeftBarButtonItem:leftButton];
    } else {
        
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenuIcon"] style:UIBarButtonItemStylePlain target:[self viewDeckController] action:@selector(toggleLeftView)];
        [leftButton setTintColor:[UIColor blackColor]];
        [[self navigationItem] setLeftBarButtonItem:leftButton];
        
    }
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RightMenuIcon"] style:UIBarButtonItemStylePlain target:[self viewDeckController] action:@selector(toggleRightView)];
    
    [rightButton setTintColor:[UIColor blackColor]];

    [[self navigationItem] setRightBarButtonItem:rightButton];
    
}

-(void)changeBadge{
    
    [self setupNavigationBar];
    
}


-(void)goToUrl{
    NSURL *nsUrl=[NSURL URLWithString:[self targetUrl]];
    NSURLRequest *nsRequest=[NSURLRequest requestWithURL:nsUrl];
    [[self webView] loadRequest:nsRequest];
    
    [self setTitle:LSSTRING([self viewTitle])];

    [[self activityIndicatorView]  startAnimating];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[self activityIndicatorView] setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    [self performSelector:@selector(animateDidLoad) withObject:nil afterDelay:2.0];
    
    [[self webView] stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0.0, 70.0)"];

}

-(void)animateDidLoad{
    [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [[self loadingView] setAlpha:0.f];
    } completion:^(BOOL finished) {
        
        [[self activityIndicatorView] setHidden:YES];
        
        if([[self webView] canGoBack]){
            [[self backButton] setEnabled:YES];
        } else {
            [[self backButton] setEnabled:NO];
        }
        
        if([[self webView] canGoForward]){
            [[self forwardButton] setEnabled:YES];
        } else {
            [[self forwardButton] setEnabled:NO];
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self activityIndicatorView] setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [[self activityIndicatorView] setHidden:YES];
    
    if([error code] != NSURLErrorCancelled){
        ALERT_DIALOG(LSSTRING(@"title_webview_load_fail"), LSSTRING(@"message_webview_load_fail"));
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
