//
//  RegionsMarker.h
//  app
//
//  Created by Joel Oliveira on 19/04/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface RegionsMarker : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
