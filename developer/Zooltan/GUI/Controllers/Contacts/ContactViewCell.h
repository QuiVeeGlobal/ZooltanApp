//
//  ContactViewCell.h
//  Zooltan
//
//  Created by Eugene on 20.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *phone;

@end
