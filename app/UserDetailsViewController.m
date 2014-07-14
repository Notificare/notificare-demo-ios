//
//  UserDetailsViewController.m
//  app
//
//  Created by Joel Oliveira on 18/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "AppDelegate.h"
#import "NotificarePushLib.h"
#import "IIViewDeckController.h"

@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController


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
    [[self navigationItem] setTitleView:[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Logo"]]];
    
    [self setupNavigationBar];
    
    //For iOS6
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[[self navigationController] navigationBar] setTintColor:MAIN_COLOR];
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        
    } else {
        
        [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    }
    
    

    [[self notificare] fetchAccountDetails:^(NSDictionary *info) {
        //
        NSDictionary * user = [info objectForKey:@"user"];
        [[self userName] setText:[user objectForKey:@"userName"]];
        [[self userEmail] setText:[user objectForKey:@"userID"]];
        
        if([user objectForKey:@"accessToken"]){
            
            [[self userToken] setText:[NSString stringWithFormat:@"%@@pushmail.notifica.re",[user objectForKey:@"accessToken"]]];
            
        }
        
    } errorHandler:^(NSError *error) {
        //
    }];

    
    
    
    [self resetForm];
    [[self password] setPlaceholder:LSSTRING(@"placeholder_newpass")];
    [[self password] setDelegate:self];
    [[self password] setSecureTextEntry:YES];
    [[self passwordConfirm] setSecureTextEntry:YES];
    [[self passwordConfirm] setDelegate:self];
    [[self passwordConfirm] setPlaceholder:LSSTRING(@"placeholder_confirm_newpass")];
    
    [[self userToken] setFont:LATO_FONT(10)];
    
    [[self changePassButton] setTitle:LSSTRING(@"button_changepass") forState:UIControlStateNormal];
    [[self generateTokenButton] setTitle:LSSTRING(@"button_generatetoken") forState:UIControlStateNormal];
    [[self logoutButton] setTitle:LSSTRING(@"button_logout") forState:UIControlStateNormal];
    [[self logoutButton] setBackgroundColor:[UIColor redColor]];

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
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconSignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];

    [rightButton setTintColor:[UIColor blackColor]];

    [[self navigationItem] setRightBarButtonItem:rightButton];
    
}

-(void)changeBadge{
    
    [self setupNavigationBar];
    
}



-(IBAction)generateToken:(id)sender{
    [[self generateTokenButton] setEnabled:NO];
    [[self notificare] generateAccessToken:^(NSDictionary *info) {
        //
        NSDictionary * user = [info objectForKey:@"user"];
        [[self userToken] setText:[NSString stringWithFormat:@"%@@pushmail.notifica.re",[user objectForKey:@"accessToken"]]];
        [[self generateTokenButton] setEnabled:YES];
        APP_ALERT_DIALOG(LSSTRING(@"success_message_generate_token"));
    } errorHandler:^(NSError *error) {
        //
        [[self generateTokenButton] setEnabled:YES];
        APP_ALERT_DIALOG(LSSTRING(@"error_message_generate_token"));
    }];
}



-(IBAction)changePass:(id)sender{
    
    [[self changePassButton] setEnabled:NO];
    
    if(![self password] && ![self passwordConfirm]){
        
        [[self changePassButton] setEnabled:YES];
         APP_ALERT_DIALOG(LSSTRING(@"error_password_changepass"));
        
    }else if (![[[self password] text] isEqualToString:[[self passwordConfirm] text]]) {
        
        [[self changePassButton] setEnabled:YES];
        APP_ALERT_DIALOG(LSSTRING(@"error_create_account_passwords_match"));
        
    }else if ([[[self passwordConfirm] text] length] < 5) {

        [[self changePassButton] setEnabled:YES];
        APP_ALERT_DIALOG(LSSTRING(@"error_create_account_small_password"));
        
    } else {
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setObject:[[self password] text] forKey:@"password"];
        [[self notificare] changePassword:params completionHandler:^(NSDictionary *info) {
            //
            [self resetForm];
            [[self changePassButton] setEnabled:YES];
            APP_ALERT_DIALOG(LSSTRING(@"success_message_changepass"));
        } errorHandler:^(NSError *error) {
            //
            NSLog(@"%@",error);
            [[self changePassButton] setEnabled:YES];
            [self resetForm];
            APP_ALERT_DIALOG( LSSTRING(@"error_message_changepass"));
        }];
        
    }
   
}

-(IBAction)logout:(id)sender{
    [[self notificare] logoutAccount];
}


-(void)logout{
    [[self notificare] logoutAccount];
}

-(void)resetForm{
    
    [[self password] setText:@""];
    [[self passwordConfirm] setText:@""];
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
