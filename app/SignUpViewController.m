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

@property (assign, nonatomic) CGPoint viewCenter;

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
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:LSSTRING(@"title_signup")];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    [leftButton setTintColor:ICONS_COLOR];
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


    
    [self setViewCenter:[[self view] center]];
    [[self view] setBackgroundColor:WILD_SAND_COLOR];
    
}



-(IBAction)createAccount:(id)sender{
    
    [[self signupButton] setEnabled:NO];
    
    if (![[self email] text]) {
        
        APP_ALERT_DIALOG(LSSTRING(@"error_create_account_invalid_email"));
        [[self signupButton] setEnabled:YES];
    }else if (![[[self password] text] isEqualToString:[[self passwordConfirm] text]]) {
        
        APP_ALERT_DIALOG(LSSTRING(@"error_create_account_passwords_match"));
        [[self signupButton] setEnabled:YES];
    }else if ([[[self passwordConfirm] text] length] < 5) {
        APP_ALERT_DIALOG(LSSTRING(@"error_create_account_small_password"));
        [[self signupButton] setEnabled:YES];
    } else {
        
        [[self notificare] createAccount:[[self email] text]
                                withName:[[self name] text]
                             andPassword:[[self password] text]
                       completionHandler:^(NSDictionary *info) {

            APP_ALERT_DIALOG(LSSTRING(@"success_create_account"));

            [[self signupButton] setEnabled:YES];
            [[self email] setText:@""];
            [[self name] setText:@""];
            [[self password] setText:@""];
            [[self passwordConfirm] setText:@""];
            [[self navigationController] popToRootViewControllerAnimated:YES];
            
        } errorHandler:^(NSError *error) {

            APP_ALERT_DIALOG(LSSTRING(@"error_create_account"));

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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
}

- (void)keyboardDidShow:(NSNotification *)note
{
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 65);
                         }
                         completion:^(BOOL finished) {
    
                         }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             self.view.center = [self viewCenter];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self resetForm];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
