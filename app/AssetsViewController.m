//
//  AssetsViewController.m
//  app
//
//  Created by Joel Oliveira on 28/03/16.
//  Copyright © 2016 Notificare. All rights reserved.
//

#import "AssetsViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "Configuration.h"
#import "AssetCell.h"
#import "NotificareAsset.h"
#import "UIImageView+MKNetworkKitAdditions.h"

@interface AssetsViewController ()

@end

@implementation AssetsViewController

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
    
    [[self sectionTitles] addObject:LSSTRING(@"menu_item_assets")];
    
    [[NotificarePushLib shared] fetchAssets:[self searchTerms] completionHandler:^(NSArray *info) {
        
        if([info count] > 0){
            [[self navSections] removeAllObjects];
            [[self navSections] addObject:info];
            [[self loadingView] removeFromSuperview];
            [[self tableView] reloadData];
        } else {
            [self showEmptyView];
        }
        
        
        
    } errorHandler:^(NSError *error) {
        [[self navSections] removeAllObjects];
        [[self navSections] addObject:@[]];
        [[self tableView] reloadData];
        [self showEmptyView];
    }];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:LSSTRING(@"menu_item_assets")];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
    
    [self showEmptyView];
    [self setNavSections:[NSMutableArray array]];
    [self setSectionTitles:[NSMutableArray array]];
    
    [self setupNavigationBar];
    
    //For iOS6
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[[self navigationController] navigationBar] setTintColor:MAIN_COLOR];
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        
    } else {
        
        [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    }
    
    [UIImageView setDefaultEngine:[[self appDelegate] apiEngine]];
}

-(void)showEmptyView{
    [self setLoadingView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    
    [self setEmptyMessage:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    
    [[self emptyMessage] setText:LSSTRING(@"empty_assets_text")];
    [[self emptyMessage] setFont:LATO_LIGHT_FONT(14)];
    [[self emptyMessage] setTextAlignment:NSTextAlignmentCenter];
    [[self loadingView] setBackgroundColor:[UIColor whiteColor]];
    [[self loadingView] addSubview:[self emptyMessage]];
    [[self view] addSubview:[self loadingView]];
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
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SearchIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(searchGroup)];
    
    [rightButton setTintColor:ICONS_COLOR];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
    
}

-(void)searchGroup{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] message:LSSTRING(@"search_groups_text") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];

    [[av textFieldAtIndex:0] setPlaceholder:LSSTRING(@"type_group_name")];
    [av show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if([alertView cancelButtonIndex] != buttonIndex){
        if([[[alertView textFieldAtIndex:0] text] length] > 0){
            [self setSearchTerms:[[alertView textFieldAtIndex:0] text]];
            [self reloadData];
        } else {
            [self showEmptyView];
        }
    }
    
    
}


#pragma mark - Table delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self navSections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[self navSections] objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellType = @"AssetCell";
    AssetCell * cell = (AssetCell *)[tableView dequeueReusableCellWithIdentifier:cellType];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellType owner:nil options:nil];
        cell = (AssetCell*)[nib objectAtIndex:0];
    }
    
    
    NotificareAsset * item = (NotificareAsset *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    UILabel * label = (UILabel *)[cell viewWithTag:100];
    [label setText:[item assetTitle]];
    [label setFont:LATO_FONT(14)];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:MAIN_COLOR];

    UILabel * description = (UILabel *)[cell viewWithTag:101];
    [description setText:[item assetDescription]];
    [description setFont:LATO_FONT(12)];
    [description setNumberOfLines:4];
    [description setTextColor:[UIColor whiteColor]];
    [description setBackgroundColor:MAIN_COLOR];
    
    
    UIImageView * image = (UIImageView *)[cell viewWithTag:102];
    if([[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"image/jpeg"] ||
       [[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"image/gif"] ||
       [[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"image/png"]){
        
        [image setImageFromURL:[NSURL URLWithString:[item assetUrl]] placeHolderImage:[UIImage imageNamed:@"PlaceholderImage"] animation:YES];
        
    } else if([[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"video/mp4"]){

        [image setImage:[UIImage imageNamed:@"VideoPlaceholder"]];
        
    } else if([[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"application/pdf"]){
        
        [image setImage:[UIImage imageNamed:@"PdfPlaceholder"]];
        
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ASSET_CELLHEIGHT;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NotificareAsset * item = (NotificareAsset *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    if([[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"image/jpeg"] ||
       [[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"image/gif"] ||
       [[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"image/png"]){
        

        
    } else if([[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"video/mp4"]){
        
        
        NSURL * target = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[item assetUrl]]];
        
        if(target && [target scheme] && [target host]){
            [[UIApplication sharedApplication] openURL:target];
        }
        
        
    } else if([[[item assetMetaData] objectForKey:@"contentType"] isEqualToString:@"application/pdf"]){
        
        NSURL * target = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[item assetUrl]]];
        
        if(target && [target scheme] && [target host]){
            [[UIApplication sharedApplication] openURL:target];
        }
        
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNavigationBar) name:@"incomingNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNavigationBar) name:@"rangingBeacons" object:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"incomingNotification"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"rangingBeacons"
                                                  object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
