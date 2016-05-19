                                                                                                         //
//  AppDelegate.m
//  StackDosh
//
//  Created by Surender Kumar on 02/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "SideMenuViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PayPalMobile.h"
#import "constant.h"
#import "iRate.h"
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Bolts/Bolts.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

NSString *const BFTaskMultipleExceptionsException = @"BFMultipleExceptionsException";

@interface AppDelegate ()
@end

@implementation AppDelegate
@synthesize Arr_profileData,Arr_rePostData,DeviceToken,isPromoCodeApplied;

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 10;
    [iRate sharedInstance].previewMode = NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[FBSDKLoginButton class];
    
    isPromoCodeApplied=NO;
    
    Arr_profileData=[[NSMutableArray alloc]init];
    arr_allPostcode=[[NSMutableArray alloc]init];
    Arr_rePostData =[[NSMutableArray alloc]init];
    
    [Fabric with:@[[Crashlytics class]]];

    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled] ) {
        locationManager.delegate = self;
        
         if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
             //[locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    } else {
        

        [locationManager stopUpdatingLocation];
    }
      //*************
   // [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AQMm4LSIXNEmyDfMfYFlhsUBgy2K2tlGl1NZagIXxZ7BurFLSHW8YGRMI_o5lfVZeVo2rD1VocliO4g_"}];
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AQMm4LSIXNEmyDfMfYFlhsUBgy2K2tlGl1NZagIXxZ7BurFLSHW8YGRMI_o5lfVZeVo2rD1VocliO4g_",
                                                           PayPalEnvironmentSandbox : @"ASjAUV5stf5NMMDeQguPk10fga0XMWlSN98h_k065PSU_yx_htHNibqnjb7XJi8o-WHwWOS1RJcVVK16"}];
    
    
    // [NSThread sleepForTimeInterval:2.0];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    UINavigationController *navigationController2 = [storyboard instantiateViewControllerWithIdentifier:@"Navcontroller2"];
    UIViewController *leftsideMenuView=[storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"login"]==YES)
    {
        container = [MFSideMenuContainerViewController
                     containerWithCenterViewController:navigationController2
                     leftMenuViewController:leftsideMenuView
                     rightMenuViewController:nil];
    }
    else
    {
        container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:navigationController
                                                        leftMenuViewController:leftsideMenuView
                                                        rightMenuViewController:nil];
    }
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    // current version < iOS 8
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }

    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [FBSDKAppEvents activateApp];
    
        return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    DeviceToken=dt;
    NSLog(@"%@",DeviceToken);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
//    //    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//    //     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    
//    
//    
//    
//    //  [chat_obj for_calling];
//    
//    
//    
//    
//    
//    
//    NSLog(@"%@",userInfo);
//    
//    
//    NSString *message=[[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
//    NSString *sound=[[userInfo valueForKey:@"aps"]valueForKey:@"sound"];
//    
//    notify_sender_id=[[userInfo valueForKey:@"aps"]valueForKey:@"sender_id"];
//    
//    
//    
//    
//    NSLog(@"%@",sound);
//    
//    badge=[[userInfo valueForKey:@"aps"]valueForKey:@"badge"];
//    
//    
//    
//    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    if (application.applicationState == UIApplicationStateActive )
//    {
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.userInfo = userInfo;
//        
//        
//        
//        
//        
//        
//        if ([sender_id_for_push_notification isEqualToString:notify_sender_id] || [reciever_id_for_push_notification isEqualToString:notify_sender_id] )
//        {
//            NSLog(@"push notification stops");
//            
//            
//            
//            get_sender_id=@"0";
//            
//        }
//        else
//        {
//            AudioServicesPlaySystemSound(1002);
//            
//            
//            
//            localNotification.soundName = UILocalNotificationDefaultSoundName;
//            localNotification.alertBody = message;
//            localNotification.fireDate = [NSDate date];
//            
//        }
//        
//        
//        
//        
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//        
//        //        [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//    }
    
    
    
}




- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if([[url scheme] caseInsensitiveCompare:@"PayUs"] == NSOrderedSame)
    {
        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        
        return YES;
    }
    else {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation
                        ];
        
        if (handled) {
            return handled;
        } else
            return YES;
    }
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"login"];
//    [[NSUserDefaults standardUserDefaults]synchronize];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough 0app0lic0a0tion state i0nf0ormation to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[FBAppCall handleDidBecomeActive];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"login"];
   // [[NSUserDefaults standardUserDefaults]synchronize];
       // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
