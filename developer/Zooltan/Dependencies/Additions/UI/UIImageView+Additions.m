//
//  UIImageView(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

+ (UIImageView*) withResizableImage: (UIImage*) image
                          capInsets: (UIEdgeInsets) insets
                       resizingMode: (UIImageResizingMode) mode
{
    UIImageView* imageView = [UIImageView new];
    imageView.image = [image resizableImageWithCapInsets: insets resizingMode: mode];
    return imageView;
}

- (CGRect) frameForImageAspectFit
{
    return [self frameForImageAspectFit: self.image];
}

- (CGRect) frameForImageAspectFit: (UIImage*) image
{
    if (!image)
        return CGRectZero;

    float imageRatio = image.size.width / image.size.height;
    float viewRatio  = self.frame.size.width / self.frame.size.height;
    if (imageRatio < viewRatio)
    {
        float scale = self.frame.size.height / image.size.height;
        float width = scale * image.size.width;
        float topLeftX = (self.frame.size.width - width) * 0.5;
        return CGRectMake(topLeftX, 0, width, self.frame.size.height);
    }
    else
    {
        float scale = self.frame.size.width / image.size.width;
        float height = scale * image.size.height;
        float topLeftY = (self.frame.size.height - height) * 0.5;
        return CGRectMake(0, topLeftY, self.frame.size.width, height);
    }
}

@end