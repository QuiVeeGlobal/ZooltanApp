//
//  TextFields.h
//  Experts
//
//  Created by Eugene Vegner on 03.09.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TextFieldButtonTypeLeft,
    TextFieldButtonTypeRight,
} TextFieldButtonType;

@protocol TextFieldButtonDelegate;

@interface TextField : UITextField
{
}
@property (nonatomic, assign) id <TextFieldButtonDelegate> buttonDelegate;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong) UIImage *leftIcon;
@property (nonatomic, strong) UIImage *rightIcon;

@property (nonatomic, assign) CALayer *bottomLine;

// Validatoin
- (BOOL)validateEmail;
- (BOOL)validatePassword;

@end

@protocol TextFieldButtonDelegate <NSObject>

@optional
- (void)textField:(TextField *)textField didPressButton:(UIButton *)button;

// Validatoin


@end
