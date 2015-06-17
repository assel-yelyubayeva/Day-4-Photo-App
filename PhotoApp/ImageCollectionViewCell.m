//
//  ImageCollectionViewCell.m
//  PhotoApp
//
//  Created by Kuralai on 17.06.15.
//  Copyright (c) 2015 Assel Yelyubayeva. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.imageView=[UIImageView new];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame=self.contentView.bounds;
}
@end
