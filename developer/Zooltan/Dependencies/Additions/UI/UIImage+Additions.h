//
//  UIImage(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Additions)

@property (nonatomic, assign) CGFloat aspectRatio;

+ (UIImage*) imageFromCache: (NSString*) imageName;
+ (id) viewWithImageName: (NSString*) name;
- (BOOL) saveToCache: (NSString*) imageName asRetina: (BOOL) saveAsRetina;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)blurWithRadius:(NSNumber *)radius;

@end