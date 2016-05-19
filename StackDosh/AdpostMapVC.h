//
//  AdpostMapVC.h
//  StackDosh
//
//  Created by Surender on 20/05/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface AdpostMapVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation,UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *location;
    NSMutableArray *searchLocationArray;
    BOOL isDestination;
    float latitude,longitude;
    NSJSONSerialization *json;
    BOOL Location;

}

- (IBAction)TappedOnSubmit:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *labelMapLocation;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
