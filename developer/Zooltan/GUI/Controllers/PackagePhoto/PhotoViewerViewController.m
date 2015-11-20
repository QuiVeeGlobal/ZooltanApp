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

@property (weak, nonatomic) IBOutlet UIImageView *packageImageView;

@end

@implementation PhotoViewerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.packageImageView.image) {
        if (IS_COURIER_APP) {
            [[AppDelegate instance] showLoadingView];
            [self setPackageImageFromUrl:[NSString stringWithFormat:@"http://%@", self.order.packageImageUrl]];
        }
        
        UIImage *savedImage = [UIImage imageWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"package.jpg"]];
        self.packageImageView.image = savedImage;
        self.packageImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

#pragma mark - PackageImage
#pragma mark -

- (void)setPackageImageFromUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    [self.packageImageView setImageWithURLRequest:request
                                 placeholderImage:nil
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              [[AppDelegate instance] hideLoadingView];
                                              self.packageImageView.image = image;
                                              self.packageImageView.contentMode = UIViewContentModeScaleAspectFit;
                                              
                                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                              NSLog(@"Failed to load image:\nrequest=%@\nresponse=%@\nerror=%@",request,response,[error description]);
                                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
