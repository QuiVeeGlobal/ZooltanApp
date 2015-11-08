


#import <UIKit/UIKit.h>

@protocol DeliveryCellDelegate;

@interface DeliveryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *bgView;

@property (nonatomic, assign) id <DeliveryCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)cellHeight;

@end

@protocol DeliveryCellDelegate <NSObject>

@optional

- (void)deliveryCellDidPressButton:(UIButton *)button
                      atIndexPath:(NSIndexPath *)indexPath;

@end