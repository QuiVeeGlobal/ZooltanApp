//
//  TestViewViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 7/7/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "LegalInformationViewController.h"
#import "UserAgreementViewController.h"
#import "PolicyViewController.h"
#import "TermsViewController.h"
#import "InformationCell.h"

@interface LegalInformationViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, InformationCellDelegate>

@end

@implementation LegalInformationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return 2;
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
    
    return cell;
}

- (void)informationCellDidPressButton:(UIButton *)button
                          atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        PolicyViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"PolicyViewController"];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    if (indexPath.row == 1)
    {
        TermsViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
