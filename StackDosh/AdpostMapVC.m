//
//  AdpostMapVC.m
//  StackDosh
//
//  Created by Surender on 20/05/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "AdpostMapVC.h"

BOOL isGPSEnable;
BOOL isStartDateSelected, isLocationGot;


@interface AdpostMapVC ()

@end

@implementation AdpostMapVC
@synthesize labelMapLocation,mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    
    locationManager.delegate = self;
    mapView.showsUserLocation = YES;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
}

- (IBAction)TappedOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LocationDetailArray"])
    {
        NSString *latString,*longString;
        latString = [[NSString alloc] init];
        longString = [[NSString alloc] init];
        searchLocationArray = [[NSMutableArray alloc] init];
        searchLocationArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"LocationDetailArray"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"LocationDetailArray"];
        
        // update location name on label and move map to this location
        
        labelMapLocation.text = [NSString stringWithFormat:@"%@",[[searchLocationArray valueForKey:@"addressName"] objectAtIndex:0]];
        
        latString = [NSString stringWithFormat:@"%f",[[[searchLocationArray valueForKey:@"latitude"] objectAtIndex:0] floatValue]];
        longString = [NSString stringWithFormat:@"%f",[[[searchLocationArray valueForKey:@"longitude"] objectAtIndex:0] floatValue]];
        
        latitude = [latString floatValue];
        longitude = [longString floatValue];
        
        [self setMapToCenter];
    }
    [mapView setNeedsDisplay];
    isGPSEnable = [CLLocationManager locationServicesEnabled];
    if (isGPSEnable == 1)
    {
    }
    else
    {
        UIAlertView *GPSAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Pay Us!" message:@"You GPS is not enabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [GPSAlert show];
    }
}

#pragma mark --Location Manager Delegate--
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Unable to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    latitude = newLocation.coordinate.latitude;
    longitude = newLocation.coordinate.longitude;
    
    NSLog(@"Latitude :  %f", newLocation.coordinate.latitude);
    NSLog(@"Longitude :  %f", newLocation.coordinate.longitude);
    
    if (isLocationGot == FALSE)
    {
        isLocationGot = TRUE;
        [self setMapToCenter];
        [self getAddressFromLatLong :latitude :longitude];
    }
}

#pragma --Address get From google api--
- (void)getAddressFromLatLong :(float)lati :(float)longi
{
    NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true_or_false",lati,longi]];
    NSString *str = [NSString stringWithFormat:@""];
    
    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urli];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data)
    {
        json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    
    NSLog(@"%@",response);
    
    if (json != nil)
    {
        NSArray *jsonResultArray = [json valueForKey:@"results"];
        NSString *addressString = [[NSString alloc] init];
        
        if ([jsonResultArray count] != 0)
        {
            addressString = [[jsonResultArray valueForKey:@"formatted_address"] objectAtIndex:0];
    
            NSString *Post_Code=[[[[jsonResultArray valueForKey:@"address_components"]objectAtIndex:0]lastObject]valueForKey:@"long_name"];
            
            [[NSUserDefaults standardUserDefaults]setObject:Post_Code forKey:@"Location_postCode"];
            
            labelMapLocation.text = [NSString stringWithFormat:@"%@",addressString];
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"willAnimated");}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    [self performSelectorInBackground:@selector(GetAddressFromLatiLong) withObject:nil];
}

- (void)GetAddressFromLatiLong
{
    latitude = mapView.centerCoordinate.latitude;
    longitude = mapView.centerCoordinate.longitude;
    
    NSLog(@"%f,---%f---",latitude,longitude);
    [self getAddressFromLatLong :latitude :longitude];
}

- (void)setMapToCenter
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000);
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    region.span = span;
    region.center = coordinate;
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
}

#pragma --sumbit Action--
- (IBAction)TappedOnSubmit:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
