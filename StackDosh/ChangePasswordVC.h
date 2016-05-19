//
//  ChangePasswordVC.h
//  StackDosh
//
//  Created by Surender Kumar on 05/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"

@interface ChangePasswordVC : UIViewController<WebServiceDelegate>
{
    IBOutlet UITextField *txt_currentPswd;
    IBOutlet UITextField *txt_newPswd;
    IBOutlet UITextField *txt_cnfrmNewPswd;
}
- (IBAction)TappedOnBack:(id)sender;
- (IBAction)TappedOnChangePswd:(id)sender;

@end
