//
//  WidrawVC.m
//  StackDosh
//
//  Created by Surender on 30/04/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "WidrawVC.h"
#import "constant.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import "RKDropdownAlert.h"

@interface WidrawVC () <SKPSMTPMessageDelegate> {
    
    NSString *theAmountDue;

}

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@end

float total;
float withdrawn;
float due;

@implementation WidrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    txt_PayPaliD.autocorrectionType = UITextAutocorrectionTypeNo;
    _amountLabel.adjustsFontSizeToFitWidth = YES;
    
    total = [[NSUserDefaults standardUserDefaults]
              floatForKey:@"newTotal"];
    withdrawn = [[NSUserDefaults standardUserDefaults]
             floatForKey:@"alreadywithdrawn"];
    due = total - withdrawn;
    
    //[self savePaymentData];

}

- (IBAction)TappedOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
     txt_PayPaliD.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your Paypal address" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.5]}];
    
    txt_PayPaliD.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"savedPaypal"];
    
    _amountLabel.text = [NSString stringWithFormat:@"Amount Available to Withdraw: £%.2f \n(Minimum £1.00. Paypal fees apply)", due];

}

- (IBAction)TappedOnSend:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults] setObject:txt_PayPaliD.text forKey:@"savedPaypal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (due < 1.0f) {
        [RKDropdownAlert title:@"Error" message:@"Please share more posts, you don't have enough money to withdraw yet!" backgroundColor:[UIColor redColor] textColor:lightGrayColor time:3];
    } else {
        [self sendEmailInBackground];
    }
}

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_PayPaliD resignFirstResponder];
    
}

#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    if([[responseDic valueForKey:@"status"] integerValue]==1)
    {
       [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:[responseDic valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:[responseDic valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

-(void)failToGetResponseWithError:(NSError *)error
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) sendEmailInBackground {
    
    SKPSMTPMessage *emailMessage = [[SKPSMTPMessage alloc] init];
    emailMessage.fromEmail = txt_PayPaliD.text;
    emailMessage.toEmail = @"payments@pay-us.co";
    emailMessage.relayHost = @"auth.smtp.1and1.co.uk";
    emailMessage.ccEmail =@"frankie@onbeat.co.uk";
    emailMessage.requiresAuth = YES;
    emailMessage.login = @"payments@pay-us.co";
    emailMessage.pass = @"manager12";
    emailMessage.subject =@"Withdraw Request";
    emailMessage.wantsSecure = YES;
    emailMessage.delegate = self;
    
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          valueForKey:@"username"];

    
    theAmountDue = [NSString stringWithFormat:@"%f", total - withdrawn];

    NSString *messageBody = [NSString stringWithFormat:@"%@ has made a request to withdraw their earnings. \nTheir Paypal address is %@. \nTheir total earings is £%.2f. \nThey have already withdrawn £%.2f \nThey are due £%.2f", username, txt_PayPaliD.text, total, withdrawn, due];
    
    NSDictionary *plainMsg = [NSDictionary
                              dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                              messageBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    emailMessage.parts = [NSArray arrayWithObjects:plainMsg,nil];
    //in addition : Logic for attaching file with email message.
    
    // sending email- will take little time to send so its better to use indicator with message showing sending...
    
    NSString *value = [txt_PayPaliD.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(value.length == 0) {
        // textField is empty
        [RKDropdownAlert title:@"Error" message:@"Please enter your PayPal address." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:2];
    } else {
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
        [emailMessage send];
    }
}

-(void)messageSent:(SKPSMTPMessage *)message{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    
    [self savePaymentData];
    
    [self goBack];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your request has been sent." message:@"You should receive you payment within 7 days." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}
// On Failure
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    // open an alert with just an OK button
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    NSLog(@"delegate - error(%ld): %@", (long)[error code], [error localizedDescription]);
}

-(void)savePaymentData{
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                                   valueForKey:@"username"];
    
    withdrawn = [[NSUserDefaults standardUserDefaults]
                 floatForKey:@"alreadywithdrawn"];

    
    NSString *rawStr = [NSString stringWithFormat:@"user_name=%@&total_earnings=%f&already_withdrawn=%f&amount_due=%f",
                        username,
                        total,
                        total,
                        due
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

- (IBAction)showPayPalFees:(id)sender{
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width,self.view.bounds.size.height)];
    NSString *url=@"https://www.paypal.com/uk/webapps/mpp/paypal-fees";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    [self.view addSubview:webview];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

@end
