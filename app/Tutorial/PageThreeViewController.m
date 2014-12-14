//
//  PageThreeViewController.m
//  app
//
//  Created by Joel Oliveira on 02/12/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "PageThreeViewController.h"
#import "Configuration.h"

@interface PageThreeViewController ()

@end

@implementation PageThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
