//
//  ViewController.h
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum AdressType : NSUInteger
{
    HomeAddress = 0,
    WorkAddress = 1,
    FromAddress = 2,
    ToAddress = 3,
    DestinationAddress = 4,
    
} AddressType;

//typedef enum DirectionType : NSUInteger
//{
//    From = 0,
//    To = 1,
//} DirectionType;

typedef enum CallController : NSUInteger
{
    Profile,
    Create,
    History,
    
} CallController;

@interface FromViewController : BaseViewController

@property (nonatomic, retain) NSString *nanTitle;
@property (nonatomic, assign) AddressType addressType;
//@property (nonatomic, assign) DirectionType directionType;
@property (nonatomic, assign) CallController callController;

@end

