#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol SIBListModeAppearance <NSObject>

@optional
-(NSString*)levelHeaderTitleForTableViewSectionOfItemsBrowser:( id )sender;
-(NSString*)levelFooterTitleForTableViewSectionOfItemsBrowser:( id )sender;

-(UIView*)levelHeaderViewForTableViewSectionOfItemsBrowser:( id )sender;
-(UIView*)levelFooterViewForTableViewSectionOfItemsBrowser:( id )sender;

-(CGFloat)levelHeaderHeightForTableViewSectionOfItemsBrowser:( id )sender;
-(CGFloat)levelFooterHeightForTableViewSectionOfItemsBrowser:( id )sender;

-(CGFloat)itemsBrowser:( id )sender
levelUpCellHeigtAtIndexPath:( NSIndexPath* )indexPath;


-(CGFloat)itemsBrowser:( id )sender
   heightOfCellForItem:( SCItem* )item
           atIndexPath:( NSIndexPath* )indexPath;

@end
