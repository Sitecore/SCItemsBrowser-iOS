#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol SIBListModeAppearance <NSObject>

@optional
-(NSString*)levelHeaderTitleForTableViewSection;
-(NSString*)levelFooterTitleForTableViewSection;

-(UIView*)levelHeaderViewForTableViewSection;
-(UIView*)levelFooterViewForTableViewSection;

-(CGFloat)levelHeaderHeightForTableViewSection;
-(CGFloat)levelFooterHeightForTableViewSection;

@end
