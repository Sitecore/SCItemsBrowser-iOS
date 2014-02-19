#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

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
-(NSString*)levelHeaderTitleForTableViewSectionOfItemsBrowser:( id )sender;


/**
 Sets the title to the footer of the only table view section. If levelFooterViewForTableViewSectionOfItemsBrowser: is specified this one will be ignored.
 See tableView:titleForFooterInSection: for details.
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return header title. It will be forwarded to tableView:titleForFooterInSection:
 */
-(NSString*)levelFooterTitleForTableViewSectionOfItemsBrowser:( id )sender;


/**
 Custom view for header. Will be adjusted to default or specified header height.
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return A custom view for the section header. It will be forwarded to tableView:viewForHeaderInSection:
 */
-(UIView*)levelHeaderViewForTableViewSectionOfItemsBrowser:( id )sender;


/**
 Custom view for footer. Will be adjusted to default or specified footer height.
 
 @param sender An instance of the SCItemListBrowser controller.
 
 @return A custom view for the section footer. It will be forwarded to viewForFooterInSection:
 */
-(UIView*)levelFooterViewForTableViewSectionOfItemsBrowser:( id )sender;


/**
 
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return
 */
-(CGFloat)levelHeaderHeightForTableViewSectionOfItemsBrowser:( id )sender;


/**
 
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return
 */
-(CGFloat)levelFooterHeightForTableViewSectionOfItemsBrowser:( id )sender;



/**
 
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return
 */
-(CGFloat)itemsBrowser:( id )sender
levelUpCellHeigtAtIndexPath:( NSIndexPath* )indexPath;



/**
 
 
 @param sender An instance of the SCItemListBrowser controller
 
 @return
 */
-(CGFloat)itemsBrowser:( id )sender
   heightOfCellForItem:( SCItem* )item
           atIndexPath:( NSIndexPath* )indexPath;

@end
