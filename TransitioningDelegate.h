//
//  TransitioningDelegate.h
//  
//
//  Created by Alexander Chasovskih on 21/03/2017.
//  Copyright © 2017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionAnimator.h"

@interface TransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic) TransitionType type;

@end
