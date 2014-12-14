//
//  UserDetailsOptionsViewController.m
//  app
//
//  Created by Joel Oliveira on 11/10/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "UserDetailsOptionsViewController.h"
#import "SegmentCell.h"

#import "AppDelegate.h"
#import "NotificarePushLib.h"
#import "IIViewDeckController.h"

@interface UserDetailsOptionsViewController ()

@end

@implementation UserDetailsOptionsViewController



- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NotificarePushLib *)notificare {
    return (NotificarePushLib *)[[self appDelegate] notificarePushLib];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitleView];
    
    
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
}

-(void)setTitleView{
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:[[self preference] preferenceLabel]];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavSections:[NSMutableArray array]];
    [self setSectionTitles:[NSMutableArray array]];
    
    [self setTitleView];
    NSMutableArray * segments = [NSMutableArray array];
    for (NotificareSegment * seg in [[self preference] preferenceOptions]) {
        [segments addObject:seg];
    }
    
    [[self navSections] addObject:segments];
    [[self sectionTitles] addObject:LSSTRING([[self preference] preferenceLabel])];
    [[self tableView] reloadData];
}


#pragma mark - Table delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self navSections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[self navSections] objectAtIndex:section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* cellType = @"SegmentCell";
    SegmentCell * cell = (SegmentCell *)[tableView dequeueReusableCellWithIdentifier:cellType];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellType owner:nil options:nil];
        cell = (SegmentCell*)[nib objectAtIndex:0];
    }
    
    NotificareSegment * item = (NotificareSegment *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    
    [[cell textLabel] setText:[item segmentLabel]];
    [[cell textLabel] setFont:LATO_LIGHT_FONT(14)];
    
    if([[[self preference] preferenceType] isEqualToString:@"choice"]){
        
        if([item selected]){
            
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    
    if([[[self preference] preferenceType] isEqualToString:@"select"]){
        
        UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [cell setAccessoryView:mySwitch];
        [mySwitch setTag:(([indexPath section] * 100) + [indexPath row])];
        
        if([item selected]){
            [mySwitch setOn:YES];
        }
        
        [mySwitch addTarget:self action:@selector(OnSegmentsChanged:) forControlEvents:UIControlEventValueChanged];

    }

    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

    
}


-(void)OnSegmentsChanged:(id)sender{
    
    UISwitch *tempSwitch = (UISwitch *)sender;
    NotificareSegment * item = [[[self navSections] objectAtIndex:[tempSwitch tag] / 100] objectAtIndex:[tempSwitch tag] % 100];
    
    if([tempSwitch isOn]){
        
        [[self notificare] addSegment:item toPreference:[self preference] completionHandler:^(NSDictionary *info) {
            //
        } errorHandler:^(NSError *error) {
            //
        }];
        
    }else{

        [[self notificare] removeSegment:item fromPreference:[self preference] completionHandler:^(NSDictionary *info) {
            //
        } errorHandler:^(NSError *error) {
            //
        }];
        
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SEGMENT_CELLHEIGHT;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    

    return 0;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionTitles] objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if([[[self preference] preferenceType] isEqualToString:@"choice"]){
        
        NotificareSegment * item = (NotificareSegment *)[[[self navSections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        
        UITableViewCell * checkCell = [tableView cellForRowAtIndexPath:indexPath];
        
        if([checkCell accessoryType] != UITableViewCellAccessoryCheckmark){

            checkCell.accessoryType = UITableViewCellAccessoryCheckmark;
            [[self notificare] addSegment:item toPreference:[self preference] completionHandler:^(NSDictionary *info) {
                [[self navigationController] popToRootViewControllerAnimated:YES];
            } errorHandler:^(NSError *error) {
                //
            }];
            
        }
        
    }
    
}


-(void)goBack{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
