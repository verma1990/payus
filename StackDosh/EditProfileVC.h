//
//  EditProfileVC.h
//  StackDosh
//
//  Created by Surender on 23/03/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"
#import <MapKit/MapKit.h>
#import "proxyService.h"
#import "AsyncImageView.h"
#import "Base64.h"
#import "UITextFieldLimit.h"

@interface EditProfileVC : UIViewController<WebServiceDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,WebServiceDelegate,UIAlertViewDelegate>
{
    NSURL *newImageURL;
    IBOutlet UITextField *txt_firstName;
    IBOutlet UITextField *txt_lastName;
    IBOutlet UITextField *txt_gender;
    IBOutlet UITextFieldLimit *txt_location;
    IBOutlet UITextField *txt_friends;
    BOOL imagefrom_Gallery;
    
    IBOutlet UIView *viewGender;
    IBOutlet UITableView *tableViewGender;
    NSMutableArray *Arr_gender;
    IBOutlet UIView *GenderView;
    NSString *gender;
    IBOutlet UIButton *btn_Camera;
    IBOutlet AsyncImageView *imageViewProfile;
    UIImage *obj_imagePick;
    NSData *dataImage;
    NSString *encryptedString;
    IBOutlet UIButton *btn_gender;
    IBOutlet UIButton *btn_female;
    UIImage *img;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CGPoint svos;
    CGRect rc;
    CGPoint pt;
    UIAlertView *messageAlertVw;
    NSString *location;
    
    IBOutlet UIScrollView *scrollVw_Reg;
    
    NSString *str_CurLocPost;

}
- (IBAction)TappedOnCamera:(id)sender;

- (IBAction)TappedOnRegister:(id)sender;
- (IBAction)TappedOnGender:(id)sender;

- (IBAction)TappedOnDOB:(id)sender;
- (IBAction)btnAllClick:(UIButton *)sender;


@end
