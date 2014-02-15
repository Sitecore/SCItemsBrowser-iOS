#import "StubCellFactory.h"

@implementation StubCellFactory

-(UITableViewCell<SCItemCell>*)itemsBrowser:( id )sender
                  createListModeCellForItem:( SCItem* )item
{
    return nil;
}

-(UICollectionViewCell<SCItemCell>*)createCellForGridMode
{
    return nil;
}

-(UITableViewCell*)createLevelUpCellForListModeOfItemsBrowser:( id )sender
{
    return nil;
}

-(NSString*)reuseIdentifierForLevelUpCellOfItemsBrowser:( id )sender
{
    return nil;
}

-(NSString*)itemsBrowser:( id )sender
itemCellReuseIdentifierForItem:( SCItem* )item
{
    return nil;
}


@end
