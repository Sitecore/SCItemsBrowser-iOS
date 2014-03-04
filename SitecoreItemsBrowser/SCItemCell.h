#import <Foundation/Foundation.h>

@class SCItem;

/**
 SCItemCell protocol represents object capable of rendering an item.
 */
@protocol SCItemCell <NSObject>

/**
 Override this method to get information required for rendering out of the item. Please avoid storing the item itself if possible.
 
 @param item A sitecore item to render
 */
-(void)setModel:( SCItem* )item;

/**
 Override this method to get the missing data from the instance and render your cell UI using it.
 */
-(void)reloadData;

@end
