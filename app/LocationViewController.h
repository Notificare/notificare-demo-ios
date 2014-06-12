//
//  MapViewController.h
//  app
//
//  Created by Joel Oliveira on 19/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationViewController : UIViewController <MKMapViewDelegate>


@property (nonatomic, strong) IBOutlet MKMapView * mapView;

@end
