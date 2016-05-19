//
//  Purchaseview.h
//  StackDosh
//
//  Created by Surender on 04/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "PurchaseCell.h"
#import "constant.h"
#import <StoreKit/StoreKit.h>
#import "proxyService.h"
#import "AppManager.h"
#import "AdvertismentVc.h"
#import "PostAdvertismentVC.h"
#import "PayPalMobile.h"


#define InAppProduct_Plan1 @"Product_id_1"
#define InAppProduct_Plan2 @"Product_id_2"
#define InAppProduct_Plan3 @"Product_id_3"
#define InAppProduct_Plan4 @"Product_id_4"
#define InAppProduct_Plan5 @"Product_id_5"
#define InAppProduct_Plan6 @"Product_id_6"
#define InAppProduct_Plan7 @"Product_id_7"
#define InAppProduct_Plan8 @"Product_id_8"
#define InAppProduct_Plan9 @"Product_id_9"
#define InAppProduct_Plan10 @"product_id_10"


@interface Purchaseview : UIViewController<UIActionSheetDelegate,WebServiceDelegate,PayPalFuturePaymentDelegate,PayPalPaymentDelegate,PayPalProfileSharingDelegate>
{
    NSString *money;
    NSString *Paypal_id;
    UIAlertView *myAlertView1;
    IBOutlet UIButton *done_button;
    SKProductsRequest *productsRequest;
    NSMutableArray *tier_Array,*price_Array,*shares_Array,*reach_Array,*arrkeyandvalue;
    NSString *plan_id_string;
    NSInteger Buytag,moneytag;
    IBOutlet UITableView *purchase_Table;
    PurchaseCell *purchaseCell;
    IBOutlet UIButton  *side_bar_button;
    
}
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(nonatomic, assign, readwrite) BOOL isFromAccountDetail;
@property(strong,nonatomic)NSString *post_to_purchase;
@end
