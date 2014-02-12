#import "StubCellFactory.h"

@implementation StubCellFactory

-(UITableViewCell<SCItemCell>*)createListModeCellForItem:(SCItem *)item
{
    return nil;
}

-(UICollectionViewCell<SCItemCell>*)createCellForGridMode
{
    return nil;
}

-(UITableViewCell*)createLevelUpCellForListMode
{
    return nil;
}

-(NSString*)levelUpCellReuseIdentifier
{
    return nil;
}

-(NSString*)itemCellReuseIdentifier
{
    return nil;
}


@end
