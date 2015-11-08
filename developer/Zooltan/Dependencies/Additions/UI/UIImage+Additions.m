//
//  UIImage(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)
@dynamic aspectRatio;

- (CGFloat) aspectRatio
{
    return self.size.width / self.size.height;
}

+ (id) viewWithImageName: (NSString*) name
{
    UIImageView* imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed: name];
    [imageView sizeToFit];
    return imageView;
}


+ (UIImage*) imageFromCache: (NSString*) imageName
{
    NSString* path = [@"../Library/Caches/" stringByAppendingString: imageName];
    return [UIImage imageNamed: path];
}

- (BOOL) saveToCache: (NSString*) imageName asRetina: (BOOL) saveAsRetina
{
    NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];

    if (saveAsRetina)
    {
        NSString* pathExtension = [imageName pathExtension];
        imageName = [NSString stringWithFormat: @"%@@2x.%@", [imageName stringByDeletingPathExtension], pathExtension];
    }

    NSError* error = nil;
    if (![UIImagePNGRepresentation(self) writeToFile: [cachesDirectory stringByAppendingPathComponent: imageName]
                                             options: NSDataWritingAtomic
                                               error: &error])
    {
        NSLog(@"%@", error);
        return NO;
    }

    return YES;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)blurWithRadius:(NSNumber *)radius
{
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[self CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:radius forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context   = [CIContext contextWithOptions:nil];
    CGRect rect          = [outputImage extent];
    
    // Three lines ensure that the final image is the same size
    rect.origin.x        += (rect.size.width  - self.size.width ) / 2;
    rect.origin.y        += (rect.size.height - self.size.height) / 2;
    rect.size            = self.size;
    
    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:rect];
    UIImage *blurImage       = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
    return blurImage;
}




@end