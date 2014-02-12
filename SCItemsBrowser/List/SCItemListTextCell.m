#import "SCItemListTextCell.h"

@implementation SCItemListTextCell
{
    SCItem* _item;
}

-(void)setModel:( SCItem* )item
{
    self->_item = item;
}

-(void)reloadData
{
    self.textLabel.text = self->_item.displayName;
}

@end
