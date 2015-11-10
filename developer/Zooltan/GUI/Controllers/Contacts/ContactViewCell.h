//
//  ContactViewCell.h
//  Zooltan
//
//  Created by Eugene on 20.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactViewCellDelegate;

@interface ContactViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *phone;

@property (nonatomic, assign) id <ContactViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)cellHeight;

@end

@protocol ContactViewCellDelegate <NSObject>

@optional

- (void)contactViewCellDelegateDidPressButton:(UIButton *)button
                                  atIndexPath:(NSIndexPath *)indexPath;

@end
