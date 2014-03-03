#import <UIKit/UIKit.h>
#import <SCItemsBrowser/SCItemCell.h>

@class UIColor;

/**
 A UICollectionViewCell cell that is capable of rendering item's content.
 For custom behaviour you should subclass it and override methods below :
 
 - setModel:
 - reloadData
 
 For default behaviours please consider sub-classes from the list below :
 
 - SCItemGridTextCell
 - SCMediaItemGridCell
 
 
 We have added some background color animations to this sub-class to make the demo application UI look more responsive. If you need some advanced effects, please override the [UICollectionViewCell setHighlighted:] method in your sub-classes.
 */
@interface SCItemGridCell : UICollectionViewCell<SCItemCell>

/**
 Background color that is applied when the cell is displayed in UICollectionView without any user's interaction.
 */
@property ( nonatomic, strong ) UIColor* backgroundColorForNormalState;

/**
 Background color that is applied when the cell is being touched by the user.
 */
@property ( nonatomic, strong ) UIColor* backgroundColorForHighlightedState;

@end
