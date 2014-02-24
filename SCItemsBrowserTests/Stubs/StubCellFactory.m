#import "StubCellFactory.h"

@implementation StubCellFactory

-(UITableViewCell<SCItemCell>*)itemsBrowser:( SCItemListBrowser* )sender
                  createListModeCellForItem:( SCItem* )item
{
    return nil;
}

-(UICollectionViewCell<SCItemCell>*)createCellForGridMode
{
    return nil;
}

-(UITableViewCell*)createLevelUpCellForListModeOfItemsBrowser:( SCItemListBrowser* )sender
{
    return nil;
}

-(NSString*)reuseIdentifierForLevelUpCellOfItemsBrowser:( SCItemListBrowser* )sender
{
    return nil;
}

-(NSString*)itemsBrowser:( SCItemListBrowser* )sender
itemCellReuseIdentifierForItem:( SCItem* )item
{
    return nil;
}


#pragma mark -
#pragma mark Grid
-(UICollectionViewCell*)itemsBrowser:( SCItemGridBrowser* )sender
        createLevelUpCellAtIndexPath:( NSIndexPath* )indexPath
{
    return nil;
}

-(UICollectionViewCell<SCItemCell>*)itemsBrowser:( SCItemGridBrowser* )sender
                       createGridModeCellForItem:( SCItem* )item
                                     atIndexPath:( NSIndexPath* )indexPath
{
    return nil;
}

@end
