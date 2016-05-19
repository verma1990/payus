
//  AdvertismentVc.m
//  StackDos0h
//
//  Created by Surender Kumar on 03/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "AdvertismentVc.h"
#import "Advertismentcell.h"
#import "AdvertismentVc.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "constant.h"
#import "DetailVC.h"
#import <Social/Social.h>
#import "PostAdvertismentVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "RKDropdownAlert.h"
#import <QuartzCore/QuartzCore.h>

@interface NSArray (Random)
- (id) randomObject;
@end

@implementation NSArray (Random)

- (id) randomObject
{
    if ([self count] == 0) {
        return nil;
    }
    return [self objectAtIndex: arc4random() % [self count]];
}

@end


@interface AdvertismentVc ()
{
    IBOutlet UIView *sharePostView;
    NSString *str_id;
    BOOL isFromGallery;
    NSString *str_earn;
    //Payments
    NSString *p_email;
    NSString *p_id;
    NSString *p_total_earnings;
    NSString *p_already_withdrawn;
    NSString *p_amount_due;
}

    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *descLabel;
    @property (weak, nonatomic) IBOutlet UILabel *txt_title;
    @property (weak, nonatomic) IBOutlet UITextField *txt_descripton;
    @property (weak, nonatomic) IBOutlet UITextField *txt_contactinfo;
    @property (weak, nonatomic) IBOutlet UITextField *txt_promocode;
    @property (weak, nonatomic) IBOutlet UILabel *contactLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *imageView;
    @property (weak, nonatomic) IBOutlet UIView *sharedView;

@end
@implementation AdvertismentVc

float total;
float withdrawn;
float due;

@synthesize txt_promocode;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getProilfeData];
    
    [self savePaymentData];
    
    HNKCacheFormat *format = [HNKCache sharedCache].formats[@"thumbnail"];
    if (!format)
    {
        format = [[HNKCacheFormat alloc] initWithName:@"thumbnail"];
        format.size = CGSizeMake(320, 240);
        format.scaleMode = HNKScaleModeAspectFill;
        format.compressionQuality = 0.5;
        format.diskCapacity = 1 * 1024 * 1024;
        format.preloadPolicy = HNKPreloadPolicyLastSession;
    }
    sharePost =NO;
    
    [sharePostView setHidden:YES];

    headingSeleect=NO;
    arr_advertList=[[NSMutableArray alloc]init];

    detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    btn_createAd.layer.cornerRadius = 3;
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeDefault];
    
    RefreshControl = [[UIRefreshControl alloc] init];
    RefreshControl.tintColor = [UIColor grayColor];
    [  RefreshControl addTarget:self action:@selector(handleRefreshComments:) forControlEvents:UIControlEventValueChanged];
    [tableView_adver addSubview:RefreshControl];
    
    isFromGallery =NO;
    // Do any additional setup after loading the view.
    
    _txt_title.adjustsFontSizeToFitWidth = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (!isFromGallery) {
        [sharePostView setHidden:YES];

        [proxyService sharedProxy].delegate = self;
        [self getAdvertismentlist];
    }
    else
        [sharePostView setHidden:NO];
    
}
-(IBAction)TappedOnCancelbtn:(id)sender
{
    [sharePostView setHidden:YES];
}

- (IBAction)TappedOnDrawer:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

#pragma mark --showAdvertisingList--
-(void)getAdvertismentlist
{
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        if (str_CurLocPost.length>0)
        {
            
        }
        else
        {
            str_CurLocPost = [[NSUserDefaults standardUserDefaults]objectForKey:@"enter_postcode"];
        }
        NSString *postData= [NSString stringWithFormat:@"user_id=%@&post_code=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"],str_CurLocPost];
        
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
        [[proxyService sharedProxy] postDataonServer:KAdvrList withPostString:postData];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
    }
}

#pragma mark --Navigation CreatePost Button--
- (IBAction)TappedOnCreateAd:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AdPost"];
    
    PostAdvertismentVC *PostAdverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostAdvertisment"];
    PostAdverVC.isFromAccountDetail=NO;
    [self.navigationController pushViewController:PostAdverVC animated:YES];
}

#pragma mark --Refresh Action--
-(void)handleRefreshComments:(UIRefreshControl*)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
    //refresh your data here
    NSString *lastupdated=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"update"]];
    if ((lastupdated.length!=0)&&(![lastupdated isEqualToString:@"null"])&&(lastupdated!=[NSNull class])&&(![lastupdated isEqualToString:@"(null)"])&&(![lastupdated isEqualToString:@"<null>"])&&(![lastupdated isEqualToString:@""]))
    {
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastupdated];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *updated = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    [[NSUserDefaults standardUserDefaults]setValue:updated forKey:@"update"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self getAdvertismentlist];
}


#pragma mark --TableView Delegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_advertList count];    //count number of row from counting array hear cataGorry is An Array
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 380;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    index=indexPath.row;
    static NSString *cellIdentifier = @"Advertismentcell";
    Advertismentcell *tempcell = (Advertismentcell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (tempcell == nil)
    {
        tempcell = [[Advertismentcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        tempcell = (Advertismentcell *)[nib objectAtIndex:0];
       if(arr_advertList>0)
       {
        [tempcell loaditemwithAdvertListArray:[arr_advertList objectAtIndex:indexPath.row]];
//        [tempcell.btn_cellSelect addTarget:self action:@selector(HeadingSelect:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.btnShare addTarget:self action:@selector(ShareAdver:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.btn_cellSelect addTarget:self action:@selector(ShareAdver:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.btn_cellSelect setTag:indexPath.row];
        [tempcell.btnShare setTag:indexPath.row];
           
           [tempcell.imageViewAdver.layer setBorderColor: [[UIColor colorWithRed:0.06 green:0.31 blue:0.55 alpha:0.5] CGColor]];
           [tempcell.imageViewAdver.layer setBorderWidth: 3];
           tempcell.imageViewAdver.layer.cornerRadius = 2;
       }
    }
    return tempcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    headingSeleect=YES;
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        NSString *postData= [NSString stringWithFormat:@"%@ad_id=%@",KAdverDetail,[[arr_advertList objectAtIndex:indexPath.row ]valueForKey:@"id"]];
        facebook_Friends=[[[arr_advertList objectAtIndex:indexPath.row]valueForKey:@"friends"] integerValue];
        earn_str= [NSString stringWithFormat:@"%@",[[arr_advertList objectAtIndex:indexPath.row] valueForKey:@"earn"]];

        
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
        [[proxyService sharedProxy] getDataFromServer:postData withGetString:@""];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}


#pragma mark --Share Advertisment--
-(void)ShareAdver:(UIButton *)sender
{
    [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];

    [self SharePost:[sender tag]];
    
    NSLog(@"Share Button Presssed");
    
}

-(void)SharePost:(NSInteger)sender
{
    [sharePostView setHidden:NO];
    
    _sharedView.layer.cornerRadius = 0;
    _sharedView.clipsToBounds = YES;
    [_sharedView setBackgroundColor:[UIColor whiteColor]];
    
    _imageView.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    
    [_imageView.layer setBorderColor: [[UIColor colorWithRed:0.875 green:0.89 blue:0.933 alpha:1] CGColor]];
    [_imageView.layer setBorderWidth: 1.0];
    
    NSLog(@"%@",arr_advertList);
    _txt_title.text=[[arr_advertList objectAtIndex:sender]valueForKey:@"title"];
    _txt_contactinfo.text=[NSString stringWithFormat:@"%@",[[arr_advertList objectAtIndex:sender]valueForKey:@"email"]];

    _descLabel.text=[NSString stringWithFormat:@"%@",[[arr_advertList objectAtIndex:sender]valueForKey:@"description"]];
    txt_promocode.text=[NSString stringWithFormat:@"Promo Code: %@",[[arr_advertList objectAtIndex:sender]valueForKey:@"promo_code"]];
    
    NSString *sharedMessage = [NSString stringWithFormat:@"%@. Contact - %@. %@.", _descLabel.text, _txt_contactinfo.text, txt_promocode.text];
    
    sharedMessageLabel.text = sharedMessage;
    sharedMessageLabel.adjustsFontSizeToFitWidth=YES;
    sharedMessageLabel.minimumScaleFactor=0.5;
    
    facebook_Friends=[[[arr_advertList objectAtIndex:sender]valueForKey:@"friends"] integerValue];
    earn_str= [NSString stringWithFormat:@"%@",[[arr_advertList objectAtIndex:sender] valueForKey:@"earn"]];
    
    if ([earn_str isEqualToString:@"00"])
    {
        earn_str = @"0.00";
        str_earn=[NSString stringWithFormat:@"%@",earn_str];

    }
   else if ([earn_str isEqualToString:@"0"])
    {
        earn_str = @"0.00";
        str_earn=[NSString stringWithFormat:@"%@",earn_str];
        
    }
 
   else if ((earn_str.length!=0)&&(![earn_str isEqualToString:@"null"])&&(earn_str!=[NSNull class])&&(![earn_str isEqualToString:@"(null)"])&&(![earn_str isEqualToString:@"<null>"])&&(![earn_str isEqualToString:@""]))
    {
        str_earn=[NSString stringWithFormat:@"%@",earn_str];
    }
    else
    {
        earn_str = @"0.00";

        str_earn=[NSString stringWithFormat:@"%@",earn_str];

    }
    NSLog(@"str earn %@",str_earn);
 
    str_id=[NSString stringWithFormat:@"%@",[[arr_advertList objectAtIndex:sender] valueForKey:@"id"]];
    
    NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arr_advertList objectAtIndex:sender] valueForKey:@"image"]]];
    NSData* imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage* image = [UIImage imageWithData:imageData];

    _imageView.image = image;
    
    
    sharePost =YES;

    [[proxyService sharedProxy] hideActivityIndicatorInView];

}

- (IBAction)inviteFriends:(id)sender{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"http://payusapp.com/AppLinks/"];
    //optionally set previewImageURL
    //content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:self];
}

-(IBAction)TappedonPostToFacebookbtn:(id)sender
{
    NSString *string_fb;
    if (facebook_Friends >300)
    {
        string_fb = @"";
        
        float float_earn = [str_earn floatValue];
        
        NSString *earnMessage = [NSString stringWithFormat:@"You will earn £%@%.2f for sharing this post", string_fb, float_earn];
        
        myAlertView = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:earnMessage  delegate:self cancelButtonTitle:@"Cancel"                                                          otherButtonTitles:@"OK", nil];
        myAlertView.tag=1;
        
        [myAlertView show];
        /*[RKDropdownAlert title:@"" message:[@"You will earn £" stringByAppendingString:str_earn] backgroundColor:[UIColor greenColor] textColor:[UIColor whiteColor] time:3];*/
    }
    else
    {
        string_fb = @" because you have less than 300 friends.";
        
        [RKDropdownAlert title:@"Error" message:[@"You cannot share a post" stringByAppendingString:string_fb] backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
    }

}

- (void)sharer:	(id<FBSDKSharing>)sharer
didCompleteWithResults:	(NSDictionary *)results{
    
    NSLog(@"Share Results %@", results);
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        NSString *postData= [NSString stringWithFormat:@"post_id=%@&shared_userid=%@",str_id,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
        [[proxyService sharedProxy] postDataonServer:PostShare withPostString:postData];
        NSLog(@"share complete");
        
        [self savePaymentData];
    }
    
}


- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"share cancelled");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"share error");
}

#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{

    
    [RefreshControl endRefreshing];
    
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    
    if(headingSeleect==YES)
    {
        
        detailVC.Arr_adverDetail=responseDic;
        detailVC.facebook_Friends =  facebook_Friends;
        detailVC.str_earn = earn_str;
        detailVC.isFromAdvertisment=YES;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        headingSeleect=NO;
    }
    else if(sharePost==YES)
    {
        NSInteger i=[[responseDic valueForKey:@"status"] integerValue];
        if(i==1)
        {
         
            [sharePostView setHidden:YES];
            sharePost=NO;
            [self getAdvertismentlist];
            [tableView_adver reloadData];

        }
        else
        {
            alert(@"Message", @"Post could not be shared. post have no remaining share.");
        }
    }
    else
    {
        if([[responseDic valueForKey:@"status"] integerValue]==1)
        {
            arr_advertList=[responseDic valueForKey:@"adsList"];
            
            NSString *str_friends=[[[responseDic objectForKey:@"adsList"] objectAtIndex:0] valueForKey:@"friends"];
            [[NSUserDefaults standardUserDefaults]setObject:str_friends forKey:@"userFriends"];
            
            
            if([arr_advertList count]>0)
            {
                [tableView_adver reloadData];
                [introWebView removeFromSuperview];
            }
        }
        else
        {
            [arr_advertList removeAllObjects];
            
            /*NSArray *messges_list;
            messges_list = [NSArray arrayWithObjects:
                    @"If you have something to sell - create your own post now!",
                    @"Do you have a business? Create a post to be shared and reach new customers!",
                    @"There's nothing to share in your area. Why not create a post for others to share?",
                    @"Want to sell some old stuff? Try creating a post for others to share!",
                    @"Got a small business? Create a post and reach thousands of local people!",
                    @"Has your business got an offer? Create a post to be shared with new customers!",
                    nil];
            
            NSString *randomMessage = [messges_list randomObject];
            
            myAlertView = [[UIAlertView alloc] initWithTitle:@"Create Post" message:randomMessage delegate:self cancelButtonTitle:@"Cancel"                                                          otherButtonTitles:@"Create Post", nil];
            myAlertView.tag=0;

            [myAlertView show];
            */

            
            introWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 66, self.view.bounds.size.width,self.view.bounds.size.height)];
            NSString *url=@"http://www.payusapp.com/intro";
            NSURL *nsurl=[NSURL URLWithString:url];
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            [introWebView loadRequest:nsrequest];
            [self.view addSubview:introWebView];
            [tableView_adver reloadData];
            
            UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
            [topView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_bg.png"]]];
            [introWebView addSubview:topView];
            
            UIButton *createButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [createButton addTarget:self
                             action:@selector(inviteAllFriends:)
                   forControlEvents:UIControlEventTouchUpInside];
            [createButton setTitle:@"Invite Friends" forState:UIControlStateNormal];
            createButton.titleLabel.textColor = [UIColor blueColor];
            createButton.backgroundColor = [UIColor whiteColor];
            createButton.frame = CGRectMake(0.0, 0.0, 160.0, 40.0);
            createButton.center = CGPointMake(self.view.frame.size.width / 2, 37);
            
            createButton.layer.cornerRadius = 10; // this value vary as per your desire
            createButton.clipsToBounds = YES;
            
            [topView addSubview:createButton];

        }
    }
}

- (void)inviteAllFriends:(id)sender{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"http://payusapp.com/AppLinks/"];
    content.promotionText = @"Check out the Pay Us app, where you get paid £1 to share posts on Facebook.";
    //optionally set previewImageURL
    //content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:self];
}

- (void)
appInviteDialog:	(FBSDKAppInviteDialog *)appInviteDialog
didFailWithError:	(NSError *)error{
    NSLog(@"APP INVITE DID FAIL WITH ERROR - %@", error);
}

- (void)
appInviteDialog:	(FBSDKAppInviteDialog *)appInviteDialog
didCompleteWithResults:	(NSDictionary *)results{
    NSLog(@"APP INVITE RESULTS - %@", results);
    
}

- (void)createPostPage:(id)sender{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AdPost"];
    
    PostAdvertismentVC *PostAdverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostAdvertisment"];
    PostAdverVC.isFromAccountDetail=NO;
    [self.navigationController pushViewController:PostAdverVC animated:YES];
}


-(void)failToGetResponseWithError:(NSError *)error
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}


#pragma mark --AlertView Delegete--
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((myAlertView.tag==0)) {
        
        if(alertView==myAlertView)
        {
            if (buttonIndex==1)
            {
                PostAdvertismentVC *PostAdverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostAdvertisment"];
                [self.navigationController pushViewController:PostAdverVC animated:YES];
            }
            
        }
    
    }
    else
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
            }
            
            
            /*FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];

            login.loginBehavior=FBSDKLoginBehaviorSystemAccount;
            login.defaultAudience = FBSDKDefaultAudienceFriends;
            
            NSArray *permissions = @[@"publish_actions"];
            
            
            [login logInWithPublishPermissions:permissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
             {
                 if (!error) {
                     
                     UIGraphicsBeginImageContextWithOptions(_sharedView.bounds.size, _sharedView.opaque, 0.0f);
                     [_sharedView drawViewHierarchyInRect:_sharedView.bounds afterScreenUpdates:NO];
                     [_sharedView.layer renderInContext:UIGraphicsGetCurrentContext()];
                     UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                     UIGraphicsEndImageContext();
                     UIImage *someImage = viewImage;
                     FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
                     content.photos = @[[FBSDKSharePhoto photoWithImage:someImage userGenerated:YES]];
                     
                     [FBSDKShareAPI shareWithContent:content delegate:self];
                     
                     /*UIGraphicsBeginImageContextWithOptions(_sharedView.bounds.size, _sharedView.opaque, 0.0f);
                     [_sharedView drawViewHierarchyInRect:_sharedView.bounds afterScreenUpdates:NO];
                     [_sharedView.layer renderInContext:UIGraphicsGetCurrentContext()];
                     UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                     UIGraphicsEndImageContext();
                     
                     [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
                     
                     //NSString *sharedMessage = [NSString stringWithFormat:@"%@\n%@\n Contact - %@. %@.\nI got paid to share this using the Pay Us App http://bit.ly/PayUsApp", _txt_title.text, _descLabel.text, _txt_contactinfo.text, txt_promocode.text];
                     
                     NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
                     [params setObject:UIImagePNGRepresentation(viewImage) forKey:@"picture"];
                     
                     [[[FBSDKGraphRequest alloc]
                       initWithGraphPath:@"me/photos"
                       parameters: params
                       HTTPMethod:@"POST"]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                          
                          BOOL checkNet = [[proxyService sharedProxy] checkReachability];
                          if(checkNet == TRUE)
                          {
                              NSString *postData= [NSString stringWithFormat:@"post_id=%@&shared_userid=%@",str_id,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
                              [[proxyService sharedProxy] postDataonServer:PostShare withPostString:postData];
                              
                              NSLog(@"share complete");
                              [[proxyService sharedProxy] hideActivityIndicatorInView];
                              [self savePaymentData];
                          }
                      }];
                     
                     
                     
                 }
                  else if (result.isCancelled) {
                     NSLog(@"permissions cancelled");
                  } else if (error) {
                      NSLog(@"There was an error with FB:\n %@",error.description);
                  }
             }];*/
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getProilfeData{
    NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"http://pay-us.co/payusadmin/webservices/userAds?"]];
    NSString *str= [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
    NSData * postData = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urli];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError * error = nil;
    NSURLResponse * response = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *json;
    if(data)
    {
        json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        KAppDelegate.Arr_profileData = json;
        str_CurLocPost =[json objectForKey:@"post_code"];
        p_email = [json objectForKey:@"email"];
        p_total_earnings = [[json objectForKey:@"totalEarn"] valueForKey:@"totalEarns"];
        
        [[NSUserDefaults standardUserDefaults] setObject:p_email forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setFloat:[p_total_earnings floatValue] forKey:@"totalearnings"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
}

-(void)savePaymentData{
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          valueForKey:@"username"];
    
    total = [[NSUserDefaults standardUserDefaults]
             floatForKey:@"totalearnings"];
    withdrawn = [[NSUserDefaults standardUserDefaults]
                 floatForKey:@"alreadywithdrawn"];
    due = total - withdrawn;
    
    NSString *rawStr = [NSString stringWithFormat:@"user_name=%@&total_earnings=%f",
                        username,
                        [p_total_earnings floatValue]
                        ];
    
    NSLog(@"rawStr: %@", rawStr);
    
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://payusapp.com/payusadmin/resources/update?"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
    NSString *success = @"success";
    [success dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%lu", (unsigned long)responseString.length);
    NSLog(@"%lu", (unsigned long)success.length);
    
}



@end
