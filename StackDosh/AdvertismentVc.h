//
//  AdvertismentVc.h
//  StackDosh
//
//  Created by Surender Kumar on 03/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"
#import "DetailVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



@interface AdvertismentVc : UIViewController<WebServiceDelegate,FBSDKSharingDelegate, FBSDKAppInviteDialogDelegate>
{
    IBOutlet UITableView *tableView_adver;
    NSMutableArray * arr_Images;
    NSMutableArray *arr_advertList;
    NSInteger index;
    BOOL headingSeleect;
    DetailVC *detailVC;
    BOOL sharePost;
    IBOutlet UIButton *btn_createAd;
    IBOutlet UIImageView *imgCreateAd;
    int shreStatus;
    UIRefreshControl * RefreshControl;
    NSInteger sender_Value,facebook_Friends;
    FBSDKLikeButton *_photoLikeButton;
    UIImage *newAdverImage;
    UIAlertView *myAlertView;
    
    IBOutlet UIButton *btn_camera;
    NSString *earn_str,*str_CurLocPost;
    NSData *dataImage;
    NSString *encryptedString;
    CGPoint svos;
    CGRect rc;
    CGPoint pt;
    
    IBOutlet UIWebView *introWebView;
    
    UIActivityIndicatorView *activityIndicator;
    
    UIAlertView *settingsAlert;
    
    IBOutlet UILabel *sharedMessageLabel;
    
}
+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point;
- (IBAction)TappedOnDrawer:(id)sender;
- (IBAction)TappedOnCreateAd:(id)sender;

- (IBAction)inviteFriends:(id)sender;



@end
