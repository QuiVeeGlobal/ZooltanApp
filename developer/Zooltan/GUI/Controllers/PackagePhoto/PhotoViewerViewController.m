//
//  PackagePhotoView.m
//  Zooltan
//
//  Created by Alex Sorokolita on 13.11.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "PhotoViewerViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface PhotoViewerViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *packageImage;

@end

@implementation PhotoViewerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (IS_COURIER_APP) {
        [self setPackageImageFromUrl:self.order.packageImageUrl];
    }
    
    if (IS_CUSTOMER_APP) {
        UIImageView *packageImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"package.jpg"]]];
        packageImageView.clipsToBounds = YES;
        packageImageView.contentMode = UIViewContentModeScaleAspectFill;
        packageImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        packageImageView.center = self.view.center;
        packageImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        [self.view addSubview:packageImageView];
    }
}

#pragma mark - UserAvatar
#pragma mark -

- (void)setPackageImageFromUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    [self.packageImage setImageWithURLRequest:request
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.packageImage.image = image;
        [self setPackageImageFromImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load image:\nrequest=%@\nresponse=%@\nerror=%@",request,response,[error description]);
    }];
}

- (void)setPackageImageFromImage:(UIImage *)image
{
    self.packageImage.image = image;
    self.packageImage.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
