
 //
//  PostAdverti0smentVC.m
//  StackDosh
//
//  Created by Surender Kumar on 05/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "PostAdvertismentVC.h"
#import "constant.h"
#import "proxyService.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import <CoreLocation/CoreLocation.h>
#import "AdvertismentVc.h"
#import "PayPalMobile.h"
#import "IQKeyboardManager.h"
#import "SelectPackageView.h"
#import "AppManager.h"
#import "RKDropdownAlert.h"


@interface PostAdvertismentVC ()
{
    IBOutlet UIView     *view_preview;
    NSString            *strPotentialFrom;
    NSString            *strPotentialTo;
    UIAlertView         *myAlertView1;
    BOOL                isTappedLocation;
    IBOutlet UILabel    *lblSelectedPackage;

}

@property (weak, nonatomic) IBOutlet UITextField *txt_title;
@property (weak, nonatomic) IBOutlet UITextField *txt_descripton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;




@end

@implementation PostAdvertismentVC
@synthesize isFromAccountDetail;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arr_filterCty=[[NSMutableArray alloc]init];
    arr_allPostcode=[[NSMutableArray alloc]init];
    
    [view_preview setHidden:YES];

    CurLoc=NO;
    
    
    pop_View.hidden = YES;
    plan_boool = YES;

    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"AdPost"]==YES)
    {
        [btn_drawer setImage:[UIImage imageNamed:@"back-btn"] forState:UIControlStateNormal];
    }
    else
    {
     [btn_drawer setImage:[UIImage imageNamed:@"sidebar-icon"] forState:UIControlStateNormal];
    }

    
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeDefault];
    if(IS_IPHONE5)
    {
        scrollView_Advers.contentSize=CGSizeMake(scrollView_Advers.frame.size.width, 500);
    }
    else if (IS_IPHONE_6)
    {
        scrollView_Advers.contentSize=CGSizeMake(scrollView_Advers.frame.size.width, 600);
    }
    else if (IS_IPHONE_6_PLUS)
    {
        scrollView_Advers.contentSize=CGSizeMake(scrollView_Advers.frame.size.width, 700);
    }
    
    if (isFromAccountDetail) {
        
        txtField_Title.text=[NSString stringWithFormat:@"%@",[KAppDelegate.Arr_rePostData valueForKey:@"title"]];
        
        txtField_Disc.text=[NSString stringWithFormat:@"%@",[KAppDelegate.Arr_rePostData valueForKey:@"description"]];
        txtField_email.text=[NSString stringWithFormat:@"%@",[KAppDelegate.Arr_rePostData valueForKey:@"email"]];
        txtPostCode.text=[NSString stringWithFormat:@"%@",[KAppDelegate.Arr_rePostData valueForKey:@"post_code"]];
        txt_PostCodeOp1.text=[NSString stringWithFormat:@"%@",[KAppDelegate.Arr_rePostData valueForKey:@"optional_postcode1"]];
        txt_PostcodeOp2.text=[NSString stringWithFormat:@"%@",[KAppDelegate.Arr_rePostData valueForKey:@"optional_postcode2"]];
        txt_promoCode.text=[NSString stringWithFormat:@"%@",[KAppDelegate.Arr_rePostData valueForKey:@"promo_code"]];
        
        NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[KAppDelegate.Arr_rePostData  valueForKey:@"image"]]];
        NSData* imageData = [NSData dataWithContentsOfURL:imageUrl];
        [Base64 initialize];
        encryptedString = [Base64 encode:imageData];
        UIImage* image = [UIImage imageWithData:imageData];
        imageViewCam.image = image;

        
        }
    
    [txtField_Disc setLimit:140];
    [txtField_Disc.limitLabel setTextColor:darkBlueColor];
    
    [txtPostCode setLimit:4];
    [txtPostCode.limitLabel setTextColor:[UIColor clearColor]];
    
}
-(IBAction)selectPackageBtnAction:(id)sender
{
    
        SelectPackageView * editView    = [[[NSBundle mainBundle] loadNibNamed:@"SelectPackageView" owner:self options:nil] objectAtIndex:0];
        
     //   editView.delegate=self;
        
        [editView setUpMethod];
    
   // [editView getdata];
       // [tableViewCC setEditing:NO animated:YES];
       // self.navigationItem.rightBarButtonItem=btn_clear;
        
        
        editView.packageSelectionReturnBlock = ^(NSMutableArray * strValue)
        {
            NSLog(@"Data Dict %@", strValue);
            
            if ([strValue count]==0)
            {
                lblSelectedPackage.text=@"";

            }
            else
            {
                strPotentialFrom =[NSString stringWithFormat:@"%@",[strValue objectAtIndex:0]];
                strPotentialTo =[NSString stringWithFormat:@"%@",[strValue objectAtIndex:1]];
                lblSelectedPackage.text=[NSString stringWithFormat:@"You Selected %@",[strValue objectAtIndex:2]];
                
            }
 
                    };
        
        [self.view addSubview:editView];
    
    
}

-(IBAction)backBtnAction:(id)sender
{
    [view_preview setHidden:YES];
}


-(IBAction)previewBtnAction:(id)sender
{
    if (OptPostc==YES)
    {
        
        str_postCodeOP1=txt_PostCodeOp1.text;
        str_postCodeOP2=txt_PostcodeOp2.text;
    }
    else
    {
        if ([txt_PostCodeOp1.text length]==0) {
            txt_PostCodeOp1.text=@"";
        }
        if ([txt_PostcodeOp2.text length]==0) {
            txt_PostcodeOp2.text=@"";
        }
        if ([txt_promoCode.text length]==0) {
            txt_promoCode.text=@"";
        }
        
        str_postCodeOP1=txt_PostCodeOp1.text;
        str_postCodeOP2=txt_PostcodeOp2.text;

    }
    
    //img=[imageViewCam currentImage];
    if([txtField_Title.text length]==0)
    {
        /*[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];*/
        [RKDropdownAlert title:@"Error" message:@"Please enter a title." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:2];
    }
    else if([txtPostCode.text length]==0)
    {
        /*[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a postcode." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];*/
        [RKDropdownAlert title:@"Error" message:@"Please enter a postcode." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:2];
        
    } else if([txtPostCode.text length]>4)
    {
       /* [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please only enter the first part of the postcode." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];*/
        [RKDropdownAlert title:@"Error" message:@"Please only enter the first part of the postcode." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:2];
        
    }
    else if([txtField_Disc.text length]==0)
    {
        /*[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a description." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];*/
        
        [RKDropdownAlert title:@"Error" message:@"Please enter a description." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:2];
        
    }
    else if([txtField_email.text length]==0)
    {
        /*[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter contact information. For example an email, telephone number or a website." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];*/
        
        [RKDropdownAlert title:@"Error" message:@"Please enter contact information. For example an email, telephone number or a website." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:3];
    }
    else if([txtField_Disc.text length]>140)
    {
        /*[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Description should not exceed 140 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];*/
        
        [RKDropdownAlert title:@"Error" message:@"Description should not exceed 140 characters." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:2];
    }

    else if(imageViewCam.image ==nil)
    {
        /*[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please chooses an image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];*/
        
        [RKDropdownAlert title:@"Error" message:@"Please choose an image." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:2];
    }
    
    else
    {
        if (post_code_bool==YES)
        {
            post_code_bool = NO;
        }
        else
        {
            [view_preview setHidden:NO];
            [self.view endEditing:YES];
            self.imageView.image =imageViewCam.image ;

            self.txt_title.text =txtField_Title.text;
            lbl_PreDis.text=txtField_Disc.text;
            txt_global_postcode = txtPostCode.text;
            //self.txt_descripton.text=txtField_Disc.text;
            lbl_contactDetail.text=txtField_email.text;
            if ([txt_promoCode.text length] == 0) {
                lbl_promocode.text = @"PAYUS";
            } else {
                lbl_promocode.text=txt_promoCode.text;
            }
        }
        
       
        
    }
}
#pragma mark - TextField Delegates
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (txtPostCode.text.length>0)
    {
        //[self getPostCode];
        [txtPostCode resignFirstResponder];

    }
    else
    {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField==txtPostCode)
    {
    }
    return YES;
}
-(void)getPostCode
{
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        //http://pay-us.co/payusadmin/webservices/get_user_by_post_code?post_code=145
        NSString *postData= [NSString stringWithFormat:@"post_code=%@",txtPostCode.text];
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
        [[proxyService sharedProxy] postDataonServer:Kgetpost withPostString:postData];
    }
    else
    {
        [RKDropdownAlert title:@"Error" message:@"No internet connection." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:2];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [AppManager sharedManager].navCon = self.navigationController;
    [super viewWillAppear:YES];
    if (pay_bool == false)
    {
        
    
    NSString *postCode=[[NSUserDefaults standardUserDefaults]objectForKey:@"Location_postCode"];
    if ([postCode length]!=0) {
        str_CurLocPost = postCode;
        NSString * topDigits = [str_CurLocPost substringToIndex:4];
        txtPostCode.text=topDigits;
    }
    else
    {
        str_CurLocPost = [[NSUserDefaults standardUserDefaults]objectForKey:@"postCode"];
      //  NSString * topDigits = [str_CurLocPost substringToIndex:3];
    }
        
        if (plan_boool==YES)
        {
            plan_boool = NO;
            [self webServiceForget_plans];
        }
        else
        {
            
        }
      
    [proxyService sharedProxy].delegate = self;
    }
    else
    {
        
    }
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
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
    txtVw_Description.inputAccessoryView = toolBar;
    txtField_telephone.inputAccessoryView=toolBar;
        
        
}

- (IBAction)TappedOnBack:(id)sender
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"AdPost"]==YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    }
}

- (IBAction)TappedOnFindLoc:(id)sender
{
    tag=[sender tag];
    if (tag==1) {
        [UIView beginAnimations:@"MoveUP" context:Nil];
        rc = [txtPostCode convertRect:rc toView:scrollView_Advers];
        pt = rc.origin;
        pt.x = 0;
        if(IS_IPHONE5)
        {
            pt.y=420;
        }
        else if (IS_IPHONE_6)
        {
            pt.y=460;
        }
        else if (IS_IPHONE_6_PLUS)
        {
            pt.y=500;
            
        }
        [scrollView_Advers setContentOffset:pt animated:YES];
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:@"MoveUP" context:Nil];
        rc = [txtPostCode convertRect:rc toView:scrollView_Advers];
        pt = rc.origin;
        pt.x = 0;
        if(IS_IPHONE5)
        {
            pt.y=420;
        }
        else if (IS_IPHONE_6)
        {
            pt.y=460;
        }
        else if (IS_IPHONE_6_PLUS)
        {
            pt.y=500;
            
        }
        [scrollView_Advers setContentOffset:pt animated:YES];
        
        [UIView commitAnimations];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==txtField_Disc) {
        
        NSUInteger newLength = [txtField_Disc.text length] + [string length] - range.length;
        return newLength <= 140;

    }
    else if (textField == txtField_Title)
    {
        NSUInteger newLength = [txtField_Disc.text length] + [string length] - range.length;
        return newLength <= 30;
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
        if(textField==txtPostCode)
        {
            self.view.frame=CGRectMake(0, -100, 320, self.view.frame.size.height);
        }
    }
    else if(IS_IPHONE5)
    {
        if(textField==txtPostCode)
        {
            self.view.frame=CGRectMake(0, -100, 320, self.view.frame.size.height);
        }
    }
    else if (IS_IPHONE_6)
    {
        if(textField==txtPostCode)
        {
            self.view.frame=CGRectMake(0, -100, 320, self.view.frame.size.height);
        }
    }
    else if (IS_IPHONE_6_PLUS)
    {
        if(textField==txtPostCode)
        {
            self.view.frame=CGRectMake(0, -100, 320, self.view.frame.size.height);
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
    [txtField_Title resignFirstResponder];
    [txtPostCode resignFirstResponder];
    [txtVw_Description resignFirstResponder];
    [scrollView_Advers setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)TappedOnCamera:(id)sender
{
    [txt_PostCodeOp1 resignFirstResponder];
    [txt_PostcodeOp2 resignFirstResponder];
    [txt_promoCode resignFirstResponder];
    [txtField_Disc resignFirstResponder];
    [txtField_Title resignFirstResponder];
    [txtVw_Description resignFirstResponder];
    [txtPostCode resignFirstResponder];

    
    rc = [btn_camera convertRect:rc toView:scrollView_Advers];
    pt = rc.origin;
    pt.x = 0;
    if(IS_IPHONE5)
    {
        pt.y=150;
    }
    else if (IS_IPHONE_6)
    {
        pt.y=150;
    }
    else if (IS_IPHONE_6_PLUS)
    {
        pt.y=180;
        
    }
    [scrollView_Advers setContentOffset:pt animated:YES];
    [UIView commitAnimations];
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
                obj_ImagePicker.allowsEditing=YES;
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
            obj_ImagePicker.allowsEditing=YES;
            [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
        }
            break;
            
        case 2:
        {
            [scrollView_Advers setContentOffset:CGPointMake(0, 0) animated:YES];

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
    dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"],.1);
    encryptedString = [dataImage base64EncodedStringWithOptions:0];
    obj_imagePick=[info valueForKey:UIImagePickerControllerEditedImage];
    [imageViewCam setContentMode:UIViewContentModeScaleAspectFit];
    imageViewCam.image=obj_imagePick;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --Advertisment Post--
- (IBAction)TappedOnPostAdver:(id)sender
{
        str_CurLocPost =txtPostCode.text;
    KAppDelegate.isPromoCodeApplied=NO;
    
    if (plan_id_String.length>0)
    {
         [self Add_Post_to_Server];
  
    }
    else
    {
                     /*myAlertView1 = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please buy a plan to create a post." delegate:self cancelButtonTitle:nil                                                          otherButtonTitles:@"Ok", nil];
                     [myAlertView1 show];
                     myAlertView1.tag=1002;*/
        [RKDropdownAlert title:@"Error" message:@"Please buy a plan to create a post." backgroundColor:[UIColor redColor] textColor:lightGrayColor time:2];
        [self shakeButton];
    }
  
    

}

-(void)shakeButton{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(select_Plan_btn.center.x - 5,select_Plan_btn.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(select_Plan_btn.center.x + 5, select_Plan_btn.center.y)]];
    [select_Plan_btn.layer addAnimation:shake forKey:@"position"];
}

-(IBAction)Select_Plan_button:(id)sender
{
    plan_boool = YES;
    Purchaseview *obj_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Purchaseview"];
    obj_vc.post_to_purchase = @"post_to_purchase";
    [self.navigationController presentViewController:obj_vc animated:YES completion:nil];
    
}

- (IBAction)ApplyPromoCode:(id)sender
{
    if (txt_promoCode.text.length>0)
    {
        BOOL checkNet = [[proxyService sharedProxy] checkReachability];
        if(checkNet == TRUE)
        {
            [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
            NSString *postData= [NSString stringWithFormat:@"affiliate_code=%@&user_id=%@",txt_promoCode.text,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"]];
            [[proxyService sharedProxy] postDataonServer:KCheckAfliatedCode withPostString:postData];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"error!" message:@"Please enter promocode" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}


-(void)Add_Post_to_Server
{
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Please wait.."];
        
        
        NSString *postData= [NSString stringWithFormat:@"title=%@&post_code=%@&user_id=%@&description=%@&image=%@&email=%@&affiliate_code=%@&optional_postcode1=%@&optional_postcode2=%@&potential_from=0&plan_id=%@",txtField_Title.text,str_CurLocPost,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"],txtField_Disc.text,encryptedString,txtField_email.text,txt_promoCode.text,str_postCodeOP1,str_postCodeOP2,plan_id_String];
        
        pay_bool = true;
        
        
        [[proxyService sharedProxy] postDataonServer:KAderPost withPostString:postData];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    txtField_Title.text=@"";
    txtPostCode.text=@"";
    txtVw_Description.text=@"";
    [btn_camera setImage:[UIImage imageNamed:@"upload-container"] forState:UIControlStateNormal];
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
            post_id_array = [[NSMutableArray alloc]init];
             
            post_id_array = [responseObject valueForKey:@"data"];
             if (post_id_array.count>0)
             {
                 select_Plan_btn.hidden = YES;
                 plan_id_String = [NSString stringWithFormat:@"%@",[[post_id_array objectAtIndex:0]valueForKey:@"plan_id"]];
             }
             else
             {
                 select_Plan_btn.hidden = NO;

             }
             
         }
         else
         {
             select_Plan_btn.hidden = NO;
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

#pragma mark - WebService Delegates
-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    
    if ([str_service isEqualToString:KCheckAfliatedCode])
    {
        int Status=[[responseDic valueForKey:@"success"] floatValue];
        if(Status ==1)
        {
            [applyBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            KAppDelegate.isPromoCodeApplied=YES;
        }
        else if(Status ==0)
        {
            [applyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            KAppDelegate.isPromoCodeApplied=NO;
            
            myAlertView1 = [[UIAlertView alloc] initWithTitle:@"Message" message:@"invalid Affiliate code." delegate:nil cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
            [myAlertView1 show];
        }
       
    }
    else
    {
        int Status=[[responseDic valueForKey:@"status"] floatValue];
        if(Status ==1)
        {
            int atLeast = [[responseDic valueForKey:@"totalUser"] intValue];
            
            [[NSUserDefaults standardUserDefaults] setInteger:atLeast forKey:@"noOfUsersInArea"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *message_string = [NSString stringWithFormat:@"There is %i users in that post code.", atLeast];
            
        }
        else if (Status==0)
        {
            
            myAlertView1 = [[UIAlertView alloc] initWithTitle:@"Message" message:[responseDic valueForKey:@"msg"] delegate:self cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
            myAlertView1.tag=1;
            
            [myAlertView1 show];
            
        }
        else if (Status==2)
        {
            OptPostc=NO;
            OptPostc=YES;
        }
        else if (Status==4)
        {
            //the post has been successfully created and has been posted for users to share
            
            myAlertView1 = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"The post has been successfully created and has been posted for users to share." delegate:self cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
            myAlertView1.tag=14;
            
            [myAlertView1 show];
            
            
        }
        else if (Status==5)
        {
            myAlertView1 = [[UIAlertView alloc] initWithTitle:@"Message" message:[responseDic valueForKey:@"msg"] delegate:self cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
            myAlertView1.tag=1;
            
            [myAlertView1 show];
        }

        
    }
    
}

#pragma mark --Get Current Location PostalCode--
- (IBAction)TappedOnLocation:(id)sender
{
    str_CurLocPost = [[NSUserDefaults standardUserDefaults]objectForKey:@"postCode"];
    NSString * topDigits = [str_CurLocPost substringToIndex:3];
      txtPostCode.text=topDigits;
     isTappedLocation=YES;
}

- (IBAction)TappedOnCurrentloc:(id)sender
{
    if(CurLoc==NO)
    {
        [btn_check setBackgroundImage:[UIImage imageNamed:@"checkbox-active"] forState:UIControlStateNormal];
        
        CurLoc=YES;
    }
    else
    {
        [btn_check setBackgroundImage:[UIImage imageNamed:@"checkbox-empty"] forState:UIControlStateNormal];
        txtPostCode.text=@"";
        CurLoc=NO;
    }
}



#pragma mark --AlertView Delegete--
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((myAlertView1.tag==1)) {
        
        if (buttonIndex==0)
        {
            txtField_Title.text=@"";
            txtPostCode.text=@"";
            txtVw_Description.text=@"";
            //  [btn_camera setImage:[UIImage imageNamed:@"upload-container"] forState:UIControlStateNormal];
            imageViewCam.image=[UIImage imageNamed:@"upload-container"];
            AdvertismentVc *adverTismentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"advertismentVC"];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:adverTismentVC];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

        }
    }
    else if (myAlertView1.tag==1002)
    {
        if (buttonIndex==0)
        {
            txtField_Title.text=@"";
            txtPostCode.text=@"";
            txtVw_Description.text=@"";
            imageViewCam.image=[UIImage imageNamed:@"upload-container"];
   

        }
    }
    else if (myAlertView1.tag==14)
    {
        if (buttonIndex==0)
        {
             AdvertismentVc *adverTismentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"advertismentVC"];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:adverTismentVC];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }

   
    else
    {
        if(alertView==alert_money)
        {
            if (buttonIndex==0)
            {
                
            }
            else
            {
                
            }
        }
    
    }
}

-(void)failToGetResponseWithError:(NSError *)error
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
