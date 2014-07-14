//
//  MapViewController.h
//  app
//
//  Created by Joel Oliveira on 19/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BadgeLabel.h"

@interface LocationViewController : UIViewController <MKMapViewDelegate>


@property (nonatomic, strong) IBOutlet MKMapView * mapView;
@property (nonatomic, strong) IBOutlet UIView * badge;
@property (nonatomic, strong) IBOutlet BadgeLabel * badgeNr;
@property (nonatomic, strong) IBOutlet UIButton * badgeButton;
@property (nonatomic, strong) IBOutlet UIImageView * buttonIcon;

@end
