//
//  TestViewViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 7/7/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "LegalInformationViewController.h"
#import "UserAgreementViewController.h"
#import "InformationCell.h"

@interface LegalInformationViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, InformationCellDelegate>

@end

@implementation LegalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    [super configureView];
    
    self.navItem.title = NSLocalizedString(@"ctrl.legalInformation.navigation.title", nil);
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:InformationCell.className
                                                        forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (indexPath.row == 0)
        cell.titleLabel.text = NSLocalizedString(@"ctrl.legalInformation.cell.title_0", nil);
    else if (indexPath.row == 1)
        cell.titleLabel.text = NSLocalizedString(@"ctrl.legalInformation.cell.title_1", nil);
    else if (indexPath.row == 2)
        cell.titleLabel.text = NSLocalizedString(@"ctrl.legalInformation.cell.title_2", nil);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UserAgreementViewController *userAgreementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAgreementViewController"];
        [self.navigationController pushViewController:userAgreementViewController animated:YES];
    }
}

- (void)informationCellDidPressButton:(UIButton *)button
                          atIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        UserAgreementViewController *userAgreementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAgreementViewController"];
        [self.navigationController pushViewController:userAgreementViewController animated:YES];
    }
}


@end
