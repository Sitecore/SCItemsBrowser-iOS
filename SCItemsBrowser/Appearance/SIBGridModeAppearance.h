#import <Foundation/Foundation.h>

@class SCItem;
@class SCItemGridBrowser;

@class NSIndexPath;
@class UICollectionViewCell;


@protocol SIBGridModeAppearance <NSObject>

-(void)itemsBrowser:( SCItemGridBrowser* )sender
   didHighlightCell:( UICollectionViewCell* )cell
            forItem:( SCItem* )item
        atIndexPath:( NSIndexPath* )indexPath;

-(void)itemsBrowser:( SCItemGridBrowser* )sender
 didUnhighlightCell:( UICollectionViewCell* )cell
            forItem:( SCItem* )item
        atIndexPath:( NSIndexPath* )indexPath;


@end
