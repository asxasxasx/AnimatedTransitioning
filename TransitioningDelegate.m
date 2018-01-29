//
//  TransitioningDelegate.m
//  
//
//  Created by Alexander Chasovskih on 21/03/2017.
//  Copyright © 2017. All rights reserved.
//

#import "TransitioningDelegate.h"
#import "TransitionAnimator.h"

@implementation TransitioningDelegate

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[TransitionAnimator alloc] initWithTransitionType:TransitionTypeZoomIn];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[TransitionAnimator alloc] initWithTransitionType:TransitionTypeShiftLeft];
}

@end
