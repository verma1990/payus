//
//  Advertismentcell.m
//  StackDosh
//
//  Created by Surender Kumar on 03/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "Advertismentcell.h"
#import <QuartzCore/QuartzCore.h>

@implementation Advertismentcell
@synthesize imageViewAdver,lbl_heading,btn_cellSelect,btnShare;
- (void)awakeFromNib
{
    // Initialization code
}

-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_AdvertList
{
    lbl_heading.text=[arr_AdvertList valueForKey:@"title"];
    lbl_heading.adjustsFontSizeToFitWidth = YES;
   
     [imageViewAdver hnk_setImageFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"image"]]]];
    lbl_Discription.text=[arr_AdvertList valueForKey:@"description"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
