//
//  TSFirstViewController.m
//  NotificareDemoApp
//
//  Created by Joel Oliveira on 3/22/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import "TSFirstViewController.h"
#import "TSAppDelegate.h"

@interface TSFirstViewController ()

@end

@implementation TSFirstViewController


- (TSAppDelegate *)appDelegate {
    return (TSAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    [self setLog:[[NSMutableArray alloc] init]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadList) name:@"gotData" object:nil];
}

-(void)reloadList{
    [self setLog:[NSMutableArray arrayWithArray:[[self appDelegate] theLog]]];
    [[self tableView] reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return [[self log] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString * location = @"No Location found";
    if([[[self appDelegate] theLocations] count] > 0){
        CLLocation * lastLocation = [[[self appDelegate] theLocations] lastObject];
        location = [NSString stringWithFormat:@"Lat: %f Lng: %f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude];
        
    }
    return location;
};

// Create the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display recipe in the table cell
    NSDictionary * log = [[self log] objectAtIndex:indexPath.row];
    UILabel * titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = [log objectForKey:@"title"];
    
    CLRegion * region = (CLRegion *)[log objectForKey:@"region"];
    UILabel * regionLabel = (UILabel *)[cell viewWithTag:101];
    regionLabel.text = [region identifier];
    
    UILabel * stateLabel = (UILabel *)[cell viewWithTag:102];
    stateLabel.text = [log objectForKey:@"state"];
    
    UILabel * errorLabel = (UILabel *)[cell viewWithTag:103];
    errorLabel.text = [log objectForKey:@"error"];
    
    UILabel * beaconsLabel = (UILabel *)[cell viewWithTag:104];
    beaconsLabel.text = [NSString stringWithFormat:@"%@",[log objectForKey:@"class"]];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[log objectForKey:@"date"]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    
    UILabel * dateLabel = (UILabel *)[cell viewWithTag:105];
    dateLabel.text = dateString;
    
    return cell;
    
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    /*
     *   If the cell is nil it means no cell was available for reuse and that we should
     *   create a new one.
     */
//    if (cell == nil) {
//        
//        /*
//         *   Actually create a new cell (with an identifier so that it can be dequeued).
//         */
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] ;
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//    }
    
    /*
     *   Now that we have a cell we can configure it to display the data corresponding to
     *   this row/section
     */
    
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // Display recipe in the table cell
//    Recipe *recipe = [recipes objectAtIndex:indexPath.row];
//    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
//    recipeImageView.image = [UIImage imageNamed:recipe.imageFile];
//    
//    UILabel *recipeNameLabel = (UILabel *)[cell viewWithTag:101];
//    recipeNameLabel.text = recipe.name;
//    
//    UILabel *recipeDetailLabel = (UILabel *)[cell viewWithTag:102];
//    recipeDetailLabel.text = recipe.detail;
//    
//    return cell;
//    NSArray* splitedText = [[[self log] objectAtIndex:indexPath.row] componentsSeparatedByString: @":"];
//    
//    NSString * title = [splitedText objectAtIndex: 0];
//    NSString * detail = [splitedText objectAtIndex: 1];
//
//    cell.textLabel.text = title;
//    cell.detailTextLabel.text = detail;
    
    
    /* Now that the cell is configured we return it to the table view so that it can display it */
    
    return cell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
