//
//  PageOneViewController.m
//  app
//
//  Created by Joel Oliveira on 02/12/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "PageOneViewController.h"
#import "AppDelegate.h"
#import "NotificarePushLib.h"
#import "PageTwoViewController.h"

@interface PageOneViewController ()

@end

@implementation PageOneViewController

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NotificarePushLib *)notificare {
    return (NotificarePushLib *)[[self appDelegate] notificarePushLib];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self view] setBackgroundColor:WILD_SAND_COLOR];
    
    [[self message] setText:LSSTRING(@"tutorial_text_page_one")];
    [[self message] setFont:LATO_LIGHT_FONT(19)];
    [[self message] setTextColor:MAIN_COLOR];
    [[self message] setNumberOfLines:7];
    
    
    [[self welcome] setText:LSSTRING(@"tutorial_title_page_one")];
    [[self welcome] setFont:LATO_FONT(24)];
    [[self welcome] setTextColor:MAIN_COLOR];
    [[self welcome] setNumberOfLines:1];
    
    [[self button] setTitle:LSSTRING(@"tutorial_button_page_one") forState:UIControlStateNormal];
    
    [self setPageTwoController:[[PageTwoViewController alloc] initWithNibName:@"PageTwoViewController" bundle:nil]];
    
    [[self navigationItem] setHidesBackButton:YES];
    [[self navigationItem] setLeftBarButtonItem:nil];
    [[self navigationItem] setRightBarButtonItem:nil];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
    
   [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    
    
    [[self view] setBackgroundColor:WILD_SAND_COLOR];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[self navigationItem] setHidesBackButton:YES];
    [[self navigationItem] setLeftBarButtonItem:nil];
    [[self navigationItem] setRightBarButtonItem:nil];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeredDevice) name:@"registeredDevice" object:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"registeredDevice"
                                                  object:nil];
    
}

-(IBAction)registerForNotifications:(id)sender{
    [[self button] setUserInteractionEnabled:NO];
    [[self notificare] registerForNotifications];
    
}

-(void)registeredDevice{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:YES forKey:@"tutorialUserRegistered"];
    [settings synchronize];
    [[self navigationController] pushViewController:[self pageTwoController] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
