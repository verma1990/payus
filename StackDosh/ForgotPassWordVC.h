//
//  ForgotPassWordVC.h
//  StackDosh
//
//  Created by Surender Kumar on 06/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"

@interface ForgotPassWordVC : UIViewController<WebServiceDelegate>
{
    
    IBOutlet UITextField *txt_email;
}
- (IBAction)TappedOnForgotPaswd:(id)sender;
- (IBAction)TappedOnBack:(id)sender;


@end
