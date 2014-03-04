#import <Foundation/Foundation.h>

@class UICollectionViewCell;
@class SCItemGridBrowser;
@protocol SCItemCell;


/**
 You must implement this protocol in order to provide cells for the SCItemGridBrowser controller. Typically, the cells should be inherited from the SCItemGridCell class.
 
 The method implementation should either construct a brand new cell object or follow the instructions below :
 
 1. Register a class or a nib file for the given item
 2. Obtain an item using the [UICollectionView dequeueReusableCellWithReuseIdentifier:forIndexPath:] method of the UICollectionView.
 */
@protocol SIBGridModeCellFactory <NSObject>

/**
 Provides a new cell for the level up item
 
 @param sender SCItemGridBrowser controller instance.
 @param indexPath NSIndexPath from the UICollectionViewDataSource. It should be passed to [UICollectionView dequeueReusableCellWithReuseIdentifier:forIndexPath:]
 
 @return A new cell.
 
 */
-(UICollectionViewCell*)itemsBrowser:( SCItemGridBrowser* )sender
        createLevelUpCellAtIndexPath:( NSIndexPath* )indexPath;


/**
 Provides a new cell for the given item.
 
 @param sender SCItemGridBrowser controller instance.
 @param item An item to be rendered in the given cell.
 @param indexPath NSIndexPath from the UICollectionViewDataSource. It should be passed to [UICollectionView dequeueReusableCellWithReuseIdentifier:forIndexPath:]
 
 @return A new cell.
 
 Do not invoke methods of the SCItemCell protocol directly. SCItemGridBrowser controller will do it for you.
 */
-(UICollectionViewCell<SCItemCell>*)itemsBrowser:( SCItemGridBrowser* )sender
                       createGridModeCellForItem:( SCItem* )item
                                     atIndexPath:( NSIndexPath* )indexPath;

@end

