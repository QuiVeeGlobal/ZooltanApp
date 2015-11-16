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

@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

@property (strong, nonatomic) IBOutlet VLBCameraView *cameraView;

@end

@implementation PackagePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cameraView.allowPictureRetake = YES;
    self.cameraView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeButtons)
                                                 name:@"changeButtons"
                                               object:nil];
    
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

- (void)changeButtons
{
    self.takePhotoButton.hidden = NO;
    
    [self.skipButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.skipButton setTitle:@"SKIP" forState:UIControlStateNormal];
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"package.png"];
    UIImage *packageImage = [UIImage imageWithData:UIImagePNGRepresentation(meta[VLBCameraViewMetaOriginalImage])];
    NSData *data = UIImageJPEGRepresentation(packageImage, 0.8);
    [data writeToFile:path atomically:YES];
    
    NSLog(@"UIImagePNGRepresentation: image size is---->: %lu kb",[data length]/1024);
    
    self.skipButton.hidden = NO;
    [self.skipButton setImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [self.skipButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error
{
    
}

- (void)cameraView:(VLBCameraView *)cameraView willRekatePicture:(UIImage *)image
{
    
}

- (IBAction)skipAction:(id)sender
{
    self.skipButton.enabled = NO;
    CreateViewController *createViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateViewController"];
    [self.navigationController pushViewController:createViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
