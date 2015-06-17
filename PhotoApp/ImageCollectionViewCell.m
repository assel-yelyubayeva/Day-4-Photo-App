




#import "ImageCollectionViewCell.h"
#import "PhotoController.h"

@implementation ImageCollectionViewCell

-(instancetype) initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if(self){
        self.imageView=[UIImageView new];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
-(void) layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame=self.contentView.bounds;
}
-(void) setPhoto:(NSDictionary *)photo{
    _photo=photo;
    [PhotoController imageForPhoto:self.photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image=image;
    }];
}
@end
