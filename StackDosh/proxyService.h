//
//  proxyService.h
//  QuizU
//
//  Created by TX-MAC-02 on 3/21/14.
//  Copyright (c) 2014 TX-MAC-02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@protocol WebServiceDelegate <NSObject>

-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service;
-(void)failToGetResponseWithError:(NSError *)error;
@end


@interface proxyService : NSObject
{
    NSURLConnection *connection ;
    NSMutableData *receivedData;
    NSString *currentURL;
    MBProgressHUD *activityIndicator;
}

@property (nonatomic, strong) id<WebServiceDelegate> delegate;


+(proxyService*) sharedProxy;
+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point;


-(void)postDataonServer:(NSString *)serverPath withPostString:(NSString *)postData;
-(void)getDataFromServer:(NSString *)serverPath withGetString:(NSString *)getData;
-(NSString *)makeServerPath:(NSString *)str_Url;
-(void) requestWith:(NSString *)serviceName withAppending:(NSString*)parameter;

-(void)uploadImageWithServerPath:(NSString *)serverPath withImageData:(NSData*)imageData withParmeter:(NSString *)modeString;

-(void)getInfoFromGoogle:(NSString *)serviceName with:(NSString*)parameter;

-(BOOL)checkReachability;

-(void)showActivityIndicatorInView:(UIView *)inView withLabel:(NSString *)message;
-(void)hideActivityIndicatorInView;


@end
