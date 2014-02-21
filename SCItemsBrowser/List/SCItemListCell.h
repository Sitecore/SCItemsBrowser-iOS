#import <UIKit/UIKit.h>
#import <SCItemsBrowser/SCItemCell.h>

/**
 A UITableView cell that is capable of rendering item's content.
 For custom behaviour you should subclass it and override methods below : 

 - setModel:
 - reloadData
 
 For default behaviours please consider SCItemListTextCell and SCMediaItemListCell sub-classes.
 */
@interface SCItemListCell : UITableViewCell<SCItemCell>
@end
