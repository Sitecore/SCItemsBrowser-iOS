#import <Foundation/Foundation.h>

@class UICollectionViewCell;
@class SCItemGridBrowser;
@protocol SCItemCell;

@protocol SIBGridModeCellFactory <NSObject>

-(UICollectionViewCell*)itemsBrowser:( SCItemGridBrowser* )sender
        createLevelUpCellAtIndexPath:( NSIndexPath* )indexPath;

-(UICollectionViewCell<SCItemCell>*)itemsBrowser:( SCItemGridBrowser* )sender
                       createGridModeCellForItem:( SCItem* )item
                                     atIndexPath:( NSIndexPath* )indexPath;

@end

