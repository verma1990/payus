//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "AdvertismentVc.h"
#import "AccountVC.h"
#import "ChangePasswordVC.h"
#import "ViewController.h"
#import "constant.h"
#import "AsyncImageView.h"
#import "HelpVC.h"
#import "PostAdvertismentVC.h"
#import "EditProfileVC.h"
//#import <FacebookSDK/FacebookSDK.h>
#import "Purchaseview.h"
#import "AffiliateViewController.h"



@implementation SideMenuViewController

#pragma mark -
#pragma mark - UITableViewDataSource

- (void)viewDidLoad
{

    arr_For_firstSection=[[NSMutableArray alloc]initWithObjects:@"Home",@"Create Post",@"My Affiliate Code",@"Account",@"Help",@"Sign out",nil];
    
    arrImge_ForfirstSection=[[NSMutableArray alloc]initWithObjects:@"home-icon",@"create-post-icon",@"affi",@"user-icon",@"help",@"logout-icon" ,nil];

    
    arr_KeyAndValue=[[NSMutableArray alloc]init];
    
    for (int index=0;index<[arrImge_ForfirstSection count];index++)
    {
         NSDictionary *arr_Dic=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[arr_For_firstSection objectAtIndex:index],[arrImge_ForfirstSection objectAtIndex:index],Nil]  forKeys:[NSArray arrayWithObjects:@"title",@"image",Nil]];
        [arr_KeyAndValue addObject:arr_Dic];
    }
      profileImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(80, 50, 90, 90)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ShowProfileImage)
                                             name:@"ProfileImage"
                                           object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (KAppDelegate.Arr_profileData.count
        >0)
    {
        if([[KAppDelegate.Arr_profileData valueForKey:@"user_pic"] isEqual:nil])
        {
            profileImage.image=[UIImage imageNamed:@"sidebar-profile-img"];
        }
        else
        {
            profileImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[KAppDelegate.Arr_profileData valueForKey:@"user_pic"]]];
            [tableVw_side reloadData];
        }

    }
    else
    {
        user_id =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"];

        
        if ((user_id.length==0)||([user_id isEqualToString:@"null"])||(user_id==[NSNull class])||([user_id isEqualToString:@"(null)"])||([user_id isEqualToString:@"<null>"])||([user_id isEqualToString:@"<nil>"]))
        {
            NSLog(@"user_id is null");
        }
        else
        {
            NSLog(@"user_id %@",user_id);

            [self ShowProfileImage];

        }

    }

}

-(void)ShowProfileImage
{
    user_id =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"];

    if ((user_id.length==0)||([user_id isEqualToString:@"null"])||(user_id==[NSNull class])||([user_id isEqualToString:@"(null)"])||([user_id isEqualToString:@"<null>"])||([user_id isEqualToString:@"<nil>"]))
    {
        NSLog(@"user_id is null");
    }
    else
    {
        NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"http://pay-us.co/payusadmin/webservices/userAds?"]];
        NSString *str= [NSString stringWithFormat:@"user_id=%@",user_id];
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
            NSLog(@"Pofile Data %@",KAppDelegate.Arr_profileData);
        }
        if([[json objectForKey:@"user_pic"] isEqual:nil])
        {
            profileImage.image=[UIImage imageNamed:@"sidebar-profile-img"];
        }
        else
        {
            NSString *str_postcode = [json valueForKey:@"post_code"];
            [[NSUserDefaults standardUserDefaults]setObject:str_postcode forKey:@"enter_postcode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            profileImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_pic"]]];
            [tableVw_side reloadData];
        }

        
    }

  }

#pragma mark  Table delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProfileView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 170)];
    ProfileView.backgroundColor=[UIColor colorWithRed:30.0/255 green:44.0/255 blue:96.0/255 alpha:1.0f];
    profileImage.layer.cornerRadius=profileImage.frame.size.height/2;
    profileImage.clipsToBounds = YES;
    
    ProfileView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    profileImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;

    [ProfileView addSubview:profileImage];
    return ProfileView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 170.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView setSeparatorColor:[UIColor clearColor]];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sidebar-divider"]];
    [tableView setSeparatorColor:color];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_KeyAndValue count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.scrollEnabled = NO;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [sideView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor=[UIColor colorWithRed:30.0/255 green:44.0/255 blue:96.0/255 alpha:1.0f];
    cell.imageView.image=[UIImage imageNamed:[[arr_KeyAndValue objectAtIndex:indexPath.row] valueForKey:@"image"]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[arr_KeyAndValue  objectAtIndex:indexPath.row ] valueForKey:@"title"] ];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0)
    {
        switch ([indexPath row])
        {
             case 0:
            {
                AdvertismentVc *adverTismentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"advertismentVC"];
                adverTismentVC.title = [NSString stringWithFormat:@"Demo #%ld-%ld", (long)indexPath.section, (long)indexPath.row];
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controllers = [NSArray arrayWithObject:adverTismentVC];
                navigationController.viewControllers = controllers;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
                break;
                
            case 1:
            {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AdPost"];
                PostAdvertismentVC *PostAdverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostAdvertisment"];
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controllers = [NSArray arrayWithObject:PostAdverVC];
                navigationController.viewControllers = controllers;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                
            }
                break;
                
            case 2:
            {
//                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AdPost"];
                AffiliateViewController *AffiliateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AffiliateViewController"];
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controllers = [NSArray arrayWithObject:AffiliateViewController];
                navigationController.viewControllers = controllers;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                
            }
                break;
                
            case 3:
            {

                AccountVC *accountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"accountVC"];
                accountVC.title = [NSString stringWithFormat:@"Demo #%ld-%ld", (long)indexPath.section, (long)indexPath.row];
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controllers = [NSArray arrayWithObject:accountVC];
                navigationController.viewControllers = controllers;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

                
            }
                break;
                
            case 4:
            {
                HelpVC *helpvc = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controllers = [NSArray arrayWithObject:helpvc];
                navigationController.viewControllers = controllers;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

            }
                break;
            case 5:
            {
                BOOL checkNet = [[proxyService sharedProxy] checkReachability];
                if(checkNet == TRUE)
                {
                    [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
                
                [self Logout];
                }
                else
                {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }

            }
                break;
                
                default:
                break;
        }
    }
}

-(void)Logout
{
    user_id =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"];
    
    if ((user_id.length==0)||([user_id isEqualToString:@"null"])||(user_id==[NSNull class])||([user_id isEqualToString:@"(null)"])||([user_id isEqualToString:@"<null>"])||([user_id isEqualToString:@"<nil>"]))
    {
        NSLog(@"user_id is null");
    }
    else
    {
        NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",liveurl,KRemovedevicetoken]];
        NSString *str= [NSString stringWithFormat:@"user_id=%@",user_id];
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
            
            [[proxyService sharedProxy] hideActivityIndicatorInView];
   
        }
        if ([[json objectForKey:@"status"]integerValue]==1)
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"login"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
            
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies])
            {
                NSString* domainName = [cookie domain];
                NSRange domainRange = [domainName rangeOfString:@"facebook.com"];
                if(domainRange.length > 0)
                {
                    [storage deleteCookie:cookie];
                }
            }
            
            /*[FBSession.activeSession closeAndClearTokenInformation];
            [FBSession.activeSession close];
            [FBSession setActiveSession:nil];*/
            
            ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:loginVC];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        
    }
    
}

@end