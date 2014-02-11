//
//  TSSecondViewController.m
//  NotificareDemoApp
//
//  Created by Joel Oliveira on 3/22/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import "TSSecondViewController.h"
#import "TSAppDelegate.h"

@interface TSSecondViewController ()

@end



@implementation TSSecondViewController

- (TSAppDelegate *)appDelegate {
    return (TSAppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self setBeacons:[[NSMutableArray alloc] init]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadList) name:@"gotBeacons" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBeacons:[NSMutableArray arrayWithArray:[[self appDelegate] theBeacons]]];
    NSLog(@"COUNT: %i",[[self beacons] count]);
    [[self tableView] reloadData];
}

-(void)reloadList{
    [self setBeacons:[NSMutableArray arrayWithArray:[[self appDelegate] theBeacons]]];
    NSLog(@"COUNT: %i",[[self beacons] count]);
    [[self tableView] reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return [[self beacons] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Beacons found:";
};

// Create the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BeaconCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display recipe in the table cell
    CLBeacon * beacon = [[[self beacons] objectAtIndex:indexPath.row] objectForKey:@"beacon"];
    NSDictionary * info = [[[self beacons] objectAtIndex:indexPath.row] objectForKey:@"info"];
    

    UILabel * titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = [NSString stringWithFormat:@"%i",[beacon rssi]];

    UILabel * nameLabel = (UILabel *)[cell viewWithTag:101];
    nameLabel.text = [info objectForKey:@"name"];
    
    UILabel * majorLabel = (UILabel *)[cell viewWithTag:102];
    majorLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"major"]];
    
    UILabel * minorLabel = (UILabel *)[cell viewWithTag:103];
    minorLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"minor"]];
    
    UILabel * messageLabel = (UILabel *)[cell viewWithTag:104];
    messageLabel.text = [[info objectForKey:@"notification"] objectForKey:@"message"];

    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    [[self appDelegate] openNotification:[[[self beacons] objectAtIndex:indexPath.row] objectForKey:@"info"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
