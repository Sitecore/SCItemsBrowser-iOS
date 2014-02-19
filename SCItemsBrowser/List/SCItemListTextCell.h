#import <Foundation/Foundation.h>
#import <SCItemsBrowser/List/SCItemListCell.h>

/**
 A UITableView cell that displays the displayName value of the given SCItem.
 */
@interface SCItemListTextCell : SCItemListCell

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
