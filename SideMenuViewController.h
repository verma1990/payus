//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
#import "proxyService.h"
#import "AsyncImageView.h"

@interface SideMenuViewController : UITableViewController<WebServiceDelegate>
{
    IBOutlet UITableView *sideView;
     NSMutableArray *arr_KeyAndValue;
    NSMutableArray *arr_For_firstSection;
    NSMutableArray *arrImge_ForfirstSection;
    IBOutlet UITableView *tableVw_side;
    UIImageView *profileImage;
    UIView *ProfileView;
    NSString *user_id;
}

@end