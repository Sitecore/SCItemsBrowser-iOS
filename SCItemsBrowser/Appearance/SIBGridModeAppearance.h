#import <Foundation/Foundation.h>

@class SCItem;
@class SCItemGridBrowser;

@class NSIndexPath;
@class UICollectionViewCell;
@class UICollectionViewLayout;
@class UICollectionViewTransitionLayout;


@protocol SIBGridModeAppearance <NSObject>


@optional
-(void)itemsBrowser:( SCItemGridBrowser* )sender
   didHighlightCell:( UICollectionViewCell* )cell
            forItem:( SCItem* )item
        atIndexPath:( NSIndexPath* )indexPath;

-(void)itemsBrowser:( SCItemGridBrowser* )sender
 didUnhighlightCell:( UICollectionViewCell* )cell
            forItem:( SCItem* )item
        atIndexPath:( NSIndexPath* )indexPath;


-(UICollectionViewTransitionLayout*)itemsBrowser:( SCItemGridBrowser* )sender
                    transitionLayoutForOldLayout:( UICollectionViewLayout* )fromLayout
                                       newLayout:( UICollectionViewLayout* )toLayout;

@end
