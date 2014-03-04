#import <SitecoreItemsBrowser/List/SCItemListCell.h>

@class SCFieldImageParams;


/**
 A UITableViewCell sub-class that displays both the displayName of the media item and the corresponding image.
 */
@interface SCMediaItemListCell : SCItemListCell

/**
 Unsupported initializer that throws an exception. Do not use it.
 initWithStyle:reuseIdentifier:imageParams: should be used instead.
 
 @param style See UITableViewCellStyle enum for possible values.
 
 @param reuseIdentifier this will be used by the UITableView dequeueReusableCellWithIdentifier:
 
 @return nil. The execution should not reach this point since the exception will be thrown.
 */
-(id)initWithStyle:( UITableViewCellStyle )style
   reuseIdentifier:( NSString* )reuseIdentifier;


/**
 The designated initializer. If the cell can be reused, you must pass in a reuse identifier.  You should use the same reuse identifier for all cells of the same form.

 @param style See UITableViewCellStyle enum for possible values. 
 
 @param reuseIdentifier this will be used by the UITableView dequeueReusableCellWithIdentifier:
 
 @param imageResizingOptions options for image resizing. It will be performed on the server side.

 @return A properly initialized cell object
 */
-(id)initWithStyle:( UITableViewCellStyle  )style
   reuseIdentifier:( NSString            * )reuseIdentifier
       imageParams:( SCFieldImageParams  * )imageResizingOptions;



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
