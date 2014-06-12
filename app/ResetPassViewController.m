//
//  ResetPassViewController.m
//  app
//
//  Created by Joel Oliveira on 18/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "ResetPassViewController.h"
#import "NotificarePushLib.h"
#import "AppDelegate.h"
#import "IIViewDeckController.h"
@interface ResetPassViewController ()

@end

@implementation ResetPassViewController



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
    [[self password] setPlaceholder:LSSTRING(@"placeholder_newpass")];
    [[self password] setDelegate:self];
    [[self password] setSecureTextEntry:YES];
    [[self passwordConfirm] setSecureTextEntry:YES];
    [[self passwordConfirm] setDelegate:self];
    [[self passwordConfirm] setPlaceholder:LSSTRING(@"placeholder_confirm_newpass")];

    [[self resetPassButton] setTitle:LSSTRING(@"button_resetpass") forState:UIControlStateNormal];
    
}


-(IBAction)resetPassword:(id)sender{
    
    [[self resetPassButton] setEnabled:NO];
    if (![[[self password] text] isEqualToString:[[self passwordConfirm] text]]) {
       // [[self infoLabel] setText:LSSTRING(@"error_resetpass_passwords_match")];
        APP_ALERT_DIALOG(LSSTRING(@"error_resetpass_passwords_match"));
         [[self resetPassButton] setEnabled:YES];
    }else if ([[[self password] text] length] < 5) {
        APP_ALERT_DIALOG(LSSTRING(@"error_resetpass_small_password"));
        //[[self infoLabel] setText:LSSTRING(@"error_resetpass_small_password")];
        [[self resetPassButton] setEnabled:YES];
    } else {

        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setObject:[[self password] text] forKey:@"password"];
        [[self notificare] resetPassword:params withToken:[self token] completionHandler:^(NSDictionary *info) {
            //
            //[[self infoLabel] setText:LSSTRING(@"success_resetpass")];
            APP_ALERT_DIALOG(LSSTRING(@"success_resetpass"));
            [[self resetPassButton] setEnabled:YES];
            
        } errorHandler:^(NSError *error) {
            //
            APP_ALERT_DIALOG(LSSTRING(@"error_resetpass"));
            //[[self infoLabel] setText:LSSTRING(@"error_resetpass")];
            [[self resetPassButton] setEnabled:YES];
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
    
    [[self password] setText:@""];
    [[self passwordConfirm] setText:@""];
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


