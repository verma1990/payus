//
//  AccountVC.h
//  StackDosh
//
//  Created by Surender Kumar on 05/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"
#import "AsyncImageView.h"

@interface AccountVC : UIViewController<WebServiceDelegate>
{
    IBOutlet UITableView *tableView_post;
    NSMutableArray *postList;
    IBOutlet UIImageView *profileimage;
    IBOutlet UILabel *lbl_userName;
    IBOutlet UILabel *lbl_earned;
    IBOutlet UILabel *lbl_postCount;
    IBOutlet UIButton *btn_changePswd;
    
    __weak IBOutlet UILabel *lblAffiliate;
}

- (IBAction)TappedOnWidrw:(id)sender;
- (IBAction)TappedOnback:(id)sender;
- (IBAction)ChangePassword:(id)sender;


@end
