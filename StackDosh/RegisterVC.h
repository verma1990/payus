//
//  RegisterVC.h
//  StackDosh
//
//  Created by Surender Kumar on 02/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"
#import <MapKit/MapKit.h>



@interface RegisterVC : UIViewController<WebServiceDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    IBOutlet UITextField *txt_firstName;
    IBOutlet UITextField *txt_lastName;
    IBOutlet UITextField *txt_emailAdd;
    IBOutlet UITextField *txt_pass;
    IBOutlet UITextField *txt_DOB;
    IBOutlet UITextField *txt_gender;
    IBOutlet UITextField *txt_location;
    IBOutlet UIView *viewGender;
    IBOutlet UITableView *tableViewGender;
    NSMutableArray *Arr_gender;
    IBOutlet UIView *GenderView;
    NSString *gender;
    IBOutlet UIButton *btn_Camera;
    IBOutlet UIImageView *imageViewProfile;
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
    IBOutlet UIScrollView *scrollVw_Reg;
    IBOutlet UITextField *txtField_Phone;
    

}
- (IBAction)TappedOnCamera:(id)sender;

- (IBAction)TappedOnRegister:(id)sender;
- (IBAction)TappedOnGender:(id)sender;

- (IBAction)TappedOnDOB:(id)sender;
- (IBAction)btnAllClick:(UIButton *)sender;




@end
                                                                                                                                                                                                                                          