//
//  PurchaseCell.h
//  StackDosh
//
//  Created by Surender on 05/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseCell : UITableViewCell
{
    IBOutlet UILabel *shares_Label,*minimum_Reach_Label,*price_Label, *plan_Label, *reach_Label;
    IBOutlet UIImageView *backgroungimage;
    IBOutlet UIButton *Buy_Button;
}
@property(nonatomic,strong)UILabel *shares_Label;
@property(nonatomic,strong)UILabel *reach_Label;
@property(nonatomic,strong)UILabel *plan_Label;
@property(nonatomic,strong)UILabel *minimum_Reach_Label;
@property(nonatomic,strong)UILabel *price_Label;
@property(nonatomic,strong)UIImageView *backgroungimage;
@property(nonatomic,strong)UIButton *Buy_Button;

-(void)loaditemwithPostListArray:(NSMutableArray *)arr_PoststList;

@end
