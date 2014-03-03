#import "SCItemListTextCell.h"

@implementation SCItemListTextCell
{
    NSString* _itemName;
}

-(void)setModel:( SCItem* )item
{
    self->_itemName = item.displayName;
}

-(void)reloadData
{
    self.textLabel.text = self->_itemName;
}

@end
