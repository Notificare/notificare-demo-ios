//
//  SignUpViewController.m
//  app
//
//  Created by Joel Oliveira on 17/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "SignUpViewController.h"
#import "NotificarePushLib.h"
#import "AppDelegate.h"
#import "IIViewDeckController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController


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
    [[self name] setPlaceholder:LSSTRING(@"placeholder_name")];
    [[self name] setDelegate:self];
    [[self email] setPlaceholder:LSSTRING(@"placeholder_email")];
    [[self email] setDelegate:self];
    [[self password] setPlaceholder:LSSTRING(@"placeholder_password")];
    [[self password] setDelegate:self];
    [[self password] setSecureTextEntry:YES];
    [[self passwordConfirm] setSecureTextEntry:YES];
    [[self passwordConfirm] setDelegate:self];
    [[self passwordConfirm] setPlaceholder:LSSTRING(@"placeholder_confirm_password")];
    [[self signupButton] setTitle:LSSTRING(@"button_signup") forState:UIControlStateNormal];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self resetForm];
}

-(IBAction)createAccount:(id)sender{
    
    [[self signupButton] setEnabled:NO];
    
    if (![[self email] text]) {
         APP_ALERT_DIALOG(LSSTRING(@"error_create_account_invalid_email"));
        //[[self infoLabel] setText:LSSTRING(@"error_create_account_invalid_email")];
        [[self signupButton] setEnabled:YES];
    }else if (![[[self password] text] isEqualToString:[[self passwordConfirm] text]]) {
        //[[self infoLabel] setText:LSSTRING(@"error_create_account_passwords_match")];
        APP_ALERT_DIALOG(LSSTRING(@"error_create_account_passwords_match"));
        [[self signupButton] setEnabled:YES];
    }else if ([[[self passwordConfirm] text] length] < 5) {
        APP_ALERT_DIALOG(LSSTRING(@"error_create_account_small_password"));
       // [[self infoLabel] setText:LSSTRING(@"error_create_account_small_password")];
        [[self signupButton] setEnabled:YES];
    } else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setObject:[[self email] text] forKey:@"email"];
        [params setObject:[[self password] text] forKey:@"password"];
        [params setObject:[[self name] text] forKey:@"userName"];
        [[self notificare] createAccount:params completionHandler:^(NSDictionary *info) {

            APP_ALERT_DIALOG(LSSTRING(@"success_create_account"));
           //[[self infoLabel] setText:LSSTRING(@"success_create_account")];
            [[self signupButton] setEnabled:YES];
        } errorHandler:^(NSError *error) {

            APP_ALERT_DIALOG(LSSTRING(@"error_create_account"));
           // [[self infoLabel] setText:LSSTRING(@"error_create_account")];
            [[self signupButton] setEnabled:YES];
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
    [[self name] setText:@""];
    [[self email] setText:@""];
    [[self password] setText:@""];
    [[self passwordConfirm] setText:@""];
    [[self infoLabel] setText:@""];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
