#import <UIKit/UIKit.h>

/**
 A UICollectionViewCell sub-class for rendering text that represents a "level up" marker.
 
 It creates a UILabel sized as the entire cell. It uses default font and color settings.
 There is no way to configure its look and feel except of using UIAppearance API.
 
  We have added some background color animations to this sub-class to make the demo application UI look more responsive. If you need some advanced effects, please override the [UICollectionViewCell setHighlighted:] method in your sub-classes.
 */
@interface SCDefaultLevelUpGridCell : UICollectionViewCell

/**
 A designated initializer. Used by [UICollectionView dequeueReusableCellWithReuseIdentifier:forIndexPath:] to initialize the cell.
 
 @param frame A frame to initialize cell view. See [UIView initWithFrame:] for details.
 @return A properly initialized cell.
 */
-(instancetype)initWithFrame:( CGRect )frame;

/**
 Sets the "level up" text message.
 
 @param levelUp localized text to display within the label. It will be displayed as is.
 */
-(void)setLevelUpText:( NSString* )levelUp;


/**
 Background color that is applied when the cell is displayed in UICollectionView without any user's interaction.
 */
@property ( nonatomic, strong ) UIColor* backgroundColorForNormalState;

/**
 Background color that is applied when the cell is being touched by the user.
 */
@property ( nonatomic, strong ) UIColor* backgroundColorForHighlightedState;

@end
