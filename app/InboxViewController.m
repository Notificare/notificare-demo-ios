//
//  InboxViewController.m
//  app
//
//  Created by Joel Oliveira on 21/01/16.
//  Copyright © 2016 Notificare. All rights reserved.
//

#import "InboxViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "Configuration.h"
#import "InboxCell.h"
#import "NotificareProduct.h"
#import "NSDate+TimeAgo.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

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
    
    [[self sectionTitles] addObject:LSSTRING(@"menu_item_inbox")];
    
    [[NotificarePushLib shared] fetchInbox:nil skip:nil limit:nil completionHandler:^(NSDictionary *info) {
        
        if([[info objectForKey:@"inbox"] count] == 0){
            [[self navSections] addObject:@[]];
        } else {
            [[self navSections] addObject:[info objectForKey:@"inbox"]];
            [[self loadingView] removeFromSuperview];
        }
        
        [[self tableView] reloadData];
        [self setupNavigationBar];
    } errorHandler:^(NSError *error) {
        [[self navSections] addObject:@[]];
        [[self tableView] reloadData];
    }];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:LSSTRING(@"menu_item_inbox")];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
    
    [self showEmptyView];
    
    
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

-(void)showEmptyView{
    [self setLoadingView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    
    [self setEmptyMessage:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    
    [[self emptyMessage] setText:LSSTRING(@"empty_inbox_text")];
    [[self emptyMessage] setFont:LATO_LIGHT_FONT(14)];
    [[self emptyMessage] setTextAlignment:NSTextAlignmentCenter];
    [[self loadingView] setBackgroundColor:[UIColor whiteColor]];
    [[self loadingView] addSubview:[self emptyMessage]];
    [[self view] addSubview:[self loadingView]];
}


-(void)setupNavigationBar{
    
    int count = [[NotificarePushLib shared] myBadge];
    
    
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
        
        
        [[self navigationItem] setRightBarButtonItem:self.editButtonItem];
        [[self editButtonItem] setTintColor:ICONS_COLOR];
    } else {
        
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenuIcon"] style:UIBarButtonItemStylePlain target:[self viewDeckController] action:@selector(toggleLeftView)];
        [leftButton setTintColor:ICONS_COLOR];
        [[self navigationItem] setLeftBarButtonItem:leftButton];
        
        [[self navigationItem] setRightBarButtonItem:nil];
        
    }
    
    
    
}

-(void)clearInbox{
    
    [[NotificarePushLib shared] clearInbox:^(NSDictionary *info) {
        
        [self showEmptyView];
        [self reloadData];
        
    } errorHandler:^(NSError *error) {
        
    }];
    
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
    
    static NSString* cellType = @"InboxCell";
    InboxCell * cell = (InboxCell *)[tableView dequeueReusableCellWithIdentifier:cellType];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellType owner:nil options:nil];
        cell = (InboxCell*)[nib objectAtIndex:0];
    }
    
    
    NotificareDeviceInbox * item = (NotificareDeviceInbox *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    UILabel * label = (UILabel *)[cell viewWithTag:100];
    [label setText:[item message]];
    [label setFont:LATO_LIGHT_FONT(14)];
    
    [label setNumberOfLines:4];
    
    NSArray* arrayDate = [[item time] componentsSeparatedByString: @"."];
    NSString* dateString = [arrayDate objectAtIndex: 0];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate * time = [dateFormat dateFromString:dateString];
    
    UILabel * date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width /2, 30)];
    [date setText:[time timeAgo]];
    [date setTextAlignment:NSTextAlignmentRight];
    [date setFont:LATO_LIGHT_FONT(11)];
    [cell setAccessoryView:date];
    
    if([item opened]){
        [label setTextColor:[UIColor grayColor]];
        [date setTextColor:[UIColor grayColor]];
    } else {
        [label setTextColor:[UIColor blackColor]];
        [date setTextColor:[UIColor blackColor]];
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return INBOX_CELLHEIGHT;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificareDeviceInbox * item = (NotificareDeviceInbox *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    [[self notificare] openInboxItem:item];
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [[self tableView] setEditing:editing animated:YES];
    
    if(editing){
        UIBarButtonItem * clearButton = [[UIBarButtonItem alloc] initWithTitle:LSSTRING(@"clear_all") style:UIBarButtonItemStylePlain target:self action:@selector(clearInbox)];
        [[self navigationItem] setLeftBarButtonItem:clearButton];
        [clearButton setTintColor:ICONS_COLOR];
    } else {
        
        [self setupNavigationBar];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NotificareDeviceInbox * item = (NotificareDeviceInbox *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        
        
        [[NotificarePushLib shared] removeFromInbox:item completionHandler:^(NSDictionary *info) {
            //
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[[self navSections] objectAtIndex:0] removeObject:item];
            [tableView endUpdates];
            
        } errorHandler:^(NSError *error) {
            //
        }];
        
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"incomingNotification" object:nil];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"incomingNotification"
                                                  object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
