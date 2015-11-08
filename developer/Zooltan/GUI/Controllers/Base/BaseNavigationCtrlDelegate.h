//
//  BaseNavigationCtrlDelegate.h
//  Travel
//
//  Created by Eugene Vegner on 17.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNavigationCtrl.h"
#import "PushAnimation.h"
#import "PopAnimation.h"

@interface BaseNavigationCtrlDelegate : NSObject <UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet BaseNavigationCtrl *navigationController;
@property (strong, nonatomic) PushAnimation *pushAnimation;
@property (strong, nonatomic) PopAnimation *popAnimation;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;


@end
