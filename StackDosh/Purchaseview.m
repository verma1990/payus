//
//  Purchaseview.m
//  StackDosh
//
//  Created by Surender on 04/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#define STANDARD_COLOR [UIColor colorWithRed:0.00 green:0.50 blue:1.00 alpha:1.0]
#define PREMIUM_COLOR [UIColor colorWithRed:0.18 green:0.67 blue:0.59 alpha:1.0]
#define PRO_COLOR [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0]

#import "Purchaseview.h"

@interface Purchaseview () {
    NSInteger highScore;
}

@end

@implementation Purchaseview
@synthesize post_to_purchase,isFromAccountDetail;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"PayPal";
    
    highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"noOfUsersInArea"];
    
    NSLog(@"Number of Users in Post Code: %li", (long)highScore);

    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Onbeat Limited.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    self.successView.hidden = YES;
    //self.environment = PayPalEnvironmentProduction;
    self.environment = PayPalEnvironmentSandbox;
    //self.environment = PayPalEnvironmentNoNetwork;


    [self.menuContainerViewController setPanMode:MFSideMenuPanModeDefault];
    arrkeyandvalue = [[NSMutableArray alloc]init];
    if (KAppDelegate.isPromoCodeApplied==YES)
    {
        tier_Array = [[NSMutableArray alloc]initWithObjects:@"14.99",@"19.99",@"24.99", nil];

    }else{
        tier_Array = [[NSMutableArray alloc]initWithObjects:@"6.99",@"11.99",@"16.99", nil];

    }
    reach_Array = [[NSMutableArray alloc]initWithObjects:@"1500 to 3000 people",@"3000 to 6000 people", @"6000 to 10000 people",  nil];
      shares_Array = [[NSMutableArray alloc]initWithObjects:@"5",@"10", @"15", nil];
    
    for (int index=0;index<[tier_Array count];index++)
    {
        NSDictionary *arr_Dic=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[shares_Array objectAtIndex:index],[reach_Array objectAtIndex:index],[tier_Array objectAtIndex:index],Nil]  forKeys:[NSArray arrayWithObjects:@"sharing",@"reaching",@"pricing",Nil]];
        [arrkeyandvalue addObject:arr_Dic];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [PayPalMobile preconnectWithEnvironment:self.environment];
    
    if (post_to_purchase.length>0)
    {
        done_button.hidden = NO;
        side_bar_button.hidden = YES;
    }
    else
    {
        side_bar_button.hidden = NO;

        done_button.hidden = YES;
    }
//    [self webServiceForget_plans];
}

-(void)webServiceForget_plans
{
    [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         @"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]
                                         }];
    
    
    [[AppManager sharedManager] getDataForUrl:@"http://pay-us.co/payusadmin/webservices/user_plans?"
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         // Get response from server
         NSLog(@"%@",responseObject);
         
         if ([[responseObject valueForKey:@"status"]integerValue]==1)
         {
             myAlertView1 = [[UIAlertView alloc] initWithTitle:@"Pay Us!" message:@"You have already purchased a plan." delegate:self cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
             myAlertView1.tag=123;
             
             [myAlertView1 show];

         }
         else
         {
             
         }
         
         [[proxyService sharedProxy] hideActivityIndicatorInView];
     }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", error);
         
         [[proxyService sharedProxy] hideActivityIndicatorInView];
         
         alert(@"Message", @"Server error");
         
     }];
}

-(IBAction)Done_button:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)Drawer_button:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];

}
#pragma mark --TableView Delegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tier_Array count];    //count number of row from counting array hear cataGorry is An Array
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Similar to UITableViewCell, but
    static NSString *CellIdentifier = @"CellIdentifier";
    PurchaseCell *temp=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (temp == nil)
    {
        temp = [[PurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PurchaseCell" owner:temp options:nil];
        temp=[topLevelObjects objectAtIndex:0];
        temp.selectionStyle=UITableViewCellAccessoryNone;
        
        [temp loaditemwithPostListArray:[arrkeyandvalue objectAtIndex:indexPath.row]] ;
        [temp.Buy_Button setTag:indexPath.row];
        [temp.Buy_Button addTarget:self action:@selector(Buy_Button:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row == 0) {
            temp.plan_Label.text = @"Standard Plan";
            temp.plan_Label.textColor = STANDARD_COLOR;
            temp.minimum_Reach_Label.textColor = STANDARD_COLOR;
            temp.reach_Label.textColor = STANDARD_COLOR;
            temp.price_Label.backgroundColor = STANDARD_COLOR;
            temp.backgroungimage.layer.cornerRadius = 8;
            [temp.backgroungimage.layer setBorderColor: [STANDARD_COLOR CGColor]];
            [temp.backgroungimage.layer setBorderWidth: 3.0];
        } else if (indexPath.row == 1) {
            temp.plan_Label.text = @"Premium Plan";
            temp.plan_Label.textColor = PREMIUM_COLOR;
            temp.minimum_Reach_Label.textColor = PREMIUM_COLOR;
            temp.reach_Label.textColor = PREMIUM_COLOR;
            temp.price_Label.backgroundColor = PREMIUM_COLOR;
            temp.backgroungimage.layer.cornerRadius = 8;
            [temp.backgroungimage.layer setBorderColor: [PREMIUM_COLOR CGColor]];
            [temp.backgroungimage.layer setBorderWidth: 3.0];
        } else if (indexPath.row == 2) {
            temp.plan_Label.text = @"Professional Plan";
            temp.plan_Label.textColor = PRO_COLOR;
            temp.minimum_Reach_Label.textColor = PRO_COLOR;
            temp.reach_Label.textColor = PRO_COLOR;
            temp.price_Label.backgroundColor = PRO_COLOR;
            temp.backgroungimage.layer.cornerRadius = 8;
            [temp.backgroungimage.layer setBorderColor: [PRO_COLOR CGColor]];
            [temp.backgroungimage.layer setBorderWidth: 3.0];
        }

    }
    return temp;
}

#pragma mark -- Buy Button--
-(void)Buy_Button:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    Buytag = sender.tag;
    moneytag =sender.tag;
    if (Buytag==0)
    {
        Buytag =1;
    }
    else if (Buytag==1)
    {
        Buytag =2;

    }
    else if (Buytag==2)
    {
        Buytag =3;
        
    }
    else if (Buytag==3)
    {
        Buytag =4;
        
    }
    else if (Buytag==4)
    {
        Buytag =5;
        
    }
    
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {

   [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you want to buy this plan?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy", nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark Alertview Delegates :-

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog(@"%ld",(long)moneytag);
       
      money = [[arrkeyandvalue objectAtIndex:moneytag] valueForKey:@"pricing"];

        [self pay];

    }
    else if(myAlertView1.tag==1)
    {
        if (buttonIndex==0)
        {
            if (post_to_purchase.length>0)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                PostAdvertismentVC *obj_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PostAdvertisment"];
                [self.navigationController pushViewController:obj_vc animated:YES];
            }
        }
        
    }
    else if (myAlertView1.tag==123)
    {
        PostAdvertismentVC *obj_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PostAdvertisment"];
        [self.navigationController pushViewController:obj_vc animated:YES];
    }

}

#pragma mark - webServiceForProfileView
-(void)webServiceForsend_productid
{
    
    [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         @"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"],
                                         @"plan_id":[NSString stringWithFormat:@"%ld",(long)Buytag],
                                         @"transaction_id":Paypal_id
                                         }];
    
    
    [[AppManager sharedManager] getDataForUrl:@"http://pay-us.co/payusadmin/webservices/purchase_plans?"
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         // Get response from server
         NSLog(@"%@",responseObject);
         
         if ([[responseObject valueForKey:@"status"]integerValue]==1)
         {
                        
             myAlertView1 = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You have successfully purchased the plan." delegate:self cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
             myAlertView1.tag=1;
             
             [myAlertView1 show];

         }
         else
         {
             alert(@"Message", @"something went wrong please try again.");

         }
         
         [[proxyService sharedProxy] hideActivityIndicatorInView];
     }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", error);
         
         [[proxyService sharedProxy] hideActivityIndicatorInView];
         
         alert(@"Message", @"Server error");
         
     }];
}
#pragma mark --payment function--
- (void)setPayPalEnvironment:(NSString *)environment
{
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

- (void)pay
{
    self.resultText = nil;
    PayPalItem *item1 = [PayPalItem itemWithName:@"Post"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:money]
                                    withCurrency:@"GBP"                                         withSku:nil];
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"GBP";
    payment.shortDescription = @"Post";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable){
        
    }
    
    NSLog(@"Pyament %@",payment);
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc]initWithPayment:payment configuration:self.payPalConfig delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}


#pragma mark PayPalPaymentDelegate methods
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)
paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    //NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    // NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    Paypal_id=[[completedPayment.confirmation valueForKey:@"response"]valueForKey:@"id"];
    
    NSLog(@"PAYPAL ID: %@", Paypal_id);
    
    [self webServiceForsend_productid];
    
    [[NSUserDefaults standardUserDefaults]setObject:Paypal_id forKey:@"Paypal_id"];
    
    
    
}
#pragma mark - Authorize Future Payments
- (IBAction)getUserAuthorizationForFuturePayments:(id)sender
{
    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
    [self presentViewController:futurePaymentViewController animated:YES completion:nil];
}

#pragma mark PayPalFuturePaymentDelegate methods
- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    // NSLog(@"PayPal Future Payment Authorization Success!");
    self.resultText = [futurePaymentAuthorization description];
    [self showSuccess];
    
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    //  NSLog(@"PayPal Future Payment Authorization Canceled");
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    // NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}
#pragma mark - Authorize Profile Sharing

- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
    
    NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
    
    PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:self.payPalConfig delegate:self];
    [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}

#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    //NSLog(@"PayPal Profile Sharing Authorization Success!");
    self.resultText = [profileSharingAuthorization description];
    [self showSuccess];
    
    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
{
    // NSLog(@"PayPal Profile Sharing Authorization Canceled");500
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    // NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}

#pragma mark - Helpers
- (void)showSuccess
{
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}


#pragma mark --AlertView Delegete--

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
