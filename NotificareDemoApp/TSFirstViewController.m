//
//  TSFirstViewController.m
//  NotificareDemoApp
//
//  Created by Joel Oliveira on 3/22/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import "TSFirstViewController.h"

@interface TSFirstViewController ()

@end

@implementation TSFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    [self setTweets:[[NSMutableArray alloc] init]];
    
    [self setTwitterEngine:[[TwitterEngine alloc] initWithHostName:@"search.twitter.com" customHeaderFields:nil]];
    
//    [[self twitterEngine] getTweets:@"/search.json?q=%40notificare" completionHandler:^(NSDictionary* info){
//        
//        for (NSDictionary* tweet in [info objectForKey:@"results"]) {
//            [[self tweets] addObject:tweet];
//            
//        }
//        
//        [[self tableView] reloadData];
//        
//    }errorHandler:^(NSError* error){
//        
//        NSLog(@"ERROR FETCHING TWEETS");
//        
//    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return [[self tweets] count];
    
}


// Create the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    /*
     *   If the cell is nil it means no cell was available for reuse and that we should
     *   create a new one.
     */
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    /*
     *   Now that we have a cell we can configure it to display the data corresponding to
     *   this row/section
     */
    
    cell.textLabel.text = [[[self tweets] objectAtIndex:indexPath.row] objectForKey:@"from_user"];
    cell.detailTextLabel.text = [[[self tweets] objectAtIndex:indexPath.row] objectForKey:@"text"];
    
    
    /* Now that the cell is configured we return it to the table view so that it can display it */
    
    return cell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
