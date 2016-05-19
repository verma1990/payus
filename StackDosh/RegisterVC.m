//
//  RegisterVC.m
//  StackDosh
//
//  Created by Surender Kumar on 02/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "RegisterVC.h"
#import "AdvertismentVc.h"
#import "constant.h"
#import "proxyService.h"
#import "KGModal.h"



@interface RegisterVC ()

@end

@implementation RegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Arr_gender=[[NSMutableArray alloc]initWithObjects:@"Male",@"Female", nil];
    [GenderView setHidden:YES];

    imageViewProfile.layer.cornerRadius=imageViewProfile.frame.size.height/2;
    imageViewProfile.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [proxyService sharedProxy].delegate = self;
    txt_firstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txt_lastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txt_emailAdd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email address" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txt_pass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txt_gender.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Gender" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txt_location.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Location" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txtField_Phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
     txt_location.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"location"];
    
    
    UIToolbar *toolBar;
    if(IS_IPHONE5)
    {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 40)];
    }
    else if (IS_IPHONE_6)
    {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 375, 40)];
    }
    else if (IS_IPHONE_6_PLUS)
    {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 414, 40)];
    }
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.translucent = YES;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:flexSpace,doneButton, nil]];
    
    txtField_Phone.inputAccessoryView = toolBar;
    txtField_Phone.inputAccessoryView=toolBar;
}


-(void)done
{
    [txtField_Phone resignFirstResponder];
    [scrollVw_Reg setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark - TextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.6];
    svos = scrollVw_Reg.contentOffset;
    if(textField==txt_firstName)
    {
        rc = [txt_firstName bounds];
        rc = [txt_firstName convertRect:rc toView:scrollVw_Reg];
    }
    else if(textField==txt_lastName)
    {
        rc = [txt_lastName bounds];
        rc = [txt_lastName convertRect:rc toView:scrollVw_Reg];
    }
    else if(textField==txt_emailAdd)
    {
        rc = [txt_emailAdd bounds];
        rc = [txt_emailAdd convertRect:rc toView:scrollVw_Reg];
    }
    else if(textField==txt_pass)
    {
        rc = [txt_pass bounds];
        rc = [txt_pass convertRect:rc toView:scrollVw_Reg];
    }
    else if(textField==txt_location)
    {
        txt_location.text=@"";
        rc = [txt_location bounds];
        rc = [txt_location convertRect:rc toView:scrollVw_Reg];
    }
    else if(textField==txtField_Phone)
    {
        txtField_Phone.text=@"";
        rc = [txtField_Phone bounds];
        rc = [txtField_Phone convertRect:rc toView:scrollVw_Reg];
    }

    pt = rc.origin;
    pt.x = 0;
    pt.y -= 0;
    [scrollVw_Reg setContentOffset:pt animated:YES];
     [UIView commitAnimations];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_firstName){
        [txt_lastName  becomeFirstResponder];
    }
    else if (textField == txt_lastName){
        [txt_emailAdd becomeFirstResponder];
    }
    else if (textField == txt_emailAdd){
        [txt_pass becomeFirstResponder];
    }
    else if (textField == txt_pass){
        [txt_pass resignFirstResponder];
        [UIView beginAnimations:@"MoveUP" context:Nil];
        [UIView setAnimationDuration:0.6];
        scrollVw_Reg.contentOffset=CGPointMake(0, 0);
        
        [UIView commitAnimations];
        //[self movedown];
    }
    else if (textField == txt_location){
        [txt_location resignFirstResponder];
        [UIView beginAnimations:@"MoveUP" context:Nil];
        [UIView setAnimationDuration:0.6];
        scrollVw_Reg.contentOffset=CGPointMake(0, 0);
        
        [UIView commitAnimations];

    }
    
    else if (textField == txtField_Phone){
        [txtField_Phone resignFirstResponder];
        [UIView beginAnimations:@"MoveUP" context:Nil];
        [UIView setAnimationDuration:0.6];
        scrollVw_Reg.contentOffset=CGPointMake(0, 0);
        
        [UIView commitAnimations];
        
    }

    return YES;
}

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_firstName resignFirstResponder];
    [txt_lastName resignFirstResponder];
    [txt_emailAdd resignFirstResponder];
    [txt_pass resignFirstResponder];
    [txt_DOB resignFirstResponder];
    [txt_gender resignFirstResponder];
    [txt_location resignFirstResponder];
    [txtField_Phone resignFirstResponder];
    
}

#pragma mark --Email Validation--
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark --Action Method--
- (IBAction)TappedOnCamera:(id)sender
{
    UIActionSheet *obj_ActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Photo album", nil), nil];
    [obj_ActionSheet showInView:self.view];
}

#pragma mark  ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *obj_ImagePicker=[[UIImagePickerController alloc]init];
                obj_ImagePicker.delegate=self;
                obj_ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                obj_ImagePicker.editing=NO;
                obj_ImagePicker.videoQuality=UIImagePickerControllerQualityTypeHigh;
                [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
            }
            else
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Pay Us!" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
                [myAlertView show];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController *obj_ImagePicker=[[UIImagePickerController alloc]init];
            obj_ImagePicker.delegate=self;
            obj_ImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            obj_ImagePicker.editing=YES;
            [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark  UIImagePickerController Delegates
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info

{
    dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],.1);
    encryptedString = [dataImage base64EncodedStringWithOptions:0];
    obj_imagePick=[info valueForKey:UIImagePickerControllerOriginalImage];
    CGSize imageSize;
    if(obj_imagePick.size.height>900 && obj_imagePick.size.width>700)
    {
        imageSize = CGSizeMake(500,500);
    }
    else if(obj_imagePick.size.height>960)
    {
        imageSize = CGSizeMake(500,500);
    }
    else if(obj_imagePick.size.width>640)
    {
        imageSize = CGSizeMake(500,500);
    }
    else
    {
        imageSize=CGSizeMake(400,400);
    }
    UIGraphicsBeginImageContext(imageSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.width);
    [obj_imagePick drawInRect:imageRect];
    obj_imagePick = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   imageViewProfile.image=obj_imagePick;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)TappedOnGender:(id)sender
{
    [GenderView setHidden:NO];
    [KGModal sharedInstance].showCloseButton=YES;
    [[KGModal sharedInstance] showWithContentView:GenderView andAnimated:YES];
}

#pragma mark --Register Action--
- (IBAction)TappedOnRegister:(id)sender
{
    if([txt_firstName.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"First name cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if([txt_lastName.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Last name cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if (![self validateEmailWithString:txt_emailAdd.text])
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter a valid Email id." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if([txt_pass.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Password cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if([txt_gender.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Gender cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if([txtField_Phone.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Phone Number cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

    else
    {
        BOOL checkNet = [[proxyService sharedProxy] checkReachability];
        if(checkNet == TRUE)
        {
            NSString *postData= [NSString stringWithFormat:@"firstname=%@&lastname=%@&email=%@&password=%@&usertype=user&dob=%@&gender=%@&image=%@&location=%@&registertype=manual&contact=%@",txt_firstName.text,txt_lastName.text,txt_emailAdd.text,txt_pass.text,txt_DOB.text,txt_gender.text,encryptedString,txt_location.text,txtField_Phone.text];
            [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
            [[proxyService sharedProxy] postDataonServer:kSignUpUser withPostString:postData];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
}

- (IBAction)btnAllClick:(UIButton *)sender
{
    switch ([sender tag]) {
        case 1:
        {
            txt_gender.text=@"Male";
            gender=@"1";
            [[KGModal sharedInstance]hideAnimated:YES];
            [btn_gender setBackgroundColor:[UIColor blackColor]];
            [btn_female setBackgroundColor:[UIColor clearColor]];
        }
            break;
        case 2:
        {
             txt_gender.text=@"Female";
            gender=@"0";
             [[KGModal sharedInstance]hideAnimated:YES];
            [btn_gender setBackgroundColor:[UIColor clearColor]];
             [btn_female setBackgroundColor:[UIColor blackColor]];
        }
            break;
            
           default:
            break;
    }
}


#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    NSLog(@"%@",responseDic);
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    if([[responseDic valueForKey:@"status"] integerValue]==1)
    {
    [[NSUserDefaults standardUserDefaults] setObject:[responseDic valueForKey:@"user_id"] forKey:@"UserId"];
    [[NSUserDefaults standardUserDefaults]setObject:txt_emailAdd.text forKey:@"email"];
    
    [[[UIAlertView alloc] initWithTitle:@"Pay Us!" message:[responseDic valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfileImage" object:nil];
    AdvertismentVc *adverTismentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"advertismentVC"];
      [self.navigationController pushViewController:adverTismentVC animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
