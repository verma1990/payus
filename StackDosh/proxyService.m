//
//  proxyService.m
//  QuizU
//
//  Created by TX-MAC-02 on 3/21/14.
//  Copyright (c) 2014 TX-MAC-02. All rights reserved.
//
#import "proxyService.h"
#import "constant.h"
#import "JSON.h"
#import "SBJSON.h"
#import "Reachability.h"

@implementation proxyService
@synthesize delegate;

static proxyService *sharedInstance = nil;

+(proxyService*) sharedProxy
{
   if (!sharedInstance)
   {
     sharedInstance = [[proxyService alloc] init];
   }
   return sharedInstance;
}

#pragma mark - Post & Get Data
-(void) postDataonServer:(NSString *)serverPath withPostString:(NSString *)postData
{
    [connection cancel];
    currentURL = serverPath;
    NSString *requestUrl=[self makeServerPath:serverPath];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [url standardizedURL]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
  //  NSLog(@"auth_code..%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_code"]);
    //[request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_code"] forHTTPHeaderField:@"auth_code"];
    
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void )getDataFromServer:(NSString *)serverPath withGetString:(NSString *)getData
{
    [connection cancel];
    currentURL = serverPath;
    NSString *requestUrl = [self makeServerPath:serverPath];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [url standardizedURL]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_code"] forHTTPHeaderField:@"auth_code"];
    
    [request setHTTPBody:[getData dataUsingEncoding:NSUTF8StringEncoding]];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)getInfoFromGoogle:(NSString *)serviceName with:(NSString*)parameter
{
    [connection cancel];
    currentURL=serviceName;
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",serviceName,parameter];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [url standardizedURL]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40];
    [request setHTTPMethod:@"GET"];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)requestWith:(NSString *)serviceName withAppending:(NSString*)parameter
{
    [connection cancel];
    currentURL=serviceName;
    NSString *requestUrl=[self makeServerPath:[NSString stringWithFormat:@"%@%@",serviceName,parameter]];
    
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [url standardizedURL]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_code"] forHTTPHeaderField:@"auth_code"];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark - Upload Image

-(void)uploadImageWithServerPath:(NSString *)serverPath withImageData:(NSData*)imageData withParmeter:(NSString *)modeString
{
    [connection cancel];
    currentURL = serverPath;
    currentURL = [self makeServerPath:serverPath] ;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:currentURL]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *dataString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"a.png\"\r\n",modeString];
    
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if(imageData)
    {
        [body appendData:[NSData dataWithData:imageData]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_code"] forHTTPHeaderField:@"auth_code"];
    [request setHTTPBody:body];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark - Append ServerUrl

-(NSString *)makeServerPath:(NSString *)str_Url
{
    NSString *str_ServerPath=[NSString stringWithFormat:@"%@%@",liveurl,str_Url];
    return str_ServerPath;
}

#pragma mark - NSUrlConnection Delegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  [self.delegate failToGetResponseWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  receivedData = [[NSMutableData alloc] init];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{                       
    NSString *htmlSTR = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *dic_Response=[[NSDictionary alloc]init];
    dic_Response=[htmlSTR JSONValue];
    [self.delegate serviceResponse:dic_Response withServiceURL:currentURL];
}

#pragma mark - Activity indicator
-(void)showActivityIndicatorInView:(UIView *)inView withLabel:(NSString *)message
{
    activityIndicator = [[MBProgressHUD alloc] initWithView:inView];
    [inView addSubview:activityIndicator];
    activityIndicator.labelText = message;
    [activityIndicator show:YES];
}

-(void)hideActivityIndicatorInView
{
    [activityIndicator hide:YES];
    [activityIndicator removeFromSuperViewOnHide];
}

#pragma mark - check Reachability

-(BOOL)checkReachability
{
    BOOL returnYesNo;
    
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable)
    {
        returnYesNo = YES;
    }
    else
    {
        returnYesNo = NO;
        [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:@"There is no internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

    return returnYesNo;
}




@end
