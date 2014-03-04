#import <SitecoreItemsBrowser/Grid/SCItemGridCell.h>


/**
 A UICollectionViewCell sub-class that displays the displayName value of the given SCItem.

 It creates a UILabel sized as the entire cell. It uses default font and color settings.
 There is no way to configure its look and feel except of using UIAppearance API.
 */
@interface SCItemGridTextCell : SCItemGridCell


/**
 A designated initializer. Used by [UICollectionView dequeueReusableCellWithReuseIdentifier:forIndexPath:] to initialize the cell.
 
 @param frame A frame to initialize cell view. See [UIView initWithFrame:] for details.
 @return A properly initialized cell.
 */
-(instancetype)initWithFrame:( CGRect )frame;

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
