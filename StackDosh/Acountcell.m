//
//  Acountcell.m
//  StackDosh
//
//  Created by Surender Kumar on 05/01/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "Acountcell.h"

@implementation Acountcell
@synthesize postName,lbl_post,imageViewPost;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loaditemwithPostListArray:(NSMutableArray *)arr_PoststList
{
    postName.text=[arr_PoststList valueForKey:@"title"];
             [imageViewPost hnk_setImageFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_PoststList valueForKey:@"image"]]]];
    lbl_post.text=[arr_PoststList valueForKey:@"description"];
}

@end
