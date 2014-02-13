#import <Foundation/Foundation.h>

@protocol SIBListModeAppearance <NSObject>

@optional
-(NSString*)levelHeaderTitleForTableViewSection;
-(NSString*)levelFooterTitleForTableViewSection;

@end
