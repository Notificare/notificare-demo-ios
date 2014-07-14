//
//  SignInViewController.m
//  app
//
//  Created by Joel Oliveira on 16/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"
#import "NotificarePushLib.h"
#import "IIViewDeckController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController


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
    
    [self setupNavigationBar];
    
    //For iOS6
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[[self navigationController] navigationBar] setTintColor:MAIN_COLOR];

        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        
    } else {
        
        [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    }
    
    [self resetForm];
    [[self email] setDelegate:self];
    [[self email] setPlaceholder:LSSTRING(@"placeholder_email")];
    [[self email] setDelegate:self];
    [[self password] setDelegate:self];
    [[self password] setPlaceholder:LSSTRING(@"placeholder_password")];
    [[self password] setSecureTextEntry:YES];
    [[self password] setDelegate:self];
    
    [[self signinButton] setTitle:LSSTRING(@"button_signin") forState:UIControlStateNormal];
    [[self createAccountButton] setTitle:LSSTRING(@"button_signup") forState:UIControlStateNormal];
    [[self forgotPasswordButton] setTitle:LSSTRING(@"button_forgotpass") forState:UIControlStateNormal];


    [self setSignUpView:[[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil]];
    [self setLostpassView:[[LostPassViewController alloc] initWithNibName:@"LostPassViewController" bundle:nil]];
    
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

-(IBAction)doLogin:(id)sender{
    
    [[self signinButton] setEnabled:NO];
    if (![[self email] text]) {
        APP_ALERT_DIALOG(LSSTRING(@"error_signin_invalid_email"));
        //[[self infoLabel] setText:LSSTRING(@"error_signin_invalid_email")];
        [[self signinButton] setEnabled:YES];
    }else if ([[[self password] text] length] < 5) {
        //[[self infoLabel] setText:LSSTRING(@"error_signin_invalid_password")];
        APP_ALERT_DIALOG(LSSTRING(@"error_signin_invalid_password"));
        [[self signinButton] setEnabled:YES];
    } else {
        
        [[self notificare] loginWithUsername:[[self email] text] andPassword:[[self password] text] completionHandler:^(NSDictionary *info) {
            //

            [[self notificare] fetchAccountDetails:^(NSDictionary *info) {
                
                NSDictionary * user = [info objectForKey:@"user"];
                [[self notificare] registerDevice:[[self notificare] deviceTokenData] withUserID:[user objectForKey:@"userID"] withUsername:[user objectForKey:@"userName"] completionHandler:^(NSDictionary *info) {
                    //
                    [[self notificare] startLocationUpdates];
                    [[self signinButton] setEnabled:YES];
                } errorHandler:^(NSError *error) {
                    //
                     APP_ALERT_DIALOG(LSSTRING(@"error_signin"));
                    //[[self infoLabel] setText:LSSTRING(@"error_signin")];
                    [[self signinButton] setEnabled:YES];
                }];
                
            } errorHandler:^(NSError *error) {
                //
                NSLog(@"error on fetch details: %@", error);
                [[self signinButton] setEnabled:YES];
                 APP_ALERT_DIALOG(LSSTRING(@"error_signin"));
               // [[self infoLabel] setText:LSSTRING(@"error_signin")];
            }];
            
            
        } errorHandler:^(NSError *error) {
            //
            [[self signinButton] setEnabled:YES];

            switch ([error code]) {
                case kNotificareErrorCodeBadRequest:
                    APP_ALERT_DIALOG(LSSTRING(@"error_signin_invalid_email"));
                    break;
                    
                case kNotificareErrorCodeForbidden:
                    APP_ALERT_DIALOG(LSSTRING(@"error_signin_invalid_password"));
                    break;
                    
                default:
                    APP_ALERT_DIALOG(LSSTRING(@"error_signin"));
                    break;
            }
        }];
    }
    
}

-(IBAction)forgottenPassword:(id)sender{
     [[self navigationController] pushViewController:[self lostpassView] animated:YES];
}

-(IBAction)goToCreateAccount:(id)sender{
    [[self navigationController] pushViewController:[self signUpView] animated:YES];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self resetForm];
}

-(void)resetForm{
    
    [[self email] setText:@""];
    [[self password] setText:@""];
    [[self infoLabel] setText:@""];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
