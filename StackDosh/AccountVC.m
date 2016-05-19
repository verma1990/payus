  //
//   AccountVC.m
//  StackDosh
//
//  Created by Surender Kumar on 05/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "AccountVC.h"
#import "Acountcell.h"
#import "ChangePasswordVC.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "constant.h"
#import "DetailVC.h"
#import "EditProfileVC.h"
#import "WidrawVC.h"
#import "SBJsonParser.h"

@interface AccountVC () {
    NSString *p_email;
    NSString *p_id;
    NSString *p_total_earnings;
    NSString *p_already_withdrawn;
    NSString *p_amount_due;
    
    // Define keys
    NSString *email;
    NSString *total;
    NSString *withdrwn;
    float due;
    
    NSMutableArray *pDetails;
}

@end
@implementation AccountVC


- (void)parseJSON{
    
    NSError *error = nil;

    NSURL *searchURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://payusapp.com/resources/search.php?user_name=%@", email]];
    NSLog(@"Search URL: %@", searchURL);
    
    
    NSData *jsondata = [NSData dataWithContentsOfURL:searchURL];
    
    NSLog(@"%@", [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding]);
    
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
    
    for (NSDictionary *dict in arr) {

        email = dict[@"user_name"];
        total = dict[@"total_earnings"];
        withdrwn = dict[@"already_withdrawn"];
        due =  [total floatValue] - [withdrwn floatValue];
        
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setFloat:[withdrwn floatValue] forKey:@"alreadywithdrawn"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSLog(@"User %@", email);
        NSLog(@"Total %@", total);
        NSLog(@"Withdrawn %@", withdrwn);
        NSLog(@"Amount Due: %f", due);
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseJSON];
    
    email = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
    postList=[[NSMutableArray alloc]init];
    profileimage.layer.cornerRadius=profileimage.frame.size.height/2;
    profileimage.clipsToBounds = YES;
     // btn_changePswd.layer.cornerRadius = 3;
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeDefault];
  
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
    //side drawer open
}

-(void)viewWillAppear:(BOOL)animated
{
    [self showUserPost];
    [proxyService sharedProxy].delegate=self;
    [self parseJSON];
    
}

- (IBAction)TappedOnWidrw:(id)sender
{
    WidrawVC  *obj_widrawVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WthdrawMny"];
    [self.navigationController pushViewController:obj_widrawVC animated:YES];
    
    NSString *valueToSave = lbl_earned.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"newTotal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"NEW TOTAL: %@", [NSString stringWithFormat:@"%@", valueToSave]);
}

- (IBAction)TappedOnback:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

#pragma mark --Edit Profile--
- (IBAction)ChangePassword:(id)sender
{
     EditProfileVC *editProfile=[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    [self.navigationController pushViewController:editProfile animated:YES];
}

#pragma mark --ShowUser Post--
-(void)showUserPost
{
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        NSString *postData= [NSString stringWithFormat:@"%@user_id=%@",KShowPost,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
        
       // NSString *postData= [NSString stringWithFormat:@"%@user_id=170",KShowPost];
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
        [[proxyService sharedProxy] postDataonServer:postData withPostString:@""];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark --TableView Delegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [postList count];    //count number of row from counting array hear cataGorry is An Array
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageViewHeader;
    if(IS_IPHONE5)
    {
          imageViewHeader=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    }
    else if (IS_IPHONE_6)
    {
         imageViewHeader=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 60)];
    }
    else if (IS_IPHONE_6_PLUS)
    {
         imageViewHeader=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 60)];
    }
    imageViewHeader.image=[UIImage imageNamed:@"post-strip-bg"];
    UILabel *lbl_ForHeader=[[UILabel alloc]initWithFrame:CGRectMake(6, 0,280,28)];
    lbl_ForHeader.backgroundColor=[UIColor clearColor];
    lbl_ForHeader.textColor=[UIColor colorWithRed:102.0/255 green:102.0/255 blue:104.0/255 alpha:.9f];
    lbl_ForHeader.font=[UIFont boldSystemFontOfSize:18];
    lbl_ForHeader.text=@"Posts";
    [imageViewHeader addSubview:lbl_ForHeader];
    return imageViewHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Similar to UITableViewCell, but
    static NSString *CellIdentifier = @"CellIdentifier";
     Acountcell *temp=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (temp == nil)
    {
        temp = [[Acountcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Acountcell" owner:temp options:nil];
        temp=[topLevelObjects objectAtIndex:0];
        temp.selectionStyle=UITableViewCellAccessoryNone;
        [temp loaditemwithPostListArray:[postList objectAtIndex:indexPath.row]] ;
    }
    return temp;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailVC *detailVC;
    detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.Arr_adverDetail=[postList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];

        profileimage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[responseDic valueForKey:@"user_pic"]]];
        lbl_userName.text=[NSString stringWithFormat:@"%@ %@",[responseDic valueForKey:@"first_name"],[responseDic valueForKey:@"last_name"]];
       lblAffiliate.text=[NSString stringWithFormat:@"Your Affiliate Code is:%@",[responseDic valueForKey:@"affiliate_code"]];
 
        lbl_earned.text=[NSString stringWithFormat:@"%@",[[responseDic valueForKey:@"totalEarn"]valueForKey:@"totalEarns"]];
    
        lbl_postCount.text=[NSString stringWithFormat:@"%@",[responseDic valueForKey:@"post_count"]];
        postList=[responseDic valueForKey:@"advertisements"];
    
         NSString *str_friends=[responseDic valueForKey:@"friends"];
         [[NSUserDefaults standardUserDefaults]setObject:str_friends forKey:@"userFriends"];
    
    NSString *str_postCode=[responseDic valueForKey:@"post_code"];
    [[NSUserDefaults standardUserDefaults]setObject:str_postCode forKey:@"userPostCode"];
    
        if([postList count]>0){
           [tableView_post reloadData];
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


-(void)savePaymentData
{
    
    NSString *username = email;
    float totalearnings = [total floatValue];
    float amountdue = [total floatValue] - [withdrwn floatValue];
    
    NSString *rawStr = [NSString stringWithFormat:@"user_name=%@&total_earnings=%f&already_withdrawn=%f&amountdue=%f",
                        username,
                        totalearnings,
                        [p_already_withdrawn floatValue],
                        amountdue
                        ];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://payusapp.com/resources/savedata.php?"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
    NSLog(@"%@", responseString);
    
    NSString *success = @"success";
    [success dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%lu", (unsigned long)responseString.length);
    NSLog(@"%lu", (unsigned long)success.length);
}




@end
