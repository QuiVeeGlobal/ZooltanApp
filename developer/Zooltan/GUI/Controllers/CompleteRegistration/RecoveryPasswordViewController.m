//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "RecoveryPasswordViewController.h"


@interface RecoveryPasswordViewController () <TextFieldButtonDelegate, UITextFieldDelegate>
{
}

@property (weak, nonatomic) IBOutlet TextField *phoneRecField;

@property (nonatomic, weak) IBOutlet UIButton *sendBtn;

@end

@implementation RecoveryPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configureView
{
    [super configureView];
    
    [self setBottomLine:self.phoneRecField];
    
    [self addCornerRadius:self.sendBtn];
}

- (void) addCornerRadius:(UIButton *) btn
{
    btn.layer.cornerRadius = 2.5;
    btn.clipsToBounds = YES;
    btn.backgroundColor = [Colors yellowColor];
}

- (void) setBottomLine:(TextField *) textField
{
    textField.tintColor = [Colors yellowColor];
    
    textField.textColor = [Colors whiteColor];
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    CALayer *bottomLine = [CALayer layer];
    CGFloat borderWidth = 1;
    bottomLine.borderColor = [Colors yellowColor].CGColor;
    bottomLine.frame = CGRectMake(0, textField.height-borderWidth, textField.width, textField.height);
    bottomLine.borderWidth = borderWidth;
    [textField.layer addSublayer:bottomLine];
    textField.clipsToBounds = YES;
    textField.layer.masksToBounds = YES;
    textField.bottomLine = bottomLine;
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) sendPhoneAction:(UIButton *)sender
{
}

#pragma mark - UITextFieldDelegate
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return true;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
