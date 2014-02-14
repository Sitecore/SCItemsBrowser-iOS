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

-(CGFloat)levelUpCellHeigtAtIndexPath:( NSIndexPath* )indexPath;
-(CGFloat)heightOfCellForItem:( SCItem* )item
                  atIndexPath:( NSIndexPath* )indexPath;

@end
