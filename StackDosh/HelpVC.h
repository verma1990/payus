//
//  HelpVC.h
//  StackDosh
//
//  Created by Surender on 24/03/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"

@interface HelpVC : UIViewController<WebServiceDelegate>
{
    
    IBOutlet UIWebView *HelpWebView;
}

@end
