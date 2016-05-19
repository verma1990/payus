//
//  ChangePasswordVC.m
//  StackDosh
//
//  Created by Surender Kumar on 05/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "constant.h"
#import "proxyService.h"
#import "ViewController.h"

@interface ChangePasswordVC ()
@end

@implementation ChangePasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    txt_currentPswd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txt_newPswd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txt_cnfrmNewPswd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm New Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeDefault];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [proxyService sharedProxy].delegate = self;
}

- (IBAction)TappedOnBack:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];

}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    if(textField==txt_currentPswd)
    {
        [self moveUP:txt_currentPswd];
    }
    else if(textField==txt_newPswd)
    {
        [self moveUP:txt_newPswd];
    }
    else if(textField==txt_cnfrmNewPswd)
    {
        [self moveUP:txt_cnfrmNewPswd];
    }
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_currentPswd){
        [txt_newPswd  becomeFirstResponder];
    }
    else if (textField == txt_newPswd){
        [txt_cnfrmNewPswd becomeFirstResponder];
    }
    else if (textField == txt_cnfrmNewPswd){
        [textField resignFirstResponder];
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
        if(textField==txt_currentPswd)
        {
            self.view.frame=CGRectMake(0, -30, 320, self.view.frame.size.height);
        }
        else if(textField==txt_newPswd)
        {
            self.view.frame=CGRectMake(0, -65, 320, self.view.frame.size.height);
        }
        else if(textField==txt_cnfrmNewPswd)
        {
            self.view.frame=CGRectMake(0, -95, 320, self.view.frame.size.height);
        }
    }
    
    else if(IS_IPHONE5)
    {
        if(textField==txt_currentPswd)
        {
            self.view.frame=CGRectMake(0, -30, 320, self.view.frame.size.height);
        }
        else if(textField==txt_newPswd)
        {
            self.view.frame=CGRectMake(0, -65, 320, self.view.frame.size.height);
        }
        else if(textField==txt_cnfrmNewPswd)
        {
            self.view.frame=CGRectMake(0, -95, 320, self.view.frame.size.height);
        }
    }
    else if (IS_IPHONE_6)
    {
        if(textField==txt_currentPswd)
        {
            self.view.frame=CGRectMake(0, -35, 375, self.view.frame.size.height);
        }
        else if(textField==txt_newPswd)
        {
            self.view.frame=CGRectMake(0, -65, 375, self.view.frame.size.height);
        }
        else if(textField==txt_cnfrmNewPswd)
        {
            self.view.frame=CGRectMake(0, -95, 375, self.view.frame.size.height);
        }
    }
    else if (IS_IPHONE_6_PLUS)
    {
        if(textField==txt_currentPswd)
        {
            self.view.frame=CGRectMake(0, -35, 414, self.view.frame.size.height);
        }
        else if(textField==txt_newPswd)
        {
            self.view.frame=CGRectMake(0, -65, 414, self.view.frame.size.height);
        }
        else if(textField==txt_cnfrmNewPswd)
        {
            self.view.frame=CGRectMake(0, -95, 414, self.view.frame.size.height);
        }
    }
    [UIView commitAnimations];
}

-(void)movedown
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    
    if(IS_IPHONE5)
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
    [txt_cnfrmNewPswd resignFirstResponder];
    [txt_currentPswd resignFirstResponder];
    [txt_newPswd resignFirstResponder];
    [self movedown];
}  

#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    if ([[responseDic valueForKey:@"message"]isEqualToString:@"Password updated"])
    {
        txt_cnfrmNewPswd=nil;
        txt_currentPswd=nil;
        txt_newPswd=nil;

        [[proxyService sharedProxy] hideActivityIndicatorInView];
        [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:[responseDic valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
        ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:loginVC];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if ([[responseDic valueForKey:@"message"]isEqualToString:@"Your old password did not match."])
    {
       [[proxyService sharedProxy] hideActivityIndicatorInView];
        [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:[responseDic valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
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
#                                            pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
