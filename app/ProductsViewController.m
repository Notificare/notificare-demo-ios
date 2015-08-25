//
//  ProductsViewController.m
//  app
//
//  Created by Joel Oliveira on 18/10/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "ProductsViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "Configuration.h"
#import "ProductCell.h"
#import "NotificareProduct.h"
#import "EmptyBeaconsCell.h"

@interface ProductsViewController ()

@end

@implementation ProductsViewController

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
    
    [[self sectionTitles] addObject:LSSTRING(@"title_section_products")];
    
    [[self notificare] fetchProducts:^(NSArray *info) {
        
        if([info count] > 0){
            [[self navSections] addObject:info];
            [[self tableView] reloadData];
            [[self loadingView] removeFromSuperview];
        }

    } errorHandler:^(NSError *error) {
        //
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:LSSTRING(@"title_products")];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
    
    [self setLoadingView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    
    [self setEmptyMessage:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    
    [[self emptyMessage] setText:LSSTRING(@"empty_products_text")];
    [[self emptyMessage] setFont:LATO_LIGHT_FONT(14)];
    [[self emptyMessage] setTextAlignment:NSTextAlignmentCenter];
    [[self loadingView] setBackgroundColor:[UIColor whiteColor]];
    [[self loadingView] addSubview:[self emptyMessage]];
    [[self view] addSubview:[self loadingView]];
    
    
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
        
        [label setText:LSSTRING(@"empty_products_text")];
        
        [label setFont:MONTSERRAT_BOLD_FONT(14)];
        [label setTextColor:[UIColor grayColor]];
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    } else {
    
        static NSString* cellType = @"ProductCell";
        ProductCell * cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:cellType];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellType owner:nil options:nil];
            cell = (ProductCell*)[nib objectAtIndex:0];
        }
        
        NotificareProduct * item = (NotificareProduct *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        
        
        UILabel * label = (UILabel *)[cell viewWithTag:100];
        UILabel * description = (UILabel *)[cell viewWithTag:101];
        UILabel * price = (UILabel *)[cell viewWithTag:102];
        UILabel * type = (UILabel *)[cell viewWithTag:103];
        UIProgressView * progress = (UIProgressView *)[cell viewWithTag:104];
        
        [label setText:[item productName]];
        [label setFont:LATO_FONT(20)];
        
        [description setText:[item productDescription]];
        [description setFont:LATO_LIGHT_FONT(13)];
        [description setNumberOfLines:3];
        
        
        
        if([[item type] isEqualToString:@"consumable"]){
            [type setText:LSSTRING(@"Buy")];
            [type setFont:LATO_FONT(14)];
            [price setText:[item priceLocale]];
            [price setFont:LATO_LIGHT_FONT(12)];
            [progress setHidden:YES];
            
        } else {

            if(![[[self notificare] purchasedProducts] containsObject:[item identifier]]){
                [type setText:LSSTRING(@"Buy")];
                [type setFont:LATO_FONT(14)];
                [price setText:[item priceLocale]];
                [price setFont:LATO_LIGHT_FONT(12)];
                [progress setHidden:YES];
                
                if([[item downloads] count] > 0){
                    for (SKDownload * download in [item downloads]) {
                        if([download downloadState] == SKDownloadStateFinished){
                            [type setHidden:YES];
                            [price setHidden:YES];
                            [progress setHidden:YES];
                            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                        } else {
                            [type setHidden:YES];
                            [price setHidden:YES];
                            [progress setHidden:NO];
                            [progress setProgress:[download progress]];
                            
                        }
                    }
                }
                
            } else {
                [type setHidden:YES];
                [price setHidden:YES];
                [progress setHidden:YES];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }

            
        }
    
    
        
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return PRODUCT_CELLHEIGHT;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return PRODUCT_HEADER_HEIGHT;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, PRODUCT_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width -20 , PRODUCT_HEADER_HEIGHT)];
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
    
    NotificareProduct * item = (NotificareProduct *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    if(![[[self notificare] purchasedProducts] containsObject:[item identifier]]){
        [[self notificare] buyProduct:item];
    } else {
        
        ///The item was purchased show all the content for this purchase
        //You can also get the hosted content for this product if you set one in iTunes
        //If you don't use it this should be the moment where you make the product available to your user
        [self getProductDownloadedContent:item];

    }

}

-(void)getProductDownloadedContent:(NotificareProduct *)product{
    NSString * dir = [[self notificare] contentPathForProduct:[product identifier]];
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];

    NSLog(@"%@", directoryContents);
    if(error){
        APP_ALERT_DIALOG(LSSTRING(@"disabled_for_demo_in_app_purchases"));
        
    } else {
        for (NSString *file in directoryContents) {
            //For demo let's just get one
            [[self productImage] setImage:[UIImage imageWithContentsOfFile:[dir stringByAppendingPathComponent:file]]];
            [[self view] addSubview:[self productView]];
            break;
        }
    }
    
    
}

-(IBAction)closeProductView:(id)sender{
    [[self productView] removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadge) name:@"incomingNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadProducts" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNavigationBar) name:@"rangingBeacons" object:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"reloadProducts"
                                                  object:nil];
    
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
