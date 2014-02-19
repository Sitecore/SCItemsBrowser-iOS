#import <Foundation/Foundation.h>

@class SCItem;
@class UITableViewCell;

@protocol SCItemCell;

/**
 You must implement this protocol in order to construct cells and provide their reuse identifiers for the SCItemListBrowser controller.
 
 You should not invoke dequeueReusableCellWithIdentifier: explicitly. SCItemListBrowser is responsible for doing so.
 */
@protocol SIBListModeCellFactory <NSObject>

/**
 Constructs a new cell for the level up item.
 
 @param sender SCItemListBrowser controller instance.
 
 @return A new cell.
 */
-(UITableViewCell*)createLevelUpCellForListModeOfItemsBrowser:( id )sender;


/**
 Constructs a new cell for the item cell.
 
 @param sender SCItemListBrowser controller instance.
 @param item An item to be rendered in the given cell.
 
 @return A new cell.
 */
-(UITableViewCell<SCItemCell>*)itemsBrowser:( id )sender
                  createListModeCellForItem:( SCItem* )item;

/**
 Provides the reuse identifier for the level up item.
 
  @param sender SCItemListBrowser controller instance.
 */
-(NSString*)reuseIdentifierForLevelUpCellOfItemsBrowser:( id )sender;

/**
 Provides the reuse identifier for the item cell.
 
  @param sender SCItemListBrowser controller instance.
  @param item An item to be rendered in the given cell.
 */
-(NSString*)itemsBrowser:( id )sender
itemCellReuseIdentifierForItem:( SCItem* )item;

@end
