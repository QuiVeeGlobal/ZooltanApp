

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ActivityIndicator;

@interface Utilities : NSObject
{
    ActivityIndicator *loadingView;
}

+ (void)showErrorMessage:(NSString *)message target:(id)target;
+ (void)showAlertMessage:(NSString*)message target:(id)target;
+ (void)showAlertMessage:(NSString*)message target:(id)target alertTag:(NSInteger)tag;
+ (void)showios7AlertMessage:(NSString*)message target:(id)target alertTag:(NSInteger)tag;
+ (void)showCustomAlertMessage:(NSString*)message target:(id)target alertTag:(NSInteger)tag ;
+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)areValidPassword:(NSString *)password confirmPassword:(NSString*)confirmPassword;
+ (BOOL)doesFileExists:(NSString *)fileName;
+ (NSString*)pathOfFile:(NSString *)fileName;
+ (BOOL)createFile:(NSString *)fileName;
+ (BOOL)isDate:(NSDate *)date1 equalsTo:(NSDate *)date2;
+ (void)showPermissionDialog:(NSString *)title message:(NSString *)message target:(id)target;
+ (NSString*)todaysWeekDay;
+ (NSInteger)maxInArray:(NSArray *)arr;
+ (NSInteger)getWeekDayFromAbbreviation:(NSString *)abb;
+ (NSDate*)date:(NSDate *)date1 withTime:(NSDate *)date2;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2;
+ (NSString*)getGenderAbbrebiation:(NSString *)gender;

+ (NSMutableArray *) parsingString:(NSString *) parsingString;

//// Phone Number
//+ (BOOL)configurePhoneNumberFromTextField:(UITextField *)textField withCharactersInRange:(NSRange)range;
//+ (NSString *)formatPhomeNumber:(NSString *)phoneNumber;

+ (void)getAllContacts;
@end
