//
//  Acountcell.h
//  StackDosh
//
//  Created by Surender Kumar on 05/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "Haneke.h"
@interface Acountcell : UITableViewCell
{
    
    IBOutlet UIImageView *imageViewPost;
    IBOutlet UILabel *lbl_post;
    IBOutlet UILabel *postName;
}
@property(nonatomic,retain)UILabel *postName;
@property(nonatomic,retain)UILabel *lbl_post;
@property(nonatomic,retain)UIImageView *imageViewPost;
-(void)loaditemwithPostListArray:(NSMutableArray *)arr_PoststList;
@end
