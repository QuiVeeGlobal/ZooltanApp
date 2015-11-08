//
//  ContactsViewController.m
//  Zooltan
//
//  Created by Eugene on 20.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactViewCell.h"

@interface ContactsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactViewCell.className
                                                            forIndexPath:indexPath];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
