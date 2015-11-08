//
//  TestViewViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 7/7/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "InformationViewController.h"
#import "LegalInformationViewController.h"
#import "UserAgreementViewController.h"
#import "InformationCell.h"

typedef enum : NSUInteger {
    InfoCellTypeFAQ,
    InfoCellTypeLegalInf,
    InfoCellTypeLegalDoc,
    InfoCellTypeTariffs,
    InfoCellTypePrivacyPolicy
} InfoCellType;

@interface Info : NSObject
+ (NSArray *)source;
+ (NSString *)titleByType:(InfoCellType)type;

@end

@implementation Info


+ (NSString *)titleByType:(InfoCellType)type {
    switch (type) {
        case InfoCellTypeFAQ:           return NSLocalizedString(@"generic.FAQ", nil);
        case InfoCellTypeLegalInf:      return NSLocalizedString(@"generic.legalInf", nil);
        case InfoCellTypeLegalDoc:      return NSLocalizedString(@"generic.legalDoc", nil);
        case InfoCellTypeTariffs:       return NSLocalizedString(@"generic.tariffs", nil);
        case InfoCellTypePrivacyPolicy: return NSLocalizedString(@"generic.privacyPolicy", nil);
        default: return @"";
    }
}

+ (NSArray *)source {
    NSMutableArray *array = [NSMutableArray array];
    if (IS_COURIER_APP) {
        
        return @[@(InfoCellTypePrivacyPolicy),
                 @(InfoCellTypeFAQ),
                 @(InfoCellTypeLegalDoc)];
        
    } else {
        
        return @[@(InfoCellTypeLegalInf),
                 @(InfoCellTypeFAQ),
                 @(InfoCellTypeTariffs)];
    }
    return array;
}

@end


@interface InformationViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, InformationCellDelegate>
@property (nonatomic, strong) NSArray *source;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.source = [Info source];
}

- (void)configureView
{
    [super configureView];
    self.navItem.title = NSLocalizedString(@"ctrl.information.navigation.title", nil);
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [InformationCell cellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:InformationCell.className
                                                        forIndexPath:indexPath];
    InfoCellType type = (InfoCellType)[self.source[indexPath.row] integerValue];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.titleLabel.text = [Info titleByType:type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    STLogMethod;
    InfoCellType type = (InfoCellType)[self.source[indexPath.row] integerValue];

    switch (type) {
        case InfoCellTypeLegalInf: {
            LegalInformationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"LegalInformationViewController"];
            [self.navigationController pushViewController:ctr animated:YES];
        } break;
            
        default:
            break;
    }
    
}

- (void)informationCellDidPressButton:(UIButton *)button
                          atIndexPath:(NSIndexPath *)indexPath
{
    STLogMethod;
    InfoCellType type = (InfoCellType)[self.source[indexPath.row] integerValue];
    switch (type) {
        case InfoCellTypeLegalInf: {
            LegalInformationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"LegalInformationViewController"];
            [self.navigationController pushViewController:ctr animated:YES];
        } break;
            
        default:
            break;
    }
    
}

@end
