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

    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:LSSTRING(@"title_signin")];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
    
    [[self view] setBackgroundColor:WILD_SAND_COLOR];
    
    
    [self setupNavigationBar];
    
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
    
    //For iOS6
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[[self navigationController] navigationBar] setTintColor:MAIN_COLOR];
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        
    } else {
        
        [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    }

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


-(IBAction)doLogin:(id)sender{
    
    [[self signinButton] setEnabled:NO];
    
    if (![[self email] text]) {
        APP_ALERT_DIALOG(LSSTRING(@"error_signin_invalid_email"));

        [[self signinButton] setEnabled:YES];
    }else if ([[[self password] text] length] < 5) {

        APP_ALERT_DIALOG(LSSTRING(@"error_signin_invalid_password"));
        [[self signinButton] setEnabled:YES];
    } else {
        
        [[self notificare] loginWithUsername:[[self email] text] andPassword:[[self password] text] completionHandler:^(NSDictionary *info) {
            //

            [[self notificare] fetchAccountDetails:^(NSDictionary *info) {
                
                NSDictionary * user = [info objectForKey:@"user"];

                if([[user objectForKey:@"token"] isKindOfClass:[NSNull class]]){
                    
                    [[self notificare] generateAccessToken:^(NSDictionary *info) {
                        //
                    } errorHandler:^(NSError *error) {
                        //
                    }];
                }
                
                
            } errorHandler:^(NSError *error) {
                
                [[self signinButton] setEnabled:YES];
                
                APP_ALERT_DIALOG(LSSTRING(@"error_signin"));
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadge) name:@"incomingNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNavigationBar) name:@"rangingBeacons" object:nil];
    
    [self resetForm];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"incomingNotification"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"rangingBeacons"
                                                  object:nil];
    
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
