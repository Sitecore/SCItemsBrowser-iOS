#import <Foundation/Foundation.h>

@class UICollectionViewCell;
@class SCItemGridBrowser;
@protocol SCItemCell;


/**
 You must implement this protocol in order to provide cells for the SCItemGridBrowser controller. Typically, the cells should be inherited from the SCItemGridCell class.
 
 The method implementation should either construct a brand new cell object or follow the instructions below :
 
 1. Register a class or a nib file for the given item
 2. Obtain an item using the dequeueReusableCellWithReuseIdentifier:forIndexPath: method of the UICollectionView.
 */
@protocol SIBGridModeCellFactory <NSObject>

/**
 Provides a new cell for the level up item
 
 @param sender SCItemGridBrowser controller instance.
 
 @return A new cell.
 
 */
-(UICollectionViewCell*)itemsBrowser:( SCItemGridBrowser* )sender
        createLevelUpCellAtIndexPath:( NSIndexPath* )indexPath;


/**
 Constructs a new cell for the item cell.
 
 @param sender SCItemListBrowser controller instance.
 @param item An item to be rendered in the given cell.
 
 @return A new cell.
 */
-(UICollectionViewCell<SCItemCell>*)itemsBrowser:( SCItemGridBrowser* )sender
                       createGridModeCellForItem:( SCItem* )item
                                     atIndexPath:( NSIndexPath* )indexPath;

@end

