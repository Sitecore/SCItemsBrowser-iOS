#import <Foundation/Foundation.h>

@class UICollectionViewCell;
@protocol SCItemCell;

@protocol SIBGridModeCellFactory <NSObject>

-(UICollectionViewCell*)itemsBrowser:( id )sender
        createLevelUpCellAtIndexPath:( NSIndexPath* )indexPath;

-(UICollectionViewCell<SCItemCell>*)itemsBrowser:( id )sender
                       createGridModeCellForItem:( SCItem* )item
                                     atIndexPath:( NSIndexPath* )indexPath;

@end

