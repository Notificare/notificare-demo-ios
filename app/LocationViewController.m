//
//  LocationViewController.m
//  app
//
//  Created by Joel Oliveira on 19/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import "LocationViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "Configuration.h"
#import "RegionsMarker.h"

#define MAP_PADDING 20

@interface LocationViewController ()

@end


@implementation LocationViewController



- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    
    [[self navigationItem] setTitleView:[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Logo"]]];
    
    [self setupNavigationBar];
    
    
    [[self mapView] setDelegate:self];
    [[self mapView] setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    [[self mapView] setShowsUserLocation:YES];
    [[self mapView] setMapType:MKMapTypeStandard];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
        [[[self navigationController] navigationBar] setTintColor:MAIN_COLOR];
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        
    } else {
        
        [[self mapView] setShowsPointsOfInterest:YES];
        [[self mapView] setShowsBuildings:NO];
        
        [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateMap) name:@"gotRegions" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadge) name:@"incomingNotification" object:nil];
}


-(void)setupNavigationBar{
    int count = [[[self appDelegate] notificarePushLib] myBadge];
 
    if(count > 0){
        [[self buttonIcon] setTintColor:[UIColor whiteColor]];
        [[self badgeButton] addTarget:[self viewDeckController] action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        NSString * badge = [NSString stringWithFormat:@"%i", count];
        [[self badgeNr] setText:badge];
        
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:[self badge]];
        [leftButton setTarget:[self viewDeckController]];
        [leftButton setAction:@selector(toggleLeftView)];
        [leftButton setTintColor:[UIColor blackColor]];
        [[self navigationItem] setLeftBarButtonItem:leftButton];
    } else {
        
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenuIcon"] style:UIBarButtonItemStylePlain target:[self viewDeckController] action:@selector(toggleLeftView)];
        
        [leftButton setTintColor:[UIColor blackColor]];
        [[self navigationItem] setLeftBarButtonItem:leftButton];
    }
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RightMenuIcon"] style:UIBarButtonItemStylePlain target:[self viewDeckController] action:@selector(toggleRightView)];
    
    
    [rightButton setTintColor:[UIColor blackColor]];
    
   
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
}

-(void)changeBadge{
    
    [self setupNavigationBar];
    
}

    

-(void)populateMap{
    
    NSMutableArray * markers = [NSMutableArray array];
    
    for (NSDictionary * region in [[self appDelegate] regions]) {
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[[[region objectForKey:@"geometry"] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
        coordinate.longitude = [[[[region objectForKey:@"geometry"] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
        
        RegionsMarker *annotation = [[RegionsMarker alloc] initWithName:[region objectForKey:@"name"] address:@"" coordinate:coordinate] ;
        
        [markers addObject:annotation];
        
    }
    
    [[self mapView] addAnnotations:markers];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    
    static NSString *identifier = @"RegionsMarker";
    
    MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
    }
    
    [annotationView setEnabled:YES];
    [annotationView setCanShowCallout:YES];
    [annotationView setImage:(annotation == [mapView userLocation]) ? [UIImage imageNamed:@"MapUserMarker"] : [UIImage imageNamed:@"MapMarker"]];

    [annotationView setAnnotation:annotation];
    [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    
    [self setRegion:mapView];
    
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    //[[self mapView] setCenterCoordinate:userLocation.location.coordinate];
}

- (void)setRegion:(MKMapView *)mapView{
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate([annotation coordinate]);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    
    [mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(MAP_PADDING, MAP_PADDING, MAP_PADDING, MAP_PADDING) animated:YES];
    
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if([view annotation] != [mapView userLocation]){
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[view annotation] coordinate].latitude,[[view annotation] coordinate].longitude);
        
        //create MKMapItem out of coordinates
        MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
        
        if (destination && [destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)]){
            
            //iOS 6
            [destination setName:[[view annotation] title]];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, destination, nil]
                           launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                     forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
            
            
            [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeDriving:MKLaunchOptionsDirectionsModeKey}];
            
        } else{
            
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
                
                NSString* url = [NSString stringWithFormat: @"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=transit",[[mapView userLocation] coordinate].latitude,[[mapView userLocation] coordinate].longitude,[[view annotation] coordinate].latitude,[[view annotation] coordinate].longitude];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
                
            }else{
                //using iOS 5 which has the Google Maps application
                NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",[[mapView userLocation] coordinate].latitude,[[mapView userLocation] coordinate].longitude,[[view annotation] coordinate].latitude,[[view annotation] coordinate].longitude];
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
            }
            
        }
    }
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self populateMap];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
