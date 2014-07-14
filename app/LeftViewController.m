//
//  LeftViewController.m
//  app
//
//  Created by Joel Oliveira on 16/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "DefaultCell.h"
#import "Configuration.h"
#import "NotificarePushLib.h"
#import "IIViewDeckController.h"


@interface LeftViewController ()

@end

@implementation LeftViewController



- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NotificarePushLib *)notificare {
    return (NotificarePushLib *)[[self appDelegate] notificarePushLib];
}



#pragma mark - Table delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self navSections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[self navSections] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* cellType = @"DefaultCell";
    DefaultCell * cell = (DefaultCell *)[tableView dequeueReusableCellWithIdentifier:cellType];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellType owner:nil options:nil];
        cell = (DefaultCell*)[nib objectAtIndex:0];
    }
    
    NSDictionary * item = (NSDictionary *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    
    UILabel * label = (UILabel *)[cell viewWithTag:100];
    UILabel * badge = (UILabel *)[cell viewWithTag:101];
    
    [label setText:LSSTRING([item objectForKey:@"label"])];
    [label setFont:DEFAULT_SYSTEM_FONT(18)];
    
    if([item objectForKey:@"badge"]){
        [badge setText:[item objectForKey:@"badge"]];
        [badge setFont:DEFAULT_SYSTEM_FONT(16)];
    } else {
        [badge setHidden:YES];
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return MENU_CELLHEIGHT;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return MENU_HEADER_HEIGHT;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BEACON_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width -20 , BEACON_HEADER_HEIGHT)];
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
    
    [[self appDelegate] handleNavigation:(NSDictionary *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]];
    
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
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"changedAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"incomingNotification" object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)reloadData{
    [self setNavSections:[NSMutableArray array]];
    [self setSectionTitles:[NSMutableArray array]];
    
    [[self sectionTitles] addObject:[NSString stringWithFormat:@"%@ %@", LSSTRING(@"title_welcome"), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]];
    
    NSMutableArray * menuItems = [NSMutableArray array];
    
    NSArray * items = [[Configuration shared] getArray:@"navigation"];
    
    for (NSDictionary * item in items) {
        
        if([[item objectForKey:@"url"] isEqualToString:@"Auth:"]){
            
            if ( [[self notificare] isLoggedIn] ) {
                //
                NSMutableDictionary * theItem = [NSMutableDictionary dictionaryWithDictionary:item];
                [theItem setValue:LSSTRING(@"menu_item_user") forKey:@"label"];
                [menuItems addObject:theItem];
            } else {
                [menuItems addObject:item];
            }
            
        }else if([[item objectForKey:@"url"] isEqualToString:@"IBAction:openInbox"]){
            
            NSMutableDictionary * theItem = [NSMutableDictionary dictionaryWithDictionary:item];
            if([[self notificare] myBadge] > 0){
                [theItem setValue:[NSString stringWithFormat:@"%i", [[self notificare] myBadge]] forKey:@"badge"];
            }
            
            [menuItems addObject:theItem];
            
            
        } else {
            [menuItems addObject:item];
        }
        
    }
    
    [[self navSections] addObject:menuItems];
    [[self tableView] reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
