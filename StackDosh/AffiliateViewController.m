//
//  AffiliateViewController.m
//  StackDosh
//
//  Created by Mandeep Singh on 19/05/16.
//  Copyright © 2016 trigma. All rights reserved.
//

#import "AffiliateViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "constant.h"
#import "proxyService.h"

@interface AffiliateViewController ()
{
    
    __weak IBOutlet UILabel *lblAffiliateCode;
}

@end

@implementation AffiliateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
         NSString *postData= [NSString stringWithFormat:@"%@user_id=%@",KShowPost,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
        
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Authenticating.."];
        [[proxyService sharedProxy] postDataonServer:postData withPostString:@""];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TappedOnback:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    NSLog(@"Response :%@",responseDic);
    
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    NSInteger Status=[[responseDic valueForKey:@"status"] integerValue];
    if(Status ==1)
    {
       
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:[responseDic valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

-(void)failToGetResponseWithError:(NSError *)error
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}


@end
