//
//  ForgotPassWordVC.m
//  StackDosh
//
//  Created by Surender Kumar on 06/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "ForgotPassWordVC.h"
#import "constant.h"
@interface ForgotPassWordVC ()
@end

@implementation ForgotPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [proxyService sharedProxy].delegate = self;
    txt_email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your email address" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (IBAction)TappedOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
      [UIView setAnimationDuration:0.3];
    if(textField==txt_email)
    {
        [self moveUP:txt_email];
    }
    [UIView commitAnimations];
       return YES;
}

#pragma mark --TextField Delegate --
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_email){
        [textField  resignFirstResponder];
         [self movedown];
    }
    return YES;
}
#pragma mark  View Animation
-(void)moveUP:(UITextField *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    
    
    if(IS_IPHONE4)
    {
        if(textField==txt_email)
        {
            self.view.frame=CGRectMake(0, -100, 320, self.view.frame.size.height);
        }
    }
    else if(IS_IPHONE5)
    {
        if(textField==txt_email)
        {
            self.view.frame=CGRectMake(0, -100, 320, self.view.frame.size.height);
        }
    }
    else if (IS_IPHONE_6)
    {
        if(textField==txt_email)
        {
            self.view.frame=CGRectMake(0, -100, 375, self.view.frame.size.height);
        }
    }
    else if (IS_IPHONE_6_PLUS)
    {
        if(textField==txt_email)
        {
            self.view.frame=CGRectMake(0, -100, 414, self.view.frame.size.height);
        }
    }
    [UIView commitAnimations];
}

-(void)movedown
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    
    if(IS_IPHONE4)
    {
        self.view.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    else if(IS_IPHONE5)
    {
        self.view.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6)
    {
        self.view.frame=CGRectMake(0, 0, 375, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6)
    {
        self.view.frame=CGRectMake(0, 0, 414, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_email resignFirstResponder];
    [self movedown];
}

#pragma mark --Email Validation
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark --Post parameter
- (IBAction)TappedOnForgotPaswd:(id)sender
{
    if([txt_email.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Email cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if (![self validateEmailWithString:txt_email.text])
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter valid email id." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else
    {
        BOOL checkNet = [[proxyService sharedProxy] checkReachability];
        if(checkNet == TRUE)
        {
            NSString *postData=[NSString stringWithFormat:@"%@username=%@",KForgotPswd,txt_email.text];
            [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
            [[proxyService sharedProxy] postDataonServer:postData withPostString:@""];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
}


#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
     [[proxyService sharedProxy] hideActivityIndicatorInView];
    if([[responseDic valueForKey:@"message"] isEqualToString:@"Email does not exist"])
    {
        [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:[responseDic valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        txt_email.text=@"";
    }
    else
    {
         [self.navigationController popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
