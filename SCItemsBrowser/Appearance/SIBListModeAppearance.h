#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SCItemListBrowser;

/**
 Since SCItemListBrowser overrides the UITableViewDelegate and UITableViewDataSource protocols, there should be some way to configure cells appearance.
 
 Override methods of this protocol to forward your values to the UITableView and customize its appearance.
 */
@protocol SIBListModeAppearance <NSObject>

@optional

/**
 Sets the title to the header of the only table view section. If levelHeaderViewForTableViewSectionOfItemsBrowser: is specified this one will be ignored.
 See tableView:titleForHeaderInSection: for details.
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return header title. It will be forwarded to tableView:titleForHeaderInSection:
 */
-(NSString*)levelHeaderTitleForTableViewSectionOfItemsBrowser:( SCItemListBrowser* )sender;


/**
 Sets the title to the footer of the only table view section. If levelFooterViewForTableViewSectionOfItemsBrowser: is specified this one will be ignored.
 See tableView:titleForFooterInSection: for details.
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return header title. It will be forwarded to tableView:titleForFooterInSection:
 */
-(NSString*)levelFooterTitleForTableViewSectionOfItemsBrowser:( SCItemListBrowser* )sender;


/**
 Custom view for header. Will be adjusted to default or specified header height.
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return A custom view for the section header. It will be forwarded to tableView:viewForHeaderInSection:
 */
-(UIView*)levelHeaderViewForTableViewSectionOfItemsBrowser:( SCItemListBrowser* )sender;


/**
 Custom view for footer. Will be adjusted to default or specified footer height.
 
 @param sender An instance of the SCItemListBrowser controller.
 
 @return A custom view for the section footer. It will be forwarded to tableView:viewForFooterInSection:
 */
-(UIView*)levelFooterViewForTableViewSectionOfItemsBrowser:( SCItemListBrowser* )sender;


/**
 Height of the section header.
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return Height of the section header. It will be forwarded to tableView:heightForHeaderInSection:
 */
-(CGFloat)levelHeaderHeightForTableViewSectionOfItemsBrowser:( SCItemListBrowser* )sender;


/**
 Height of the section footer.
 
 @param sender An instance of the SCItemListBrowser controller.
 
 @return Height of the section footer. It will be forwarded to tableView:heightForFooterInSection:
 */
-(CGFloat)levelFooterHeightForTableViewSectionOfItemsBrowser:( SCItemListBrowser* )sender;




/**
 Height of the level up cell.
 
 @param sender An instance of the SCItemListBrowser controller.
 @param indexPath NSIndexPath for the level up cell.
 
 @return Height of the level up cell. It will be forwarded to tableView:heightForRowAtIndexPath:
 */
-(CGFloat)itemsBrowser:( SCItemListBrowser* )sender
levelUpCellHeigtAtIndexPath:( NSIndexPath* )indexPath;



/**
 Height of the item cell. Feel free to make it different for various types of items.
 
 @param sender An instance of the SCItemListBrowser controller.
 @param item An item to be rendered in this cell.
 @param indexPath NSIndexPath for the item cell.
 
 @return Height of the item cell. It will be forwarded to tableView:heightForRowAtIndexPath:
 */
-(CGFloat)itemsBrowser:( SCItemListBrowser* )sender
   heightOfCellForItem:( SCItem* )item
           atIndexPath:( NSIndexPath* )indexPath;

@end
