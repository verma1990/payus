//
//  WidrawVC.h
//  StackDosh
//
//  Created by Surender on 30/04/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"

@interface WidrawVC : UIViewController<WebServiceDelegate, UIWebViewDelegate>
{
    
    IBOutlet UITextField *txt_PayPaliD;
}
- (IBAction)TappedOnBack:(id)sender;
- (IBAction)TappedOnSend:(id)sender;

@end
