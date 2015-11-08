//
//  UIImageView(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Additions)

+ (UIImageView*) withResizableImage: (UIImage*) image
                          capInsets: (UIEdgeInsets) insets
                       resizingMode: (UIImageResizingMode) mode;

- (CGRect) frameForImageAspectFit;
- (CGRect) frameForImageAspectFit: (UIImage*) image;

@end