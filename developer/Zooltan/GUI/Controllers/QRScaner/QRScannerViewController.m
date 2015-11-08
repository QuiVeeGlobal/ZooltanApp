 //
//  QRScannerViewController.m
//  Zooltan
//
//  Created by Eugene on 07.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "QRScannerViewController.h"

@interface QRScannerViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
{
    BOOL _isUpdated;
}

@property (nonatomic, weak) IBOutlet UIView *previewView;
@property (nonatomic, weak) IBOutlet UILabel *resultLabel;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, assign) BOOL isReading;

@end

@implementation QRScannerViewController
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    _captureSession = nil;
    _isReading = NO;
    _isUpdated = NO;

    [self startStopReading];
}

- (void)startStopReading {
    
    if (!_isReading) {
        if ([self startReading]) {
            [_resultLabel setText:NSLocalizedString(@"Scanning for QR Code...", nil)];
        }
    }
    else{
        [self stopReading];
    }
    _isReading = !_isReading;
}

- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        STLogError(error);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_previewView.layer.bounds];
    [_previewView.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}

- (void)backWithResult {
    if ([self.delegate respondsToSelector:@selector(QRScannerDidFinishScan)]) {
        [self.delegate QRScannerDidFinishScan];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)stopReading {
    
    
    
    [self performBlock:^{
        
        
        [self updateStatus];
    } afterDelay:1];
    
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = metadataObjects[0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [_resultLabel performSelectorOnMainThread:@selector(setText:)
                                         withObject:[metadataObj stringValue]
                                      waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading)
                                   withObject:nil
                                waitUntilDone:NO];
            
            
            _isReading = NO;
            
//            [self performSelectorOnMainThread:@selector(backWithResult)
//                                   withObject:nil
//                                waitUntilDone:NO];
            
        }
    }
}

#pragma mark - Update Order Status

- (void)updateStatus {
    
    STLogMethod;
    if (_isUpdated) {
        return;
    }
    _isUpdated = YES;
    
    [[Server instance] updateOrder:self.order
                        withStatus:self.order.nextStatus
                           success:^
     {
         [self backWithResult];
         
     } failure:^(NSError *error, NSInteger code) {
         switch (code) {
             case 403: [Utilities showErrorMessage:NSLocalizedString(@"msg.error.403", nil) target:self]; break;
             case 404: [Utilities showErrorMessage:NSLocalizedString(@"msg.error.updateOrder.404", nil) target:self]; break;
             case 409: [Utilities showErrorMessage:NSLocalizedString(@"msg.error.updateOrder.409", nil) target:self]; break;
             default:
                 [Utilities showErrorMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                 break;
         }
     }];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self backWithResult];
}

@end
