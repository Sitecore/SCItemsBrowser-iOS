#import <Foundation/Foundation.h>

@protocol SCHighlightableBackgroundGridCell;

@interface SCGridCellBackgroundHighlightingAnimation : NSObject

+(void)playAnimationForCell:( UICollectionViewCell<SCHighlightableBackgroundGridCell>* )cell
                toHighlight:( BOOL )shouldHighlight;

@end
