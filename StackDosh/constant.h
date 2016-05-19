//
//  constant.h
//  Tchat
//
//  Created by ToXSL on 26/03/13.
//  Copyright (c) 2013 ToXSL. All rights reserved.
//

#ifndef Tchat_constant_h
#define Tchat_constant_h
#import "AppDelegate.h"

#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)


NSString *txt_global_postcode;
#define  KAppDelegate  ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#define liveurl                @"http://pay-us.co/payusadmin/"
#define kSignUpUser            @"/users/register?"
#define kLoginUser             @"/users/mobileuserlogin?"
#define KAdvrList              @"/webservices/adsList"
#define KAdverDetail           @"/webservices/adsDetails?"
#define KchangePsswrd          @"/users/changepass?"
#define KForgotPswd            @"/users/mobileuserforgot?"
#define KAderPost              @"/webservices/add?"
#define Kcheckpotential        @"/webservices/checkPotential?"
#define KShowPost              @"/webservices/userAds?"
#define PostShare              @"/webservices/adsshare?"
#define KEditProfile           @"/users/profile_edit?"
#define KPaypal                @"/webservices/sendPaypalDetails?"
#define KGetPostCode           @"/webservices/getZipCodeByLocation?"
#define kGetPotentials         @"/webservices/adsCost"
#define Kgetpost               @"/webservices/get_user_by_post_code?"
#define googleApi              @"http://maps.googleapis.com/maps/api/geocode/json?address="
#define KCheckAfliatedCode     @"/webservices/check_affiliate_code?"
#define KRemovedevicetoken     @"/webservices/remove_user_token?"

#define lightGrayColor [UIColor colorWithRed:0.875 green:0.89 blue:0.933 alpha:1] /*#dfe3ee*/
#define darkBlueColor [UIColor colorWithRed:0.231 green:0.349 blue:0.596 alpha:1] /*#3b5998*/
#define lightBlueColor [UIColor colorWithRed:0.545 green:0.616 blue:0.765 alpha:1] /*#8b9dc3*/


#endif
