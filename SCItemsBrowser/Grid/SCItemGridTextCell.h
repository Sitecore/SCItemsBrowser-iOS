#import <SCItemsBrowser/Grid/SCItemGridCell.h>


/**
 A UICollectionViewCell sub-class that displays the displayName value of the given SCItem.

 It creates a UILabel sized as the entire cell. It uses default font and color settings.
 There is no way to configure its look and feel except of using UIAppearance API.
 */
@interface SCItemGridTextCell : SCItemGridCell

/**
 Stores the display name of a given media item.
 
 @param item A sitecore item to render
 */
-(void)setModel:( SCItem* )item;

/**
 Renders the stored displayName in the cell's label.
 */
-(void)reloadData;


@end
