//
//  PostAdvertismentVC.h
//  StackDosh
//
//  Created by Surender Kumar on 05/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "proxyService.h"
#import "Base64.h"
#import "Purchaseview.h"
#import "KGModal.h"
#import "Purchaseview.h"
#import "UITextFieldLimit.h"

@interface PostAdvertismentVC : UIViewController<CLLocationManagerDelegate,UINavigationBarDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,WebServiceDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
     NSMutableArray *tier_Array,*price_Array,*shares_Array,*reach_Array,*arrkeyandvalue;
    NSMutableArray *post_id_array;
    IBOutlet UITextView *txtVw_Description;
    IBOutlet UITextFieldLimit *txtPostCode;
    IBOutlet UITextFieldLimit *txtField_Title;
    IBOutlet UITextField *txtField_email;
    IBOutlet UITextField *txtField_telephone;
    IBOutlet UITextFieldLimit *txtField_Disc;
    IBOutlet UIImageView *imageVw_postCode;
    BOOL pay_bool;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSData *dataImage;
    NSString *encryptedString;
    UIImage *obj_imagePick;
    IBOutlet UIButton *btn_camera;
    UIImage *img;
    NSString *money;
    IBOutlet UIView *pop_View;
    IBOutlet UITableView *pop_Tableview;

    IBOutlet UIButton *btn_drawer;
    NSMutableArray *arr_cities;
    NSMutableArray *arr_filterCty;
    
    CGPoint svos;
    CGRect rc;
    CGPoint pt;
    UIAlertView *alert_money;
     UIView *view1;
    IBOutlet UIScrollView *scrollView_Advers;
    IBOutlet UIImageView *imageViewCam;
    IBOutlet UIScrollView *PostCode_scrollVw;
    IBOutlet UIButton *btn_check;
    BOOL CurLoc;
    
    NSMutableArray *arr_allPostcode;
    
    IBOutlet UITextFieldLimit *txt_PostCodeOp1;
    IBOutlet UITextFieldLimit *txt_PostcodeOp2;
    IBOutlet UITextField *txt_promoCode;
    
    
    IBOutlet UIScrollView *btn_find1;
    IBOutlet UIScrollView *btn_find2;
    NSString *str_postCodeOP1,*plan_id_String;
    NSString *str_postCodeOP2;
    
    NSInteger tag;
    BOOL tabletag;
    NSString *str_CurLocPost;
    BOOL OptPostc;
    IBOutlet UILabel *lbl_contactDetail;
    IBOutlet UILabel *lbl_promocode;
    IBOutlet UILabel *lbl_PreDis;
    IBOutlet UIButton *select_Plan_btn;
    BOOL plan_boool,post_code_bool;
    
    NSMutableArray  *arrayPotentials;
    NSMutableArray *arrayPotentail;
    NSString *strPotential_form;
    NSString *strPotential_to;
    NSString *strCost;
    
    __weak IBOutlet UIButton *applyBtn;
    
}
- (IBAction)TappedOnLocation:(id)sender;
- (IBAction)TappedOnCurrentloc:(id)sender;

- (IBAction)ApplyPromoCode:(id)sender;


@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(nonatomic, assign, readwrite) BOOL isFromAccountDetail;

- (IBAction)TappedOnFindLoc:(id)sender;
- (IBAction)TappedOnBack:(id)sender;
- (IBAction)TappedOnCamera:(id)sender;
- (IBAction)TappedOnPostAdver:(id)sender;

@end
