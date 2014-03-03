#import "SCGridCellBackgroundHighlightingAnimation.h"

#import "SCHighlightableBackgroundGridCell.h"

@implementation SCGridCellBackgroundHighlightingAnimation

+(void)playAnimationForCell:( UICollectionViewCell<SCHighlightableBackgroundGridCell>* )cell
                toHighlight:( BOOL )shouldHighlight
{
    BOOL highlighted = shouldHighlight;
    BOOL isSameState = ( cell.highlighted && highlighted ) || (!cell.highlighted && !highlighted );
    
    
    if ( isSameState )
    {
        return;
    }
    
    UIColor* newColor = nil;
    if ( highlighted )
    {
        newColor = [ cell backgroundColorForHighlightedState ];
    }
    else
    {
        newColor = [ cell backgroundColorForNormalState ];
    }
    
    [ UIView animateWithDuration: 0.5
                      animations: ^{
                          cell.backgroundColor = newColor;
                      } ];
}

@end
