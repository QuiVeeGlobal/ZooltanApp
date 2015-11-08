//
//  UIAlertView+Additions.h
//  Dependencies
//
//  Created by Eugene Vegner on 25.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Additions)

+ (id) showAlertWithTitle: (NSString*) aTitle
                  message: (NSString*) aMessage
                 delegate: (id<UIAlertViewDelegate>) aDelegate
        cancelButtonTitle: (NSString*) cancelButtonTitle
       otherButtonTitles :(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (id) showProgressAlertWithTitle: (NSString*) aTitle
                          message: (NSString*) aMessage
                         delegate: (id<UIAlertViewDelegate>) aDelegate
                cancelButtonTitle: (NSString*) cancelButtonTitle
               otherButtonTitles :(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
