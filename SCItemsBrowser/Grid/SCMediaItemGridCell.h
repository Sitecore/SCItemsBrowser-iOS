#import "SCItemGridCell.h"

@interface SCMediaItemGridCell : SCItemGridCell

/**
 Options for image resizing. It will be performed on the server side.
 They can be assigned in the cell multiple times since cells are likely to be reused.
 */
@property ( nonatomic, strong, readwrite ) SCFieldImageParams* imageResizingOptions;


/**
 A designated initializer. Used by [UICollectionView dequeueReusableCellWithReuseIdentifier:forIndexPath:] to initialize the cell.
 
 @param frame A frame to initialize cell view. See [UIView initWithFrame:] for details.
 @return A properly initialized cell.
 */
-(instancetype)initWithFrame:( CGRect )frame;

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
