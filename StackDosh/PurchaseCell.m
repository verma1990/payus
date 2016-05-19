//
//  PurchaseCell.m
//  StackDosh
//
//  Created by Surender on 05/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "PurchaseCell.h"

@implementation PurchaseCell
@synthesize shares_Label,price_Label,minimum_Reach_Label,backgroungimage, plan_Label, Buy_Button, reach_Label;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loaditemwithPostListArray:(NSMutableArray *)arr_PoststList
{
    shares_Label.text=[arr_PoststList valueForKey:@"sharing"];
    minimum_Reach_Label.text=[arr_PoststList valueForKey:@"reaching"];
    price_Label.text=[NSString stringWithFormat:@"Buy Now for £%@",[arr_PoststList valueForKey:@"pricing"]];

}
@end
