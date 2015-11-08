


#import <UIKit/UIKit.h>

@protocol AdressCelllDelegate;

@interface AdressCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;

@property (nonatomic, assign) id <AdressCelllDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)cellHeight;

@end

@protocol AdressCelllDelegate <NSObject>

@optional

- (void)adressCellDidPressButton:(UIButton *)button
                          atIndexPath:(NSIndexPath *)indexPath;

@end