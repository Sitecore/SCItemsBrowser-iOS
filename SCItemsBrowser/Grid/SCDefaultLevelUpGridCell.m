#import "SCDefaultLevelUpGridCell.h"

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

@end
