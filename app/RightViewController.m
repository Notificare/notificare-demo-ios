//
//  RightViewController.m
//  app
//
//  Created by Joel Oliveira on 16/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "RightViewController.h"
#import "AppDelegate.h"
#import "BeaconCell.h"
#import "EmptyBeaconsCell.h"
#import "NotificareBeacon.h"
#import "NotificarePushLib.h"

@interface RightViewController ()

@end

@implementation RightViewController



- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NotificarePushLib *)notificare {
    return (NotificarePushLib *)[[self appDelegate] notificarePushLib];
}


#pragma mark - Table delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return ([[self navSections] count] == 0) ? 1 : [[self navSections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ([[self navSections] count] == 0) ? 1 : [[[self navSections] objectAtIndex:section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if([[self navSections] count] == 0){
        
        static NSString* cellType = @"EmptyBeaconsCell";
        EmptyBeaconsCell * cell = (EmptyBeaconsCell *)[tableView dequeueReusableCellWithIdentifier:cellType];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellType owner:nil options:nil];
            cell = (EmptyBeaconsCell*)[nib objectAtIndex:0];
        }
        
        
        UILabel * label = (UILabel *)[cell viewWithTag:100];
        
        NSString * version = [[UIDevice currentDevice] systemVersion];
        if([version floatValue] >= 7.0f) {//for iOS7
            [label setText:LSSTRING(@"empty_beacons_text")];
        } else{
            [label setText:LSSTRING(@"no_support_beacons_text")];
            [label setTextAlignment:NSTextAlignmentLeft];
            
        }
        
        
        [label setFont:LATO_LIGHT_FONT(14)];
        [label setTextColor:MAIN_COLOR];
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    } else {
        
        static NSString* cellType = @"BeaconCell";
        BeaconCell * cell = (BeaconCell *)[tableView dequeueReusableCellWithIdentifier:cellType];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellType owner:nil options:nil];
            cell = (BeaconCell*)[nib objectAtIndex:0];
        }
        
        
        if([self navSections] &&
           [[self navSections] count] > 0 &&
           [[self navSections] objectAtIndex:[indexPath section]] &&
           [[[self navSections] objectAtIndex:[indexPath section]] count] > 0 &&
           [[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] &&
           [[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] isKindOfClass:[NotificareBeacon class]]){
            
            NotificareBeacon * item = (NotificareBeacon *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
            
            
            UILabel * name = (UILabel *)[cell viewWithTag:100];
            [name setText:[item name]];
            [name setFont:LATO_FONT(20)];
            
            UILabel * message = (UILabel *)[cell viewWithTag:101];
            [message setFont:LATO_HAIRLINE_FONT(16)];
            
            
            if(![[item notification] isKindOfClass:[NSNull class]] && [[item notification] objectForKey:@"message"]){
                [message setText:[[item notification] objectForKey:@"message"]];
            } else {
                [message setText:[item purpose]];
            }
            
            UIImageView * signal = (UIImageView *)[cell viewWithTag:102];
            
            if([[item beacon] proximity] == CLProximityImmediate){
                [signal setImage:[UIImage imageNamed:@"SignalImmediate"]];
            } else if ([[item beacon] proximity] == CLProximityNear) {
                [signal setImage:[UIImage imageNamed:@"SignalNear"]];
            } else if ([[item beacon] proximity] == CLProximityFar) {
                [signal setImage:[UIImage imageNamed:@"SignalFar"]];
            } else {
                [signal setImage:[UIImage imageNamed:@"SignalUnkown"]];
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ([[self navSections] count] == 0) ? self.view.frame.size.height - BEACON_HEADER_HEIGHT : BEACON_CELLHEIGHT;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return BEACON_HEADER_HEIGHT;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BEACON_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, self.view.frame.size.width - 50, BEACON_HEADER_HEIGHT)];
    [label setText:[[self sectionTitles] objectAtIndex:section]];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:LATO_FONT(14)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    [headerView addSubview:label];
    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionTitles] objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if([[self navSections] count] > 0){
        
        NotificareBeacon * item = (NotificareBeacon *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];

        if(![[item notification] isKindOfClass:[NSNull class]]){
            [[self notificare] openNotificareBeacon:item];
            [self showLoadingScreen];
        }

    }
    
}


-(void)showLoadingScreen {
    [[self view] addSubview:[self loadingScreen]];
}

-(void)hideLoadingScreen {
    [[self loadingScreen] removeFromSuperview];
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
    [self setNavSections:[NSMutableArray array]];
    [self setSectionTitles:[NSMutableArray array]];
    
    [[self sectionTitles] addObject:LSSTRING(@"title_list_beacons")];

    [[self tableView] reloadData];
    
    [self setLoadingScreen:[[UIView alloc] initWithFrame:CGRectMake(0 , 0 , [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    

    

}

-(void)reloadBeacons {
    if([[[self appDelegate] beacons] count] > 0){
        [[self navSections] removeAllObjects];
        [[self navSections] addObject:[[self appDelegate] beacons]];
        [[self tableView] reloadData];
    } else {
        [[self navSections] removeAllObjects];
        [[self tableView] reloadData];
    }
}

- (NSTimer*)createTimer {
    
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadBeacons) userInfo:nil repeats:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTimer:[self createTimer]];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoadingScreen) name:@"closedNotification" object:nil];
    
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    [indicator setHidden:YES];
    [indicator setCenter:CGPointMake( [[UIScreen mainScreen] bounds].size.width /2-5, [[UIScreen mainScreen] bounds].size.height /2-5)];
    [indicator  setContentMode:UIViewContentModeCenter];
    
    [[self loadingScreen] addSubview:indicator];
}



-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[self timer] invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"closedNotification"
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
