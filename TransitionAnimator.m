//
//  AnimatedTransitionController.m
//  
//
//  Created by Alexander Chasovskikh on 04/03/2017.
//  Copyright © 2017. All rights reserved.
//

#import "TransitionAnimator.h"
#import "AnimatedView.h"

#define TRANSITION_DURATION 0.25f
#define TRANSITION_SCALE_DOWN 0.5f
#define TRANSITION_SCALE 1.5f

@interface TransitionAnimator ()
//@property (strong, nonatomic) UIViewController *presentingVC;
@property (nonatomic) TransitionType type;
@end

@implementation TransitionAnimator

- (instancetype)initWithTransitionType:(TransitionType)type {
    self = [self init];
    if (self) {
        self.type = type;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return TRANSITION_DURATION;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self animateTransition:transitionContext forTransitionType:self.type];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext forTransitionType:(TransitionType)type {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    fromVC.view.frame = containerView.bounds;
    toVC.view.frame = containerView.bounds;
    
    switch (type) {
        case TransitionTypeZoomIn: {
            [containerView addSubview:toVC.view];
            toVC.view.alpha = 0.0f;
            [self applyScale:TRANSITION_SCALE toView:toVC.view];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowAnimatedContent
                             animations:^{
                                 fromVC.view.alpha = 0.0f;
                                 [self applyScale:TRANSITION_SCALE_DOWN toView:fromVC.view];
                                 
                                 toVC.view.alpha = 1.0f;
                                 toVC.view.transform = CGAffineTransformIdentity;
                                 [self applyScale:1 toView:toVC.view];
                             }
                             completion:^(BOOL finished) {
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
        }
            break;
        case TransitionTypeZoomOut: {
            [containerView insertSubview:toVC.view atIndex:0];
            toVC.view.alpha = 0.0f;
            [self applyScale:TRANSITION_SCALE_DOWN toView:toVC.view];
            [self applyScale:1 toView:fromVC.view];
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowAnimatedContent
                             animations:^{
                                 fromVC.view.alpha = 0.0f;
                                 [self applyScale:TRANSITION_SCALE toView:fromVC.view];
                                 
                                 toVC.view.alpha = 1.0f;
                                 [self applyScale:1 toView:toVC.view];
                             }
                             completion:^(BOOL finished) {
                                 [self applyScale:1 toView:fromVC.view];
                                 [fromVC.view removeFromSuperview];
                                 if (self.presentingVC) {
                                     [containerView.superview addSubview:toVC.view];
                                 }
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
        }
            break;
        case TransitionTypeShiftLeft: {
            [containerView insertSubview:toVC.view belowSubview:fromVC.view];
            toVC.view.alpha = 0.0f;
            [self applyScale:TRANSITION_SCALE_DOWN toView:toVC.view];
            [self applyScale:1 toView:fromVC.view];
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowAnimatedContent
                             animations:^{
                                 fromVC.view.alpha = 0.0f;
                                 [self applyTranslation:CGVectorMake(-100, 0) toView:fromVC.view];
                                 
                                 toVC.view.alpha = 1.0f;
                                 [self applyScale:1 toView:toVC.view];
                             }
                             completion:^(BOOL finished) {
                                 [self applyScale:1 toView:fromVC.view];
                                 [fromVC.view removeFromSuperview];
                                 if (self.presentingVC) {
                                     [containerView.superview addSubview:toVC.view];
                                 }
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
        }
            break;
        default: {
            [containerView addSubview:toVC.view];
            toVC.view.alpha = 0.0f;
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowAnimatedContent
                             animations:^{
                                 fromVC.view.alpha = 0.0f;
                                 toVC.view.alpha = 1.0f;
                                 toVC.view.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished) {
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
        }
            break;
    }
}

- (void)applyScale:(CGFloat)scale toView:(UIView *)view {
    CGAffineTransform transform = (scale == 1)?CGAffineTransformIdentity:CGAffineTransformMakeScale(scale, scale);
    
    AnimatedView *animatedView = nil;
    for (AnimatedView *subview in view.subviews) {
        if ([subview isKindOfClass:[AnimatedView class]]) {
            animatedView = subview;
            break;
        }
    }
    if (animatedView) {
        animatedView.transform = transform;
    }
    else {
        view.transform = transform;
    }
}

- (void)applyTranslation:(CGVector)vector toView:(UIView *)view {
    view.transform = CGAffineTransformMakeTranslation(vector.dx, vector.dy);
}

@end
