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
-(void) setPhoto:(NSDictionary *)photo{
    _photo=photo;
    [self downloadImage];
}
-(void) downloadImage{
    NSLog(@"%@", self.photo);
    NSURL *url =[[NSURL alloc] initWithString:self.photo[@"images"][@"thumbnail"][@"url"]];
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //NSLog(@"Response is: %@", response);
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image=image;
        });
        
    }];
    [task resume];

}
@end
