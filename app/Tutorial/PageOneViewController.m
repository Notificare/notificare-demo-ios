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
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

-(IBAction)registerForNotifications:(id)sender{
    [[self notificare] registerForNotifications];
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
