#import "SCItemGridCell.h"

@interface SCMediaItemGridCell : SCItemGridCell

/**
 Options for image resizing. It will be performed on the server side.
 They can be assigned in the cell multiple times since cells are likely to be reused.
 */
@property ( nonatomic, strong, readwrite ) SCFieldImageParams* imageResizingOptions;

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
