//
//  ViewController.m
//  PhotoApp
//
//  Created by Kuralai on 17.06.15.
//  Copyright (c) 2015 Assel Yelyubayeva. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollectionViewCell.h"
#import <SimpleAuth/SimpleAuth.h>
#import "DetailViewController.h"
#import "PresentDetailTransition.h"
#import "dismissDetailTransition.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken=[userDefaults objectForKey:@"accessToken"];
    if(self.accessToken==nil){
        [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
            self.accessToken=responseObject[@"credentials"][@"token"];
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            NSLog(@"New");
        } ];
    } else{
        NSLog(@"using prev");
    }
    [self downloadImages];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void) downloadImages{
    NSURLSession *session =[NSURLSession sharedSession];
    NSString *urlString =[[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/cats/media/recent?access_token=%@", self.accessToken];
//    NSLog(@"%@",urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //NSLog(@"Response is: %@", response);
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        self.photos=responseDictionary[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [task resume];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.photos count];
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *photo = self.photos[indexPath.item];
    cell.photo=photo;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *photo = self.photos[indexPath.item];
  //  NSLog(@"%d", (int)indexPath.item);
    DetailViewController *vc =[DetailViewController new];
    vc.modalPresentationStyle=UIModalPresentationCustom;
    vc.photo=photo;
    vc.transitioningDelegate=self;
    [self presentViewController:vc animated:YES completion:nil];
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PresentDetailTransition new];
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [dismissDetailTransition new];
}
@end
