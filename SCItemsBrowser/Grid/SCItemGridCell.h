#import <UIKit/UIKit.h>
#import <SCItemsBrowser/SCItemCell.h>

/**
 A UICollectionViewCell cell that is capable of rendering item's content.
 For custom behaviour you should subclass it and override methods below :
 
 - setModel:
 - reloadData
 
 For default behaviours please consider sub-classes from the list below :
 
 - SCItemGridTextCell
 - SCMediaItemGridCell
 */
@interface SCItemGridCell : UICollectionViewCell<SCItemCell>
@end
