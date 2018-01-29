//
//  AnimatableNavigationControllerDelegate.m
//  
//
//  Created by Alexander Chasovskikh on 06/03/2017.
//  Copyright © 2017. All rights reserved.
//

#import "AnimatableNavigationControllerDelegate.h"
#import "TransitionAnimator.h"

@interface AnimatableNavigationControllerDelegate ()
@end

@implementation AnimatableNavigationControllerDelegate

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    TransitionType type = TransitionTypeShiftLeft;
    if (operation == UINavigationControllerOperationPush) {
        type = TransitionTypeZoomIn;
    }
    else if (operation == UINavigationControllerOperationPop) {
        type = TransitionTypeZoomOut;
    }
    
    TransitionAnimator *ta = [[TransitionAnimator alloc] initWithTransitionType:type];
    return ta;
}

@end
