//
//  SelectPackageView.h
//  StackDosh
//
//  Created by Eshan cheema on 9/9/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "proxyService.h"

typedef void (^PackgaeSelectionReturnBlock)(NSMutableArray *strPackageValue) ;
@protocol canPackageSelect;


@interface SelectPackageView : UIView<WebServiceDelegate>
{
    int maximumNumber;
    UIRefreshControl * RefreshControl;
    NSMutableArray  *arrayPotentials;
    NSMutableArray *arrayPotentail;
    NSString *strPotential_form;
    NSString *strPotential_to;
    NSString *strCost;

}


@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *cost;

@property (retain, nonatomic) NSString *txt_postcode;

@property(nonatomic, copy) PackgaeSelectionReturnBlock    packageSelectionReturnBlock;
@property (nonatomic, weak) id<canPackageSelect> delegate;


@property (weak, nonatomic) IBOutlet UILabel *randomNumber;
@property (weak, nonatomic) IBOutlet UILabel *maximumReach;
@property (weak, nonatomic) IBOutlet UILabel *paidReach;

-(void)setUpMethod;
-(void)getdata;
@end
