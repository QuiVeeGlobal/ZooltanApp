//
//  PackagePhotoViewController.m
//  Zooltan
//
//  Created by Alex Sorokolita on 12.11.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "PackagePhotoViewController.h"
#import "CreateViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PackagePhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    AVCaptureVideoPreviewLayer *_previewLayer;
    AVCaptureSession *_captureSession;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomLabelConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraPreviwHeigh;

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIView *cameraPreview;

@property (weak, nonatomic) UIImagePickerController *picker;

@end

@implementation PackagePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeCamera];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone 4
            self.cameraPreviwHeigh.constant = self.view.width-20;
            self.topLabelConstr.constant = 5;
            self.buttomLabelConst.constant = 5;
            self.btnConst.constant = 5;
        }
        else if(result.height == 568)
        {
            //iPhone 5
            self.cameraPreviwHeigh.constant = self.view.width;
            self.btnConst.constant = 20;
        }
        else if(result.height == 667)
        {
            // iPhone 6
            self.cameraPreviwHeigh.constant = self.view.width;
        }
        else if(result.height == 736)
        {
            // iPhone 6 Plus
            self.cameraPreviwHeigh.constant = self.view.width;
            self.topLabelConstr.constant = 50;
        }
    }
}

- (void)initializeCamera
{
    //-- Setup Capture Session.
    _captureSession = [[AVCaptureSession alloc] init];
    
    //-- Creata a video device and input from that Device.  Add the input to the capture session.
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(device == nil)
        assert(0);
    
    //-- Add the device to the session.
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if(error)
        assert(0);
    
    [_captureSession addInput:input];
    
    //-- Configure the preview layer
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.cameraPreviwHeigh.constant = self.view.width;
    
    [_previewLayer setFrame:CGRectMake(0, 0,
                                       self.cameraPreview.frame.size.width,
                                       self.cameraPreviwHeigh.constant)];
    
    //-- Add the layer to the view that should display the camera input
    [self.cameraPreview.layer addSublayer:_previewLayer];
    
    //-- Start the camera
    [_captureSession startRunning];
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
    self.picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.picker.showsCameraControls = NO;
    
    [self.picker takePicture];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imagePreview.image = info[UIImagePickerControllerOriginalImage];
}

- (IBAction)skipAction:(id)sender
{
    CreateViewController *createViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateViewController"];
    [self.navigationController pushViewController:createViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
