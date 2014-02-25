#import "SCItemGridTextCell.h"

@implementation SCItemGridTextCell
{
    UILabel* _label;
    NSString* _displayName;
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

-(void)setModel:( SCItem* )item
{
    self->_displayName = item.displayName;
}

-(void)reloadData
{
    self->_label.text = self->_displayName;
}

@end
