//
//  ViewController.m
//  StackDosh
//
//  Created by Surender Kumar on 02/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "ViewController.h"
#import "constant.h"
#import "proxyService.h"
#import "AdvertismentVc.h"
#import "ForgotPassWordVC.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()
@end
@implementation ViewController
@synthesize webview,accessToken,FbActive;

- (void)viewDidLoad
{
    [super viewDidLoad];
    adverTismentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"advertismentVC"];
    editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];

    
       // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [proxyService sharedProxy].delegate = self;
    
    
    locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] ) {
        locationManager.delegate = self;
        //[[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Get Location.."];
        locationManager.distanceFilter = 500;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    } else if (![CLLocationManager locationServicesEnabled] ) {
        [[proxyService sharedProxy] hideActivityIndicatorInView];
    }
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];

    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       location_str=[NSMutableString stringWithFormat:@"%@",placemark.locality];
                       NSString *str_postCode=[NSString stringWithFormat:@"%@",placemark.postalCode];
                       [[NSUserDefaults standardUserDefaults]setObject:str_postCode forKey:@"postCode"];
                       [[NSUserDefaults standardUserDefaults]setObject:location_str forKey:@"location"];
                       
                   }];
}


-(void)Logout
{
    txt_email.text=@"";
    txt_password.text=@"";
}

#pragma mark --Navigation ForgotPswd Button--
- (IBAction)TappedOnForgotPswd:(id)sender
{
    ForgotPassWordVC *forgotPswdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPswdVC"];
    [self.navigationController pushViewController:forgotPswdVC animated:YES];
    
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==txt_email)
    {
        [self moveUP];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_email)
    {
        [txt_password  becomeFirstResponder];
    }
    else if (textField == txt_password)
    {
        [textField resignFirstResponder];
        [self movedown];
    }
    return YES;
}

#pragma mark  View Animation
-(void)moveUP
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    
    if(IS_IPHONE4)
    {
        self.view.frame=CGRectMake(0, -80, 320, self.view.frame.size.height);
    }
    else if(IS_IPHONE5)
    {
        self.view.frame=CGRectMake(0, -70, 320, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6)
    {
        self.view.frame=CGRectMake(0, -70, 375, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6)
    {
        self.view.frame=CGRectMake(0, -70, 414, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}


-(void)movedown
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    
    if(IS_IPHONE4)
    {
        self.view.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    else if(IS_IPHONE5)
    {
        self.view.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6)
    {
        self.view.frame=CGRectMake(0, 0, 375, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6)
    {
        self.view.frame=CGRectMake(0, 0, 414, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_email resignFirstResponder];
    [txt_password resignFirstResponder];
    [self movedown];
}

#pragma mark --Email Validation--
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark --Facbook Login--
- (IBAction)TappedOnLoginWithFB:(id)sender
{
    
    fbOpen=YES;
    [[NSUserDefaults standardUserDefaults]setBool:fbOpen forKey:@"FBOpen"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior=FBSDKLoginBehaviorSystemAccount;
    login.defaultAudience = FBSDKDefaultAudienceFriends;
    
    [login logOut];
    
    NSArray *permissions = @[@"email",@"public_profile", @"user_friends"];
    
    [login logInWithReadPermissions:permissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error) {
             NSLog(@"There was an error with FB:\n %@",error.description);
         } else if (result.isCancelled) {
             NSLog(@"permissions cancelled");
             login.loginBehavior=FBSDKLoginBehaviorWeb;
             [login logInWithReadPermissions:permissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
              {
                  if (!error){
                      NSLog(@"permissions granted - %@",permissions.description);
                      // Do work
                      [self getFBResult];
                  }
              }];
         } else {
             if ([result.grantedPermissions containsObject:@"user_friends"]) {
                 NSLog(@"permissions granted - %@",permissions.description);
                 // Do work
                 [self getFBResult];
             }else{
                 NSLog(@"permissions NOT granted");
                 settingsAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Facebook is required for you to earn money on Pay Us! Please change your setttings and allow Pay Us on Facebook." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [settingsAlert show];
             }
         }
         
     }];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        NSURL*url=[NSURL URLWithString:@"prefs:root=Facebook"];
        [[UIApplication sharedApplication] openURL:url];
    }else{
        
    }
}

-(void)getFBResult
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name,friends,gender,first_name,last_name, picture.type(large),email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"fb user info : %@",result);
                 NSDictionary *dict =[result objectForKey:@"friends"];
                 NSArray *friends =[dict objectForKey:@"summary"];
                 friends_count=[[friends valueForKey:@"total_count"] integerValue];
                 
                 email1=[result objectForKey:@"email"];
                 first_name=[result objectForKey:@"first_name"];
                 last_name=[result objectForKey:@"last_name"];
                 gender=[result objectForKey:@"gender"];
                 user_id=[result objectForKey:@"id"];
                 
                 
                 [[NSUserDefaults standardUserDefaults]setObject:user_id forKey:@"fb__id"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 
                 userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user_id];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:userImageURL forKey:@"Image"];

                 
                 [[NSUserDefaults standardUserDefaults]setObject:first_name forKey:@"FirstName"];
                 [[NSUserDefaults standardUserDefaults]setObject:last_name forKey:@"LastNmae"];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:gender forKey:@"gender"];
                 [[NSUserDefaults standardUserDefaults]setObject:user_id forKey:@"user_id"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 
                 NSString *aValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
                 NSLog(@"Value from user_id: %@", aValue);
                 
                 [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Authenticating.."];
                 location_str=[[NSUserDefaults standardUserDefaults]objectForKey:@"location"];
                 
                 [proxyService sharedProxy].delegate=self;
                 BOOL checkNet = [[proxyService sharedProxy] checkReachability];
                 if(checkNet == TRUE)
                 {
                     NSMutableString *postData= [NSMutableString stringWithFormat:@"firstname=%@&lastname=%@&email=%@&usertype=user&gender=%@&image=%@&registertype=facebook&fb_id=%@&location=%@&fb_friend=%ld&token=%@",first_name,last_name,email1,gender,userImageURL,user_id,location_str,(long)friends_count,KAppDelegate.DeviceToken];
                     
                     [[proxyService sharedProxy] postDataonServer:kSignUpUser withPostString:postData];
                 }
                 else
                 {
                     [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                 }
                 
             }
             else
             {
                 [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Something went wrong." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
             }
         }];
    }
    
}

#pragma mark --Manual Login--
- (IBAction)TappedOnLogin:(id)sender
{
    fbOpen=NO;
    [[NSUserDefaults standardUserDefaults]setBool:fbOpen forKey:@"FBOpen"];
    if([txt_email.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Email cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if([txt_password.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Password cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if (![self validateEmailWithString:txt_email.text])
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter valid email id." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else
    {
        BOOL checkNet = [[proxyService sharedProxy] checkReachability];
        if(checkNet == TRUE)
        {
            NSString *postData= [NSString stringWithFormat:@"username=%@&password=%@",txt_email.text,txt_password.text];
            NSString *str_postData=[NSString stringWithFormat:@"%@%@",kLoginUser,postData];
            
            [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Authenticating.."];
            [[proxyService sharedProxy] postDataonServer:str_postData withPostString:@""];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
}

#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    NSLog(@"Response :%@",responseDic);
    
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    NSInteger Status=[[responseDic valueForKey:@"status"] integerValue];
    if(Status ==1)
    {
        
        if ([[responseDic valueForKey:@"post_code"]isEqualToString:@""])
        {

            [[NSUserDefaults standardUserDefaults] setObject:[responseDic valueForKey:@"user_id"] forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController pushViewController:editProfileVC animated:YES];
        }
        else
        {
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] setObject:[responseDic valueForKey:@"status"] forKey:@"status"];
        [[NSUserDefaults standardUserDefaults]setObject:txt_email.text forKey:@"email"];
        status=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"status"]];
        [[NSUserDefaults standardUserDefaults] setObject:[responseDic valueForKey:@"user_id"] forKey:@"UserId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController pushViewController:adverTismentVC animated:YES];
        }
    }
    else if ([[responseDic valueForKey:@"status"] integerValue]==2)
    {
        
        if ([[responseDic valueForKey:@"post_code"]isEqualToString:@""]) {

            [[NSUserDefaults standardUserDefaults] setObject:[responseDic valueForKey:@"user_id"] forKey:@"UserId"];
            [self.navigationController pushViewController:editProfileVC animated:YES];

        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:[responseDic valueForKey:@"user_id"] forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"login"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController pushViewController:adverTismentVC animated:YES];
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:[responseDic valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfileImage" object:nil];
}

-(void)failToGetResponseWithError:(NSError *)error
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)savePaymentData
{
    
    NSString *username = email1;
    float totalearnings = [total floatValue];
    float amountdue = [total floatValue] - [withdrwn floatValue];
    
    NSString *rawStr = [NSString stringWithFormat:@"user_name=%@&total_earnings=%f&already_withdrawn=%f&amountdue=%f",
                        username,
                        totalearnings,
                        [p_already_withdrawn floatValue],
                        amountdue
                        ];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://payusapp.com/resources/savedata.php?"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
    NSLog(@"%@", responseString);
    
    NSString *success = @"success";
    [success dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%lu", (unsigned long)responseString.length);
    NSLog(@"%lu", (unsigned long)success.length);
}*/

@end


