//
//  ViewController.h
//  StackDosh
//
//  Created by Surender Kumar on 02/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"
#import "AdvertismentVc.h"
#import <MapKit/MapKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "EditProfileVC.h"





@interface ViewController : UIViewController<WebServiceDelegate,UIWebViewDelegate,CLLocationManagerDelegate,FBSDKLoginButtonDelegate, UIAlertViewDelegate>
{
    IBOutlet UITextField *txt_email;
    IBOutlet UITextField *txt_password;
    NSString *status;
    AdvertismentVc *adverTismentVC;
    EditProfileVC  *editProfileVC;
    NSString *str_social_id;
    NSString *str_name;
    BOOL fbOpen;
    NSInteger friends_count;
    NSString *location_str;
    NSMutableString *first_name;
    NSMutableString *last_name;

    
    NSMutableString *email1;
    NSMutableString *gender;
    NSMutableString *user_id;
    NSMutableString *imageUrl1;
    BOOL fbsession;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *userImageURL ;
    
    UIAlertView *settingsAlert;
    
    
}
@property(nonatomic,retain)UIWebView *webview;
@property (nonatomic, retain) NSString *accessToken;
@property(nonatomic,retain)UIActivityIndicatorView  *FbActive;
- (IBAction)TappedOnLoginWithFB:(id)sender;
- (IBAction)TappedOnForgotPswd:(id)sender;
- (IBAction)TappedOnLogin:(id)sender;
@end

