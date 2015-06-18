//
//  dismissDetailTransition.m
//  PhotoApp
//
//  Created by Kuralai on 18.06.15.
//  Copyright (c) 2015 Assel Yelyubayeva. All rights reserved.
//

#import "dismissDetailTransition.h"

@implementation dismissDetailTransition
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *detailVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [UIView animateWithDuration:0.3 animations:^{
        detailVC.view.alpha=0.0;
    } completion:^(BOOL finished) {
        [detailVC.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}
@end
