//
//  EditProfileVC.m
//  StackDosh
//
//  Created by Surender on 23/03/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "EditProfileVC.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "KGModal.h"
#import "constant.h"
#import "AdvertismentVc.h"

@interface EditProfileVC () {
    BOOL                isTappedLocation;
    UIAlertView *postAlert;
}

@end

@implementation EditProfileVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    Arr_gender=[[NSMutableArray alloc]initWithObjects:@"Male",@"Female", nil];
    [GenderView setHidden:YES];
    
    imageViewProfile.layer.cornerRadius=imageViewProfile.frame.size.height/2;
    imageViewProfile.clipsToBounds = YES;
    
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];

    [self showUserPost];
    
    [txt_location setLimit:4];
    [txt_location.limitLabel setTextColor:[UIColor clearColor]];
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"enter_postcode"];
    NSLog(@"SavedPoscode: %@", savedValue);
    
    if (!savedValue) {
        txt_location.enabled = YES;
        txt_location.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"1st Part of Postcode" attributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}];
    } else {
        txt_location.enabled = NO;
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [proxyService sharedProxy].delegate = self;
    txt_firstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txt_lastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txt_gender.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Gender" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    

    NSString *postCode=[[NSUserDefaults standardUserDefaults]objectForKey:@"Location_postCode"];
    if ([postCode length]!=0) {
        str_CurLocPost = postCode;
        NSString * topDigits = [str_CurLocPost substringToIndex:4];
        txt_location.text=topDigits;
    }
    else
    {
        str_CurLocPost = [[NSUserDefaults standardUserDefaults]objectForKey:@"postCode"];
    }
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"savedPostcode"];
    NSLog(@"SavedPoscode: %@", savedValue);
    
    if (!savedValue) {
        txt_location.enabled = YES;
        txt_location.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"1st Part of Postcode" attributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}];
    } else {
        txt_location.enabled = NO;
    }


    
}

- (IBAction)TappedOnback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --ShowUser Post--
-(void)showUserPost
{
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        NSString *postData= [NSString stringWithFormat:@"%@user_id=%@",KShowPost,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];;
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
        [[proxyService sharedProxy] postDataonServer:postData withPostString:@""];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark --Gender Action--
- (IBAction)TappedOnGender:(id)sender
{
    [GenderView setHidden:NO];
    [KGModal sharedInstance].showCloseButton=YES;
    [[KGModal sharedInstance] showWithContentView:GenderView andAnimated:YES];
}

#pragma mark --Camera Action Method--
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
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
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
    imagefrom_Gallery = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --Register User--
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
    else if([txt_gender.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Gender cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if([txt_location.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter the 1st part of your postcode." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

    else
    {
        
        BOOL checkNet = [[proxyService sharedProxy] checkReachability];
        if(checkNet == TRUE)
        {
            NSString *postData;

            if (imagefrom_Gallery==YES)
            {
            
            }
            else
            {
                dataImage         = [NSData dataWithContentsOfURL:newImageURL];
                encryptedString                  = [Base64 encode:dataImage];
            }
          
           
             postData= [NSString stringWithFormat:@"id=%@&first_name=%@&last_name=%@&gender=%@&profile_image=%@&post_code=%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"],txt_firstName.text,txt_lastName.text,txt_gender.text,encryptedString,txt_location.text];
            [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
            [[proxyService sharedProxy] postDataonServer:KEditProfile withPostString:postData];
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

#pragma mark --AlertView Delegete--
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView==messageAlertVw)
    {
        if (buttonIndex==0)
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"enter_postcode"];
            NSString *str_postcode = txt_location.text;
            [[NSUserDefaults standardUserDefaults]setObject:str_postcode forKey:@"enter_postcode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AdvertismentVc *adverTismentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"advertismentVC"];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:adverTismentVC];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    } else if (alertView == postAlert){
        UITextField *textField = [postAlert textFieldAtIndex:0];
        NSString *title = textField.text;
        NSLog(@"The name is %@",title);
        NSLog(@"Using the Textfield: %@",[[postAlert textFieldAtIndex:0] text]);
        txt_location.text = title;
        [postAlert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;

    }
}

#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    
    NSLog(@"responds data %@",responseDic);
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    if([[responseDic valueForKey:@"message"] isEqualToString:@"The details has been saved"])
    {
        messageAlertVw=[[UIAlertView alloc]initWithTitle:@"Pay Us!" message:[responseDic valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlertVw show];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfileImage" object:nil];
        NSString *valueToSave = txt_location.text;
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"savedPostcode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
        imageViewProfile.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[responseDic valueForKey:@"user_pic"]]];
                txt_firstName.text=[NSString stringWithFormat:@"%@",[responseDic valueForKey:@"first_name"]];
        txt_lastName.text=[NSString stringWithFormat:@"%@",[responseDic valueForKey:@"last_name"]];
        txt_location.text=[NSString stringWithFormat:@"%@",[responseDic valueForKey:@"post_code"]];
        if (txt_location.text.length>0)
        {
            txt_location.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"1st Part of Postcode" attributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}];
        }

        txt_friends.text=[NSString stringWithFormat:@"%@",[responseDic valueForKey:@"friends"]];

        txt_gender.text=[NSString stringWithFormat:@"%@",[responseDic valueForKey:@"gender"]];
        
        newImageURL=[NSURL URLWithString:[responseDic valueForKey:@"user_pic"]];
        
        NSString *valueToSave = [NSString stringWithFormat:@"%@",[responseDic valueForKey:@"post_code"]];
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"savedPostcode"];
        [[NSUserDefaults standardUserDefaults] synchronize];


    }
}

-(void)failToGetResponseWithError:(NSError *)error
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TappedOnLocation:(id)sender
{
    str_CurLocPost = [[NSUserDefaults standardUserDefaults]objectForKey:@"postCode"];
    NSString * topDigits = [str_CurLocPost substringToIndex:4];
    txt_location.text=topDigits;
    isTappedLocation=YES;
}

@end
