//
//  LostPassViewController.m
//  app
//
//  Created by Joel Oliveira on 17/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "LostPassViewController.h"
#import "NotificarePushLib.h"
#import "AppDelegate.h"
#import "IIViewDeckController.h"
@interface LostPassViewController ()

@end

@implementation LostPassViewController



- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NotificarePushLib *)notificare {
    return (NotificarePushLib *)[[self appDelegate] notificarePushLib];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self navigationItem] setTitleView:[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Logo"]]];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    [leftButton setTintColor:[UIColor blackColor]];
    //[rightButton setTintColor:[UIColor whiteColor]];
    
    [[self navigationItem] setLeftBarButtonItem:leftButton];
    [[self navigationItem] setRightBarButtonItem:nil];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[[self navigationController] navigationBar] setTintColor:MAIN_COLOR];
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        
    } else {
        
        [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    }
    
    
    [self resetForm];

    [[self email] setPlaceholder:LSSTRING(@"placeholder_email")];
    [[self email] setDelegate:self];

    [[self forgotPassButton] setTitle:LSSTRING(@"button_forgotpass") forState:UIControlStateNormal];
    
}


-(IBAction)recoverPassword:(id)sender{
    [[self forgotPassButton] setEnabled:NO];
    
    if (![[self email] text]) {
        APP_ALERT_DIALOG(LSSTRING(@"error_forgotpass_invalid_email"));
       // [[self infoLabel] setText:LSSTRING(@"error_forgotpass_invalid_email")];
        [[self forgotPassButton] setEnabled:YES];
    } else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setObject:[[self email] text] forKey:@"email"];
        [[self notificare] sendPassword:params completionHandler:^(NSDictionary *info) {
            //
            //[[self infoLabel] setText:LSSTRING(@"success_forgotpass")];
            APP_ALERT_DIALOG(LSSTRING(@"success_forgotpass"));
            [[self forgotPassButton] setEnabled:YES];
        } errorHandler:^(NSError *error) {
            //
            //[[self infoLabel] setText:LSSTRING(@"error_forgotpass")];
            APP_ALERT_DIALOG(LSSTRING(@"error_forgotpass"));
            [[self forgotPassButton] setEnabled:YES];
        }];
        
    }
}



-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO;
}


-(void)goBack{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)resetForm{

    [[self email] setText:@""];
    [[self infoLabel] setText:@""];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self resetForm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
