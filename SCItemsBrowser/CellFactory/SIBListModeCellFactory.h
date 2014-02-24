#import <Foundation/Foundation.h>

@class SCItem;
@class SCItemListBrowser;
@class UITableViewCell;

@protocol SCItemCell;

/**
 You must implement this protocol in order to construct cells and provide their reuse identifiers for the SCItemListBrowser controller. Typically, the cells should be children of SCItemListCell class.
 
 You should not invoke dequeueReusableCellWithIdentifier: explicitly. SCItemListBrowser is responsible for doing so.
 */
@protocol SIBListModeCellFactory <NSObject>

/**
 Constructs a new cell for the level up item.
 
 @param sender SCItemListBrowser controller instance.
 
 @return A new cell.
 */
-(UITableViewCell*)createLevelUpCellForListModeOfItemsBrowser:( SCItemListBrowser* )sender;


/**
 Constructs a new cell for the item cell.
 
 @param sender SCItemListBrowser controller instance.
 @param item An item to be rendered in the given cell.
 
 @return A new cell.
 */
-(UITableViewCell<SCItemCell>*)itemsBrowser:( SCItemListBrowser* )sender
                  createListModeCellForItem:( SCItem* )item;

/**
 Provides the reuse identifier for the level up item.
 
  @param sender SCItemListBrowser controller instance.
 */
-(NSString*)reuseIdentifierForLevelUpCellOfItemsBrowser:( SCItemListBrowser* )sender;

/**
 Provides the reuse identifier for the item cell.
 
  @param sender SCItemListBrowser controller instance.
  @param item An item to be rendered in the given cell.
 */
-(NSString*)itemsBrowser:( SCItemListBrowser* )sender
itemCellReuseIdentifierForItem:( SCItem* )item;

@end
