//
//  PageThreeViewController.m
//  app
//
//  Created by Joel Oliveira on 02/12/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "PageThreeViewController.h"
#import "Configuration.h"
#import "AppDelegate.h"
#import "NotificarePushLib.h"
#import "IIViewDeckController.h"

@interface PageThreeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation PageThreeViewController


- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NotificarePushLib *)notificare {
    return (NotificarePushLib *)[[self appDelegate] notificarePushLib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self scrollView] addSubview:[self contentView]];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:@"Notificare"];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
    
    [[self view] setBackgroundColor:WILD_SAND_COLOR];
    
    [[self message] setText:LSSTRING(@"tutorial_text_page_three")];
    [[self message] setFont:LATO_LIGHT_FONT(19)];
    [[self message] setTextColor:MAIN_COLOR];
    [[self message] setNumberOfLines:7];
    
    
    [[self welcome] setText:LSSTRING(@"tutorial_title_page_three")];
    [[self welcome] setFont:LATO_FONT(24)];
    [[self welcome] setTextColor:MAIN_COLOR];
    [[self welcome] setNumberOfLines:1];
    
    [[self buttonDashboard] setTitle:LSSTRING(@"tutorial_button_page_three") forState:UIControlStateNormal];
    
    [self setupNavigationBar];
    
    //For iOS6
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[[self navigationController] navigationBar] setTintColor:MAIN_COLOR];
        
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        
    } else {
        
        [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    }
    
    
    [[self view] setBackgroundColor:WILD_SAND_COLOR];
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


-(IBAction)openMail:(id)sender{
    
    if([MFMailComposeViewController canSendMail]){
        NSArray* recipients = [@"support@notifica.re" componentsSeparatedByString: @","];
        [self setMailComposer:[[MFMailComposeViewController alloc] init]];
        [[self mailComposer] setMailComposeDelegate:self];
        [[self mailComposer] setToRecipients:recipients];
        [[self mailComposer] setSubject:LSSTRING(@"mail_subject_text")];
        [[self mailComposer] setMessageBody:LSSTRING(@"mail_body_text") isHTML:NO];
        [self presentViewController:[self mailComposer] animated:YES completion:^{
            
        }];
        
    }
}

-(IBAction)openDashboard:(id)sender{
    
    NSURL * urlBrowser = [NSURL URLWithString:@"https://dashboard.notifica.re"];
    [[UIApplication sharedApplication] openURL:urlBrowser];
}


-(IBAction)goToFacebook:(id)sender{

    NSURL *urlApp = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",[[Configuration shared] getProperty:@"facebook"]]];
    
    if([[UIApplication sharedApplication] canOpenURL:urlApp]){
       [[UIApplication sharedApplication] openURL:urlApp];
    } else {
        NSURL * urlBrowser = [NSURL URLWithString:[NSString stringWithFormat:@"https://facebook.com/%@",[[Configuration shared] getProperty:@"facebook"]]];
        [[UIApplication sharedApplication] openURL:urlBrowser];
    }
    
}



-(IBAction)goToTwitter:(id)sender{
    
    NSURL *urlApp = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@",[[Configuration shared] getProperty:@"twitter"]]];
    
    if([[UIApplication sharedApplication] canOpenURL:urlApp]){
        [[UIApplication sharedApplication] openURL:urlApp];
    } else {
        NSURL *urlBrowser = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@",[[Configuration shared] getProperty:@"twitter"]]];
        [[UIApplication sharedApplication] openURL:urlBrowser];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result){
        case MFMailComposeResultSent:
            
            [self becomeFirstResponder];
            [self dismissViewControllerAnimated:YES completion:^{
                //
                APP_ALERT_DIALOG(LSSTRING(@"mail_success_text"));
            }];
            
            
            
            break;
        case MFMailComposeResultFailed:
            
            APP_ALERT_DIALOG(LSSTRING(@"mail_error_text"));
            
            break;
        default:
            [self becomeFirstResponder];
            [self dismissViewControllerAnimated:YES completion:^{
                //
            }];
            break;
    }

}

-(void)changeBadge{
    
    [self setupNavigationBar];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGRect viewFrame = [[self view] frame];
    float height = MAX(568, viewFrame.size.height) - 64;
    [[self contentView] setFrame:CGRectMake(0, 0, viewFrame.size.width, height)];
    [[self scrollView] setContentSize:CGSizeMake(viewFrame.size.width, height)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadge) name:@"incomingNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNavigationBar) name:@"rangingBeacons" object:nil];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
