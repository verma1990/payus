//
//  DetailVC.h
//  StackDosh
//
//  Created by Surender Kumar on 03/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "proxyService.h"

@interface DetailVC : UIViewController<WebServiceDelegate>
{
    IBOutlet AsyncImageView *imageViewAdvert;
    IBOutlet UILabel *lbl_title;
    IBOutlet UITextView *txtVw_Disc;
    BOOL sharePost;
    IBOutlet UIButton *btn_share;
    UIAlertView *myAlertView;

    
}
@property(nonatomic,retain)NSMutableArray *Arr_adverDetail;
@property(nonatomic, assign, readwrite) BOOL isFromAdvertisment;
@property(nonatomic,assign)NSInteger facebook_Friends;
@property(nonatomic,retain)NSString *str_earn;

- (IBAction)TappedOnBck:(id)sender;
- (IBAction)TappedOnShare:(id)sender;

@end
