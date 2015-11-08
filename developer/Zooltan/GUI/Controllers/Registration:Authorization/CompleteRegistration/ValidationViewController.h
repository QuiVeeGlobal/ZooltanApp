//
//  ValidationViewController.h
//  Zooltan
//
//  Created by Alex Sorokolita on 07.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "BaseViewController.h"

typedef enum ValidationType : NSUInteger
{
    RegistrationValidation,
    RecoveryValidation
    
} ValidationType;

@interface ValidationViewController : BaseViewController

@property (nonatomic, retain) UserModel *userModel;
@property (nonatomic, assign) ValidationType validationType;

@end
