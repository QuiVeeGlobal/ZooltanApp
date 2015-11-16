//
//  PackagePhotoView.m
//  Zooltan
//
//  Created by Alex Sorokolita on 13.11.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "PhotoViewerViewController.h"

@interface PhotoViewerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *packegeImage;

@end

@implementation PhotoViewerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"package.png"]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    imgView.center = self.view.center;
    imgView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [self.view addSubview:imgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
