#import "SCDefaultLevelUpGridCell.h"

#import "SCHighlightableBackgroundGridCell.h"
#import "SCGridCellBackgroundHighlightingAnimation.h"


@interface SCDefaultLevelUpGridCell ()<SCHighlightableBackgroundGridCell>
@end

@implementation SCDefaultLevelUpGridCell
{
    UILabel* _label;
}


-(instancetype)initWithFrame:( CGRect )frame
{
    self = [ super initWithFrame: frame ];
    if ( nil == self )
    {
        return nil;
    }
    
    [ self setupUI ];
    
    return self;
}

-(void)setupUI
{
    CGRect labelFrame = self.contentView.frame;
    labelFrame.origin = CGPointMake( 0, 0 );
    
    UILabel* label = [ [ UILabel alloc ] initWithFrame: labelFrame ];
    self->_label = label;
    
    [ self.contentView addSubview: label ];
}

-(void)setLevelUpText:( NSString* )levelUp
{
    self->_label.text = levelUp;
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
