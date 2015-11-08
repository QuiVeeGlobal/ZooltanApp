


#import <UIKit/UIKit.h>

@protocol ActivDeliveryCellDelegate;

@interface ActivDeliveryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@property (nonatomic, assign) id <ActivDeliveryCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)cellHeight;

@end

@protocol ActivDeliveryCellDelegate <NSObject>

@optional

- (void)activDeliveryCellDidPressButton:(UIButton *)button
                            atIndexPath:(NSIndexPath *)indexPath;

@end