//
//  AnimatablePresentationController.m
//
//
//  Created by Alexander Chasovskih on 21/03/2017.
//  Copyright © 2017. All rights reserved.
//

#import "AnimatablePresentationController.h"
#import "TransitionAnimator.h"

@interface AnimatablePresentationController ()
@property (strong, nonatomic) UIVisualEffectView *dimmingView;
@end

@implementation AnimatablePresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if(self) {
        // Create the dimming view and set its initial appearance.
        self.dimmingView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.dimmingView.alpha = 0.0;
    }
    return self;
}

- (void)presentationTransitionWillBegin {
    // Get critical information about the presentation.
    UIView *containerView = self.containerView;
    UIViewController *presentedViewController = self.presentedViewController;
    // Set the dimming view to the size of the container's
    // bounds, and make it transparent initially.
    self.dimmingView.frame = containerView.bounds;
    self.dimmingView.alpha = 0.0;
    
    // Insert the dimming view below everything else.
    [containerView insertSubview:self.dimmingView atIndex:0];
    
    // Set up the animations for fading in the dimming view.
    if([presentedViewController transitionCoordinator]) {
        [[presentedViewController transitionCoordinator]
         animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>
                                      context) {
             // Fade in the dimming view.
             self.dimmingView.alpha = 1.0;
         } completion:nil];
    }
    else {
        self.dimmingView.alpha = 1.0;
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    // If the presentation was canceled, remove the dimming view.
    if (!completed)
        [self.dimmingView removeFromSuperview];
}

- (void)dismissalTransitionWillBegin {
    // Fade the dimming view back out.
    if([[self presentedViewController] transitionCoordinator]) {
        [[[self presentedViewController] transitionCoordinator]
         animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>
                                      context) {
             // Fade out dimming view
             self.dimmingView.alpha = 0.0;
         } completion:nil];
    }
    else {
        self.dimmingView.alpha = 0.0;
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    // If the dismissal was successful, remove the dimming view.
    if (completed)
        [self.dimmingView removeFromSuperview];
}

@end
