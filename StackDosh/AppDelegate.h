//
//  AppDelegate.h
//  StackDosh
//
//  Created by Surender Kumar on 02/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"
#import "proxyService.h"
#import <MapKit/MapKit.h>

#define kAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])


@interface AppDelegate : UIResponder <UIApplicationDelegate,WebServiceDelegate,CLLocationManagerDelegate>
{
    UIView *sideTabBarView;
     UINavigationController *obj_NavController;
    MFSideMenuContainerViewController *container;
    NSMutableString *location_str;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSMutableArray *arr_allPostcode;
    BOOL isPromoCodeApplied;
    
  
}
@property(strong,nonatomic)NSString *DeviceToken;

@property(strong,nonatomic)NSMutableArray *Arr_profileData;
@property(strong,nonatomic)NSMutableArray *Arr_rePostData;


@property (strong, nonatomic) UIWindow *window;
@property(assign,nonatomic)BOOL isPromoCodeApplied;


@end

