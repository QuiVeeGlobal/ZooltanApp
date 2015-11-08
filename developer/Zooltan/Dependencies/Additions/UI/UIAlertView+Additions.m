//
//  UIAlertView+Additions.m
//  Dependencies
//
//  Created by Eugene Vegner on 25.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "UIAlertView+Additions.h"

@implementation UIAlertView (Additions)

+ (id) showAlertWithTitle: (NSString*) aTitle message: (NSString*) aMessage delegate: (id<UIAlertViewDelegate>) aDelegate
        cancelButtonTitle: (NSString*) cancelButtonTitle otherButtonTitles: (NSString*)otherButtonTitles, ...
{
    UIAlertView* alert = [[self alloc] initWithTitle: aTitle
                                             message: aMessage
                                            delegate: aDelegate
                                   cancelButtonTitle: cancelButtonTitle
                                   otherButtonTitles: nil];
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString* arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
        [alert addButtonWithTitle: arg];
    va_end(args);
    [alert show];
    return alert;
}

+ (id) showProgressAlertWithTitle: (NSString*) aTitle message: (NSString*) aMessage
                         delegate: (id<UIAlertViewDelegate>) aDelegate
                cancelButtonTitle: (NSString*) cancelButtonTitle
               otherButtonTitles :(NSString *)otherButtonTitles, ...
{
    aMessage = [aMessage stringByAppendingString: @"\n\n\n\n"];
    UIAlertView* alert = [[self alloc] initWithTitle: aTitle
                                             message: aMessage
                                            delegate: aDelegate
                                   cancelButtonTitle: cancelButtonTitle
                                   otherButtonTitles: nil];
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString* arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
        [alert addButtonWithTitle: arg];
    va_end(args);
    
    // Create the activityIndicator and add it to the alert
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(139.0f - 18.0f, 60.0f, 37.0f, 37.0f);
    [alert addSubview: activityView];
    [activityView startAnimating];
    [alert show];
    return alert;
}

@end
