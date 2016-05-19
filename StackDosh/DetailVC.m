//
//  DetailVC.m
//  StackDosh
//
//  Created by Surender Kumar on 03/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "DetailVC.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import <Social/Social.h>
#import "constant.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PostAdvertismentVC.h"

@interface DetailVC () <FBSDKSharingDelegate>
{
    IBOutlet UIView *sharePostView;
    
}

@property (weak, nonatomic) IBOutlet UILabel *txt_title;
@property (weak, nonatomic) IBOutlet UITextField *txt_descripton;
@property (weak, nonatomic) IBOutlet UITextField *txt_promocode;
@property (weak, nonatomic) IBOutlet UITextField *txt_contactinfo;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *sharedView;
@end

@implementation DetailVC
@synthesize Arr_adverDetail,isFromAdvertisment,txt_promocode,str_earn,facebook_Friends;

- (void)viewDidLoad
{
    [super viewDidLoad];
    sharePost=NO;
    [sharePostView setHidden:YES];

    _txt_title.adjustsFontSizeToFitWidth = YES;
    lbl_title.layer.cornerRadius=0.5f;
    [lbl_title.layer setMasksToBounds:YES];
    lbl_title.layer.borderColor=[lightGrayColor CGColor];
    txtVw_Disc.layer.cornerRadius=0.5f;
    [txtVw_Disc.layer setMasksToBounds:YES];
    txtVw_Disc.layer.borderColor=[lightGrayColor CGColor];
    
//    if([[Arr_adverDetail valueForKey:@"shared"] integerValue]==1){
//        [btn_share setHidden:YES];
//    }
//    else{
//        [btn_share setHidden:NO];
//    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [proxyService sharedProxy].delegate=self;

    [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
    [self ShowAdverDetail];
    
    if (isFromAdvertisment)
    {
        [btn_share setTitle:@"Share" forState:UIControlStateNormal];
    }
    else
    {
        [btn_share setTitle:@"Re-Post" forState:UIControlStateNormal];

    }
    
}

- (IBAction)TappedOnBck:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --Show Adver Detail--
-(void)ShowAdverDetail
{
    imageViewAdvert.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[Arr_adverDetail valueForKey:@"image"]]];
    lbl_title.text=[NSString stringWithFormat:@"%@",[Arr_adverDetail valueForKey:@"title"]];
        _txt_contactinfo.text=[NSString stringWithFormat:@"%@",[Arr_adverDetail valueForKey:@"email"]];
    txtVw_Disc.text=[NSString stringWithFormat:@"%@",[Arr_adverDetail valueForKey:@"description"]];
    txt_promocode.text=[NSString stringWithFormat:@"Promo Code:%@",[Arr_adverDetail valueForKey:@"promo_code"]];
}

#pragma mark --Share Post
- (IBAction)TappedOnShare:(id)sender
{
    [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];

    [self SharePost];
    
}

-(IBAction)TappedOnCancelbtn:(id)sender
{
    [sharePostView setHidden:YES];
}


-(void)SharePost
{
    
    if (isFromAdvertisment)
    {
        [sharePostView setHidden:NO];
        ;

    }
    else
    {
        [sharePostView setHidden:YES];
        
        KAppDelegate.Arr_rePostData =Arr_adverDetail;
        PostAdvertismentVC *postVC;
        postVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostAdvertisment"];
        postVC.isFromAccountDetail=YES;
        [self.navigationController pushViewController:postVC animated:YES];
    }
    
    
    
   // [_sharedView.layer setBorderWidth: 2.0];
    _sharedView.layer.cornerRadius = 10;
    _sharedView.clipsToBounds = YES;
    
    NSLog(@"array advDetail%@",Arr_adverDetail);
    NSLog(@"array advDetail2%@",KAppDelegate.Arr_rePostData);

    
    _txt_title.text=[NSString stringWithFormat:@"%@",[Arr_adverDetail valueForKey:@"title"]];
    //[Arr_adverDetail valueForKey:@"title"];
    _txt_contactinfo.text=[NSString stringWithFormat:@"%@",[Arr_adverDetail valueForKey:@"email"]];
    if ([str_earn isEqualToString:@"00"])
    {
        str_earn = @"0.00";
        str_earn=[NSString stringWithFormat:@"%@",str_earn];
        
    }
    else if ([str_earn isEqualToString:@"0"])
    {
        str_earn = @"0.00";
        str_earn=[NSString stringWithFormat:@"%@",str_earn];
        
    }
    
    else if ((str_earn.length!=0)&&(![str_earn isEqualToString:@"null"])&&(str_earn!=[NSNull class])&&(![str_earn isEqualToString:@"(null)"])&&(![str_earn isEqualToString:@"<null>"])&&(![str_earn isEqualToString:@""]))
    {
        str_earn=[NSString stringWithFormat:@"%@",str_earn];
  
    }
    else
    {
        str_earn = @"0.00";
        str_earn=[NSString stringWithFormat:@"%@",str_earn];
        
    }


     _descLabel.text=[NSString stringWithFormat:@"%@",[Arr_adverDetail valueForKey:@"description"]];
    
    NSString *promo_code = [Arr_adverDetail valueForKey:@"promo_code"];
    if (promo_code == (id)[NSNull null]) {
        //  is null
        txt_promocode.text=[NSString stringWithFormat:@"Promo Code:%@",@"PAYUS"];
        NSLog(@"Promo Code is NULL");
    } else {
        txt_promocode.text=[NSString stringWithFormat:@"Promo Code:%@",[Arr_adverDetail valueForKey:@"promo_code"]];
    }
    
    
    NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[Arr_adverDetail  valueForKey:@"image"]]];
    NSData* imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage* image = [UIImage imageWithData:imageData];
    
    
    
    _imageView.image = image;
    sharePost =YES;
    [[proxyService sharedProxy] hideActivityIndicatorInView];

    
    
    
}

-(IBAction)TappedonPostToFacebookbtn:(id)sender
{
    NSString *string_fb;
    if (facebook_Friends >300)
    {
        string_fb = @"";
        myAlertView = [[UIAlertView alloc] initWithTitle:@"Message" message:[[@"You will earn £" stringByAppendingString:str_earn] stringByAppendingString:string_fb]  delegate:self cancelButtonTitle:@"Cancel"                                                          otherButtonTitles:@"OK", nil];
        myAlertView.tag=1;
        
        [myAlertView show];
    }
    else
    {
        string_fb = @" because you have less than 300 friends.";
        
        myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[@"You cannot share a post" stringByAppendingString:string_fb]   delegate:self cancelButtonTitle:nil                                                          otherButtonTitles:@"OK", nil];
        
        [myAlertView show];
    }

      // }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((myAlertView.tag==1))
    {
        if (buttonIndex==1)
        {
            
            
            UIGraphicsBeginImageContextWithOptions(_sharedView.bounds.size, _sharedView.opaque, 0.0f);
            [_sharedView drawViewHierarchyInRect:_sharedView.bounds afterScreenUpdates:NO];
            [_sharedView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
            photo.image = viewImage;
            photo.userGenerated = YES;
            FBSDKSharePhotoContent * photoContent = [[FBSDKSharePhotoContent alloc] init];
            photoContent.photos = @[photo];
            FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
            shareDialog.shareContent = photoContent;
            shareDialog.delegate = (id)self;
            shareDialog.fromViewController = self;
            NSError * error = nil;
            BOOL validation = [shareDialog validateWithError:&error];
            if (validation) {
                [shareDialog show];
                BOOL checkNet = [[proxyService sharedProxy] checkReachability];
                if(checkNet == TRUE)
                {
                    [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
                    NSString *postData= [NSString stringWithFormat:@"post_id=%@&shared_userid=%@",[Arr_adverDetail valueForKey:@"id"],[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
                    [[proxyService sharedProxy] postDataonServer:PostShare withPostString:postData];
                }
            }
            
            /*FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            //login.loginBehavior=FBSDKLoginBehaviorWeb;  // it open inside the app using popup menur
            login.loginBehavior=FBSDKLoginBehaviorSystemAccount;  // it open inside the app using popup menur
            [login logInWithPublishPermissions:@[@"publish_actions"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error) {
                    // Process error
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    [alert show];
                    
                } else if (result.isCancelled) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    [alert show];
                } else {
                    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
                        
                        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
                        
                        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
                        //[params setObject:@"Created using the Pay Us App http://bit.ly/PayUsApp" forKey:@"message"];
                        [params setObject:UIImagePNGRepresentation(viewImage) forKey:@"picture"];
                        
                        [[[FBSDKGraphRequest alloc]
                          initWithGraphPath:@"me/photos"
                          parameters: params
                          HTTPMethod:@"POST"]
                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                             if (!error) {
                                 NSLog(@"Post id:%@", result[@"id"]);
                                 
                                 
                                 BOOL checkNet = [[proxyService sharedProxy] checkReachability];
                                 if(checkNet == TRUE)
                                 {
                                     [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
                                     NSString *postData= [NSString stringWithFormat:@"post_id=%@&shared_userid=%@",[Arr_adverDetail valueForKey:@"id"],[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
                                     [[proxyService sharedProxy] postDataonServer:PostShare withPostString:postData];
                                 }
                             } else {
                                 
                             }
                         }];
                    }
                }
            }];*/
            
            
            //  if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            // {
            
            /*SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
             
             SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
             if (result == SLComposeViewControllerResultCancelled) {
             
             NSLog(@"Cancelled");
             
             } else
             
             {
             NSLog(@"Done");
             
             BOOL checkNet = [[proxyService sharedProxy] checkReachability];
             if(checkNet == TRUE)
             {
             NSString *postData= [NSString stringWithFormat:@"post_id=%@&shared_userid=%@",str_id,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
             [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
             [[proxyService sharedProxy] postDataonServer:PostShare withPostString:postData];
             
             [self savePaymentData];
             }
             else
             {
             [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
             }
             
             }
             
             [controller dismissViewControllerAnimated:YES completion:Nil];
             };
             controller.completionHandler =myBlock;
             
             [controller addImage:viewImage];
             
             [self presentViewController:controller animated:YES completion:Nil];*/
            
        }

        

    }
   
}

/*

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"completed share:%@", results);
 
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        NSString *postData= [NSString stringWithFormat:@"post_id=%@&shared_userid=%@",[[Arr_adverDetail objectAtIndex:0]valueForKey:@"id"],[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
        [[proxyService sharedProxy] postDataonServer:PostShare withPostString:postData];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

*/

#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    
    if(sharePost==YES)
    {
        NSInteger i=[[responseDic valueForKey:@"status"] integerValue];
        if(i==1)
        {
            [sharePostView setHidden:YES];

            sharePost=NO;
            btn_share.hidden=YES;
           
        }
        else
        {
          alert(@"Message", @"Post could not be shared. post have no remaining share.");
        }
    }
}

-(void)failToGetResponseWithError:(NSError *)error
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
