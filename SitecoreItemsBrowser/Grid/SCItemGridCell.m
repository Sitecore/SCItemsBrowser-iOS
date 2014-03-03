#import "SCItemGridCell.h"

#import "SCHighlightableBackgroundGridCell.h"
#import "SCGridCellBackgroundHighlightingAnimation.h"

@interface SCItemGridCell()<SCHighlightableBackgroundGridCell>
@end

@implementation SCItemGridCell

-(void)setModel:( SCItem* )item
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(void)reloadData
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(void)setBackgroundColorForNormalState:( UIColor* )value
{
    self->_backgroundColorForNormalState = value;
    self.backgroundColor = value;
}

-(void)setHighlighted:( BOOL )highlighted
{
    [ SCGridCellBackgroundHighlightingAnimation playAnimationForCell: self
                                                         toHighlight: highlighted ];
    [ super setHighlighted: highlighted ];
}

@end
