//
//  PageTwoViewController.m
//  app
//
//  Created by Joel Oliveira on 02/12/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "PageTwoViewController.h"
#import "AppDelegate.h"
#import "NotificarePushLib.h"

@interface PageTwoViewController ()

@end

@implementation PageTwoViewController

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
    
    [[self message] setText:LSSTRING(@"tutorial_text_page_two")];
    [[self message] setFont:LATO_LIGHT_FONT(19)];
    [[self message] setTextColor:MAIN_COLOR];
    [[self message] setNumberOfLines:7];
    
    
    [[self welcome] setText:LSSTRING(@"tutorial_title_page_two")];
    [[self welcome] setFont:LATO_FONT(24)];
    [[self welcome] setTextColor:MAIN_COLOR];
    [[self welcome] setNumberOfLines:1];
    
    [[self button] setTitle:LSSTRING(@"tutorial_button_page_two") forState:UIControlStateNormal];
    

}

-(IBAction)startLocationUpdates:(id)sender{
    
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    if([settings boolForKey:@"tutorialUserRegistered"]){
        [[self notificare] startLocationUpdates];
    } else {
        APP_ALERT_DIALOG(@"You need to enable push notifications for this app first.");
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
