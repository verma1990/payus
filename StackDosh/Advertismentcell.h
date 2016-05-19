//
//  Advertismentcell.h
//  StackDosh
//
//  Created by Surender Kumar on 03/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "Haneke.h"


@interface Advertismentcell : UITableViewCell
{
    IBOutlet UIButton *btn_cellSelect;
    IBOutlet UILabel *lbl_heading;
    IBOutlet UILabel *lbl_Discription;
    IBOutlet UIImageView *imageViewAdver;
    IBOutlet UIButton *btnShare;
    
}
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_AdvertList;
@property(nonatomic,retain)UIButton *btn_cellSelect;
@property(nonatomic,retain)UILabel *lbl_heading;
@property(nonatomic,retain)UIImageView *imageViewAdver;
@property(nonatomic,retain)UIButton *btnShare;


@end
