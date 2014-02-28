#import "SCItemGridCell.h"


/**
 A UICollectionViewCell sub-class that displays the image of a given media item.
  It creates a UILabel sized as the entire cell. 
 */
@interface SCMediaItemGridCell : SCItemGridCell

/**
 A designated initializer. Used by [UICollectionView dequeueReusableCellWithReuseIdentifier:forIndexPath:] to initialize the cell.
 
 @param frame A frame to initialize cell view. See [UIView initWithFrame:] for details.
 @return A properly initialized cell.
 */
-(instancetype)initWithFrame:( CGRect )frame;


/**
 Options for image resizing. It will be performed on the server side.
 They can be assigned in the cell multiple times since cells are likely to be reused.
 */
@property ( nonatomic, strong, readwrite ) SCDownloadMediaOptions* imageResizingOptions;


/**
 Stores the media item in the cell object to populate its image.
 
 @param item A sitecore item to render
 */
-(void)setModel:( SCItem* )item;

/**
 Downloads the corresponding image and renders it in the cell.
 */
-(void)reloadData;

@end
