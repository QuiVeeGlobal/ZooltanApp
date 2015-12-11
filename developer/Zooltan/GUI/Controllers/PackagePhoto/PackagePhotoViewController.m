//
//  PackagePhotoViewController.m
//  Zooltan
//
//  Created by Alex Sorokolita on 12.11.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "PackagePhotoViewController.h"
#import "CreateViewController.h"
#import "VLBCameraView.h"

@interface PackagePhotoViewController () <VLBCameraViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previwHeigh;

@property (strong, nonatomic) IBOutlet UIImageView *topLeftView;
@property (strong, nonatomic) IBOutlet UIImageView *topRightView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomLeftView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomRightView;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

@property (strong, nonatomic) UIImage *packageImage;

@property (strong, nonatomic) IBOutlet VLBCameraView *cameraView;

@end

@implementation PackagePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cameraView.delegate = self;
    self.cameraView.allowPictureRetake = YES;
    
    [self removePackageImage:@"package.jpg"];
    
    self.topLeftView.transform = CGAffineTransformMakeRotation(0);
    self.topRightView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.bottomLeftView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.bottomRightView.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone 4
            //self.previwHeigh.constant = self.view.width-20;
            self.topLabel.constant = 5;
            self.photoBtn.constant = 5;
            self.buttomLabel.constant = 5;
        }
        else if(result.height == 568)
        {
            //iPhone 5
            //self.previwHeigh.constant = self.view.width;
            self.photoBtn.constant = 20;
        }
        else if(result.height == 667)
        {
            // iPhone 6
            //self.previwHeigh.constant = self.view.width;
        }
        else if(result.height == 736)
        {
            // iPhone 6 Plus
            //self.previwHeigh.constant = self.view.width;
            self.topLabel.constant = 50;
        }
    }
}

- (IBAction)cameraFlashAction:(id)sender
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (device.torchMode == AVCaptureTorchModeOff) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                //TorchIsOn = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                //TorchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

- (IBAction)takePhotoAction:(id)sender
{
    [[AppDelegate instance] showLoadingView];
    
    self.takePhotoButton.hidden = YES;
    self.skipButton.hidden = YES;
    
    [self.cameraView takePicture];
}

- (void)cameraView:(VLBCameraView *)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary *)info meta:(NSDictionary *)meta
{
    [[AppDelegate instance] hideLoadingView];
    
    self.packageImage = [UIImage imageWithData:UIImagePNGRepresentation(meta[VLBCameraViewMetaOriginalImage])];
    [self savePackageImage];
    
    CreateViewController *createViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateViewController"];
    [self.navigationController pushViewController:createViewController animated:YES];
}

- (void)savePackageImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"package.jpg"];
    NSData *imageData = UIImagePNGRepresentation(self.packageImage);
    [imageData writeToFile:filePath atomically:YES];
    
    NSLog(@"UIImagePNGRepresentation: image size is---->: %lu kb",[imageData length]/1024);
}

- (void)removePackageImage:(NSString *)fileName
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

- (void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error
{
    
}

- (void)cameraView:(VLBCameraView *)cameraView willRekatePicture:(UIImage *)image
{
    
}

- (IBAction)skipAction:(id)sender
{
    self.skipButton.hidden = YES;
    self.skipButton.enabled = NO;
    
    CreateViewController *createViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateViewController"];
    [self.navigationController pushViewController:createViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
