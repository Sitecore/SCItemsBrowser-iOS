#import <UIKit/UIKit.h>

/**
 A UICollectionViewCell sub-class for rendering text that represents a "level up" marker.
 
 It creates a UILabel sized as the entire cell. It uses default font and color settings.
 There is no way to configure its look and feel except of using UIAppearance API.
 */
@interface SCDefaultLevelUpGridCell : UICollectionViewCell

/**
 Sets the "level up" text message.
 
 @param levelUp localized text to display within the label. It will be displayed as is.
 */
-(void)setLevelUpText:( NSString* )levelUp;

@end
