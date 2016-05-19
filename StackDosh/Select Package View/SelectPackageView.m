//
//  SelectPackageView.m
//  StackDosh
//
//  Created by Eshan cheema on 9/9/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "SelectPackageView.h"
#import "constant.h"
#import "proxyService.h"
#import "AppManager.h"

@implementation SelectPackageView
@synthesize packageSelectionReturnBlock;

-(void)setUpMethod
{
    arrayPotentail =[[NSMutableArray alloc]init];
    arrayPotentials =[[NSMutableArray alloc]init];
    [self webServiceForGetPackgae];
}

#pragma mark - webServiceForProfileView
-(void)webServiceForGetPackgae
{
    
    [[proxyService sharedProxy] showActivityIndicatorInView:self withLabel:@"Please wait.."];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
             //http://dev414.trigma.us/onbeat/webservices/adsCost?user_id=1&post_code=g64
                                         @"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"UserId"],
                                         @"post_code":txt_global_postcode
                                         }];

    
    [[AppManager sharedManager] getDataForUrl:@"http://pay-us.co/payusadmin/webservices/adsCost?"
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         // Get response from server
         NSLog(@"%@",responseObject);
         
         arrayPotentials = [responseObject valueForKey:@"data"];
         NSLog(@"%@",arrayPotentials);

         
         strPotential_form=[NSString stringWithFormat:@"%@",[[arrayPotentials lastObject] valueForKey:@"potential_from"]];
         strPotential_to=[NSString stringWithFormat:@"%@",[[arrayPotentials lastObject] valueForKey:@"potential_to"]];
         strCost =[NSString stringWithFormat:@"%@",[[arrayPotentials lastObject] valueForKey:@"cost"]];
         
         if(_slider.value >= 10000.0)
         {
             _cost.text =[NSString stringWithFormat:@"Cost: £%@ to reach %@ and over people.",strCost,strPotential_to];
         }
         else
         {
             _cost.text =[NSString stringWithFormat:@"Cost: £%@ to reach %@ people.",strCost,strPotential_to];
         }
         
         //      strSelectedPackage =@"1";
         
         [arrayPotentail addObject:strPotential_form];
         [arrayPotentail addObject:strPotential_to];
         [arrayPotentail addObject:_cost.text];
         
         _slider.maximumValue = [strPotential_to floatValue];
         
         [_slider setValue:[strPotential_to floatValue]];
         
         [[proxyService sharedProxy] hideActivityIndicatorInView];     }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", error);
         
         [[proxyService sharedProxy] hideActivityIndicatorInView];
         
         alert(@"Error", @"");
         
     }];
    
}


-(IBAction)closeBtnAcion:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)selectBtnAcion:(id)sender
{
    packageSelectionReturnBlock(arrayPotentail);

    [self removeFromSuperview];
}

- (IBAction)sliderValueChanged:(id)sender
{
    
    NSString *strSelectedPackage;
    _paidReach.text = [NSString stringWithFormat:@"Paid Reach: %.f", _slider.value];
    // Set the label text to the value of the slider as it changes
    arrayPotentail =[[NSMutableArray alloc]init];
    
    //NSLog(@"Slider Value is %f", _slider.value);
    _slider.minimumValue = 1.0f;
    
    for (int i=0; i<[arrayPotentials count]; i++)
    {
        strPotential_form=[NSString stringWithFormat:@"%@",[[arrayPotentials objectAtIndex:i] valueForKey:@"potential_from"]];
       strPotential_to=[NSString stringWithFormat:@"%@",[[arrayPotentials objectAtIndex:i] valueForKey:@"potential_to"]];
        strCost =[NSString stringWithFormat:@"%@",[[arrayPotentials objectAtIndex:i] valueForKey:@"cost"]];
        if(_slider.value >= 10000.0)
        {
          //  _cost.text = @"Cost: £10.00 to reach over 10000 people";
            
//            NSString *lastvalue = [NSString stringWithFormat:@"%@",[[arrayPotentials objectAtIndex:lastcount-1] valueForKey:@"potential_to"]];
            
            _cost.text =[NSString stringWithFormat:@"Cost: £%@ to reach over %@ people.",strCost,strPotential_to];
            strSelectedPackage =@"1";
            
            [arrayPotentail addObject:strPotential_form];
            [arrayPotentail addObject:strPotential_to];
            [arrayPotentail addObject:_cost.text];

        }
        else
        {
        
        if(_slider.value >= [strPotential_form floatValue] && _slider.value <= [strPotential_to floatValue])
        {
            _cost.text =[NSString stringWithFormat:@"Cost: £%@ to reach %@ people.",strCost,strPotential_to];
            strSelectedPackage =@"1";
            
            [arrayPotentail addObject:strPotential_form];
            [arrayPotentail addObject:strPotential_to];
            [arrayPotentail addObject:_cost.text];
        }
    }
}
    
     
}


@end
