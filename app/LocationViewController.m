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
#import "NotificarePushLib.h"

#define MAP_PADDING 20

@interface LocationViewController ()

@end


@implementation LocationViewController



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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:LSSTRING(@"title_locations")];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
    
    
    [self setupNavigationBar];
    
    
    [[self mapView] setDelegate:self];
    
    if([[self notificare] checkLocationUpdates]){
        [[self mapView] setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
        [[self mapView] setShowsUserLocation:YES];
    }

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

-(void)populateMap{
    
    [[self mapView] removeOverlays:[self circles]];
    [[self mapView] removeAnnotations:[self markers]];
    
    NSMutableArray * markers = [NSMutableArray array];
    NSMutableArray * regions = [NSMutableArray array];
    
    NSLog(@"Regions %li regions", (unsigned long)[[[[self notificare] locationManager] monitoredRegions] count]);
    
    for (CLRegion * region in [[[self notificare] locationManager] monitoredRegions]) {

        RegionsMarker *annotation = [[RegionsMarker alloc] initWithName:[region identifier] address:@"" coordinate:[region center]] ;
        [markers addObject:annotation];
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:[region center] radius:[region radius]];
        [regions addObject:circle];
        
        
    }
    
    
    [self setCircles:regions];
    [self setMarkers:markers];
    [[self mapView] addOverlays:regions];
    [[self mapView] addAnnotations:markers];
    //[self setRegion:[self mapView]];
    
    
 
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    
    static NSString *identifier = @"RegionsMarker";
    
    MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
    }
    
    [annotationView setEnabled:YES];
    [annotationView setCanShowCallout:YES];
    [annotationView setImage:(annotation == [mapView userLocation]) ? [UIImage imageNamed:@"MapUserMarker"] : nil];

    [annotationView setAnnotation:annotation];
    [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    
    return annotationView;
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    [circleView setFillColor:MAIN_COLOR];
    [circleView setStrokeColor:[UIColor clearColor]];
    [circleView setAlpha:0.5f];
    return circleView;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

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
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateMap) name:@"gotRegions" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadge) name:@"incomingNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNavigationBar) name:@"rangingBeacons" object:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"gotRegions"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"incomingNotification"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"rangingBeacons"
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
