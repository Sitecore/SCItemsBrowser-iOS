#import <SitecoreMobileSDK/SitecoreMobileSDK.h>


/**
 Extension methods for working with media items.
 */
@interface SCItem (Media)

/**
 Checks whether the item is in the media folder.
 
 @return YES if the item's path is within the media folder. By default, it is "/sitecore/Media Library".
 */
-(BOOL)isMediaItem;

/**
 Checks whether the item is a media image. Such items have image template and is stored in the media folder. See isMediaItem and isImage methods for details.
 
 @return YES if the item is a media image.
 */
-(BOOL)isMediaImage;

/**
 Checks whether the item has an image template.
 
 * "SYSTEM/MEDIA/UNVERSIONED/IMAGE"
 * "SYSTEM/MEDIA/UNVERSIONED/JPEG"
 * "SYSTEM/MEDIA/VERSIONED/JPEG"

 @return YES if item's template is among those listed above.
 
*/
-(BOOL)isImage;


/**
 Checks whether the item has a folder template.
 * "SYSTEM/MEDIA/MEDIA FOLDER"
 * "COMMON/FOLDER"
 
 @return YES if item's template is among those listed above.
 */
-(BOOL)isFolder;

/**
 Returns a media path of items that have it.
 
 @return 
 
 |self.isMediaItem | return value|
 |-------------------------------|
 |       YES       | media path  |
 |-------------------------------|
 |        NO       | nil         |
  -------------------------------
 */
-(NSString*)mediaPath;


/**
 Returns a media path of items that have it.
 
 @param options Resizing options for media files processing on the back end.
 
 @return
 
 |self.isMediaItem | return value|
 |-------------------------------|
 |       YES       | loader      |
 |-------------------------------|
 |        NO       | nil         |
  -------------------------------
 */
-(SCExtendedAsyncOp)mediaLoaderWithOptions:( SCFieldImageParams* )options;


/**
 @return Item source if available. Default settings of the corresponding context otherwise.
 */
-(SCItemSourcePOD*)recordItemSource;

@end
