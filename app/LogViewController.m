//
//  LogViewController.m
//  app
//
//  Created by Joel Oliveira on 12/05/15.
//  Copyright (c) 2015 Notificare. All rights reserved.
//

#import "LogViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "Configuration.h"
#import "LogCell.h"
#import "NotificareProduct.h"

@interface LogViewController ()

@end

@implementation LogViewController

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




-(void)reloadData{
    [self setNavSections:[NSMutableArray array]];
    [self setSectionTitles:[NSMutableArray array]];
    
    [[self sectionTitles] addObject:LSSTRING(@"title_section_log")];
    
    if([[[self appDelegate] log] count] > 0){
        NSArray * reversedArray = [[[[self appDelegate] log] reverseObjectEnumerator] allObjects];
        NSMutableArray * log = [NSMutableArray arrayWithArray:reversedArray];
        [[self navSections] addObject:log];
    } else {
        [[self navSections] addObject:@[]];
    }
   
    [[self tableView] reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:LSSTRING(@"title_log")];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];

    [self setupNavigationBar];
    
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
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMail"] style:UIBarButtonItemStylePlain target:self action:@selector(sendLog)];
    
    [rightButton setTintColor:ICONS_COLOR];
    
    
   [[self navigationItem] setRightBarButtonItem:rightButton];
    
}

-(void)sendLog{
    
    if([MFMailComposeViewController canSendMail]){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
        
        NSMutableString * data = [NSMutableString string];
        NSDictionary * info = [NSDictionary dictionaryWithDictionary:[[self notificare] applicationInfo]];

        [data appendFormat:@"App: %@ (%@)\n",[info objectForKey:@"name"],[info objectForKey:@"_id"]];
        
        [data appendFormat:@"--------------------------------------------------------\n"];
        
        NotificareDevice * device = [[self notificare] myDevice];
        
        [data appendFormat:@"Device: %@\nOS: %@\nSDK: %@\nApp Version: %@\n",[device deviceID],[device osVersion],[device sdkVersion],[device appVersion]];
        
        [data appendFormat:@"--------------------------------------------------------\n"];
        
        for (NSDictionary * entry in [[self appDelegate] log]) {
            //
            for (NSString* key in [entry allKeys]) {
                NSObject* value = [entry objectForKey:key];
                [data appendFormat:@"%@ = %@\n", key, value];
            }
            
            [data appendFormat:@"--------------------------------------------------------\n"];
            [data writeToFile:appFile atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        }
        
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        [composer setToRecipients:@[@"support@notifica.re"]];
        [composer setSubject:LSSTRING(@"text_log_subject")];
        [composer setMessageBody:LSSTRING(@"text_log_body") isHTML:NO];
        NSData *fileData = [NSData dataWithContentsOfFile:appFile];
        [composer addAttachmentData:fileData mimeType:@"text/plain" fileName:@"log"];
        [[self navigationController] presentViewController:composer animated:YES completion:^{

        }];
        
    }
}

-(void)changeBadge{
    
    [self setupNavigationBar];
    
}

#pragma mark - Table delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self navSections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[self navSections] objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellType = @"LogCell";
    LogCell * cell = (LogCell *)[tableView dequeueReusableCellWithIdentifier:cellType];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellType owner:nil options:nil];
        cell = (LogCell*)[nib objectAtIndex:0];
    }
    
    
    NSDictionary * item = (NSDictionary *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    UILabel * label = (UILabel *)[cell viewWithTag:100];
    [label setText:[item objectForKey:@"event"]];
    [label setFont:LATO_LIGHT_FONT(14)];
    [label setTextColor:MAIN_COLOR];
    
    
    UILabel * data = (UILabel *)[cell viewWithTag:101];
    [data setFont:LATO_LIGHT_FONT(12)];
    [data setTextColor:MAIN_COLOR];
    
    if([[item objectForKey:@"data"] isKindOfClass:[NSDictionary class]] && [[item objectForKey:@"data"] objectForKey:@"region"]){
        [data setText:[[item objectForKey:@"data"] objectForKey:@"region"]];
    } else {
        [data setText:@""];
    }

    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM yyyy hh:mma:ss"];
    NSString *dateString = [dateFormat stringFromDate:[item objectForKey:@"date"]];
    

    UILabel * date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width /2, 30)];
    [date setText:dateString];
    [date setTextAlignment:NSTextAlignmentRight];
    [date setTextColor:MAIN_COLOR];
    [date setFont:LATO_LIGHT_FONT(11)];
    [cell setAccessoryView:date];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LOG_CELLHEIGHT;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return LOG_HEADER_HEIGHT;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, LOG_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width -20 , LOG_HEADER_HEIGHT)];
    [label setText:[[[self sectionTitles] objectAtIndex:section] uppercaseString]];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setBackgroundColor:[UIColor clearColor]];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    [headerView addSubview:label];
    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionTitles] objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadge) name:@"incomingNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadLog" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNavigationBar) name:@"rangingBeacons" object:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"reloadLog"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"incomingNotification"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"rangingBeacons"
                                                  object:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    switch (result){
        case MFMailComposeResultCancelled:
            
            
            break;
        case MFMailComposeResultSaved:
            
            
            break;
        case MFMailComposeResultSent:
            APP_ALERT_DIALOG(LSSTRING(@"success_log_sent"));
            
            break;
        case MFMailComposeResultFailed:
          APP_ALERT_DIALOG(LSSTRING(@"error_log_sent"));
            
            break;
        default:
            
            break;
    }
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:^{
        //
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
