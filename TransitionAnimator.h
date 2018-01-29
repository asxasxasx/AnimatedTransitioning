//
//  AnimatedTransitionController.h
//  
//
//  Created by Alexander Chasovskikh on 04/03/2017.
//  Copyright © 2017. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypeNA,
    TransitionTypeZoomIn,
    TransitionTypeZoomOut,
    TransitionTypeShiftLeft,
};

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak) UIViewController *presentingVC;

- (instancetype)initWithTransitionType:(TransitionType)type;

@end
