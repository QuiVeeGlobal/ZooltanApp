//
//  ContactsViewController.m
//  Zooltan
//
//  Created by Eugene on 20.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactViewCell.h"
#import <MoABContactsManager/MoABContactsManager.h>

#define border_Width 1
#define kIconSize 20
#define layerCornerRadius 2.5;

@interface ContactsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TextFieldButtonDelegate, MoABContactsManagerDelegate>
{
    TextField *searchField;
}

@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) MoContact *selectedContact;

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MoABContactsManager sharedManager] setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES]]];
    [[MoABContactsManager sharedManager] setFieldsMask:MoContactFieldFirstName | MoContactFieldLastName | MoContactFieldPhones | MoContactFieldThumbnailProfilePicture | MoContactFieldAddress];
    [[MoABContactsManager sharedManager] setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadContacts];
}

- (UIView *)setHeaderView
{
    if (!searchField)
    {
        searchField = [[TextField alloc] init];
        searchField.frame = CGRectMake(0, 0, self.tableView.width, 35);
        searchField.delegate = self;
        searchField.font = [Fonts setOpenSansWithFontSize:14];
        searchField.backgroundColor = [Colors whiteColor];
        searchField.textColor = [Colors lightGrayColor];
        searchField.tintColor = [Colors yellowColor];
        searchField.layer.borderColor = [Colors lightGrayColor].CGColor;
        searchField.layer.borderWidth = border_Width;
        searchField.edgeInsets = UIEdgeInsetsMake(0, kIconSize+15, 0, 0);
        searchField.placeholder = NSLocalizedString(@"Name or phone", nil);
        //serchField.returnKeyType = UIReturnKeySearch;
        searchField.returnKeyType = UIReturnKeyDone;
        [searchField addSubview:[self setIconWithImage:[UIImage imageNamed:@"searchIcon"]frame:CGRectMake(10, searchField.height/2-kIconSize/2, kIconSize, kIconSize)]];
        
        [self addCornerRadius:searchField];
        
        searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                         target:self
                                                                                         action:@selector(cancelAction)];
        
        keyboardToolbar.items = @[cancelBarButton];
        [keyboardToolbar setTintColor:[UIColor blackColor]];
        [keyboardToolbar sizeToFit];
        searchField.inputAccessoryView = keyboardToolbar;
        
        [searchField addTarget:self action:@selector(searchFieldDidChangeValue)
             forControlEvents:UIControlEventEditingChanged];
    }
    
    return searchField;
}

- (UIImageView *)setIconWithImage:(UIImage *)image frame:(CGRect)frame
{
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = image;
    icon.frame = frame;
    
    return icon;
}

- (void)addCornerRadius:(UIView *)view
{
    view.layer.cornerRadius = layerCornerRadius;
    view.clipsToBounds = YES;
}

#pragma mark - Load Contacs

- (void)loadContacts
{
    [[MoABContactsManager sharedManager] contacts:^(ABAuthorizationStatus authorizationStatus, NSArray *contacts, NSError *error) {
        
        if (error)
            NSLog(@"Error = %@", [error localizedDescription]);
        else {
            if (authorizationStatus == kABAuthorizationStatusAuthorized) {
                _contacts = contacts;
                [self.tableView reloadData];
            }
            else
                NSLog(@"No permissions!");
        }
    }];
}

#pragma mark - MoABContactsManagerDelegate

- (BOOL)moABContatsManager:(MoABContactsManager *)contactsManager shouldIncludeContact:(MoContact *)contact
{
    return YES;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self setHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactViewCell.className
                                                            forIndexPath:indexPath];
    
    MoContact *contact = _contacts[indexPath.row];
    
    [cell.name setText:contact.fullName];
    
    if (contact.thumbnailProfilePicture)
        [cell.photo setImage:contact.thumbnailProfilePicture];
    else
        [cell.photo setImage:[UIImage imageNamed:@"no_image"]];
    
    if ([contact.phonesValues count] > 0)
        [cell.phone setText:[NSString stringWithFormat:@"%@", contact.phonesValues[0]]];
    else
        [cell.phone setText:@""];
    
    return cell;
}

#pragma mark - IBAction
#pragma mark -

- (void) cancelAction
{
    [self lowerKeyboard];
}

- (void) lowerKeyboard
{
    [searchField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
#pragma mark -

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)searchFieldDidChangeValue
{
    NSLog(@"textFieldDidChangeValue: %@", searchField.text);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self loadContacts];
    });
}

@end
