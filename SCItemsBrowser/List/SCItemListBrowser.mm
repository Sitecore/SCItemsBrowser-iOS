#import "SCItemListBrowser.h"

#import "SCLevelUpItem.h"
#import "SCAbstractItemsBrowser_Protected.h"


@implementation SCItemListBrowser

-(void)dealloc
{
    // @adk : this is required since properties are "assign"
    self->_tableView.delegate   = nil;
    self->_tableView.dataSource = nil;
}

#pragma mark -
#pragma mark Once assign properties
-(void)setTableView:( UITableView* )tableView
{
    NSParameterAssert( nil == self->_tableView );
    self->_tableView = tableView;
    self->_tableView.dataSource = self;
    self->_tableView.delegate   = self;
}

-(void)setListModeTheme:(id<SIBListModeAppearance>)listModeTheme
{
    NSParameterAssert( nil == self->_listModeTheme );
    self->_listModeTheme = listModeTheme;
}

-(void)setListModeCellBuilder:(id<SIBListModeCellFactory>)listModeCellBuilder
{
    NSParameterAssert( nil == self->_listModeCellBuilder );
    self->_listModeCellBuilder = listModeCellBuilder;
    
}


#pragma mark - 
#pragma mark Override
-(void)reloadContentView
{
    [ self.tableView reloadData ];
}

-(void)reloadDataIgnoringCache:( BOOL )shouldIgnoreCache
{
    NSParameterAssert( nil != self->_tableView  );

    [ super reloadDataIgnoringCache: shouldIgnoreCache ];
}

#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)tableView:( UITableView* )tableView
numberOfRowsInSection:( NSInteger )section
{
    if ( nil == self.loadedLevel )
    {
        // @adk : this method is called on delegate assignment by UIKit.
        // Replacing assert with "if" to workaround
        return 0;
    }
    
    NSParameterAssert( nil != self.loadedLevel );
    NSParameterAssert( nil != self.loadedLevel.levelParentItem );
    NSParameterAssert( nil != self.loadedLevel.levelContentItems );
    
    NSUInteger result = [ self.loadedLevel.levelContentItems count ];
    return static_cast<NSInteger>( result );
}

-(UITableViewCell*)tableView:( UITableView* )tableView
       cellForRowAtIndexPath:( NSIndexPath* )indexPath
{
    NSParameterAssert( nil != self->_listModeCellBuilder );
    
    NSString* LEVEL_UP_CELL_ID = [ self->_listModeCellBuilder reuseIdentifierForLevelUpCellOfItemsBrowser: self ];
    NSParameterAssert( nil != LEVEL_UP_CELL_ID );
    
    
    
    NSParameterAssert( nil != self.loadedLevel );
    NSParameterAssert( nil != self.loadedLevel.levelParentItem );
    NSParameterAssert( nil != self.loadedLevel.levelContentItems );
    
    NSUInteger itemIndex = static_cast<NSUInteger>( indexPath.row );
    id itemForCell = self.loadedLevel.levelContentItems[ itemIndex ];
    
    if ( [ itemForCell isMemberOfClass: [ SCLevelUpItem class ] ] )
    {
        UITableViewCell* cell = [ tableView dequeueReusableCellWithIdentifier: LEVEL_UP_CELL_ID ];
        if ( nil == cell )
        {
            cell = [ self->_listModeCellBuilder createLevelUpCellForListModeOfItemsBrowser: self ];
        }
        
        return cell;
    }
    else
    {
        NSParameterAssert( [ itemForCell isMemberOfClass: [ SCItem class ] ] );
        SCItem* castedItem = (SCItem*)itemForCell;
        
        NSString* ITEM_CELL_ID = [ self->_listModeCellBuilder itemsBrowser: self
                                            itemCellReuseIdentifierForItem: castedItem ];
        NSParameterAssert( nil != ITEM_CELL_ID );

        
        UITableViewCell* cell = [ tableView dequeueReusableCellWithIdentifier: ITEM_CELL_ID ];
        UITableViewCell<SCItemCell>* itemCell = nil;

        
        if ( nil == cell )
        {
            itemCell = [ self->_listModeCellBuilder itemsBrowser: self
                                       createListModeCellForItem: castedItem ];
            cell = itemCell;
        }
        else
        {
            itemCell = ( UITableViewCell<SCItemCell>* )cell;
        }
        
        NSParameterAssert( nil != itemCell );
        [ itemCell setModel: castedItem ];
        [ itemCell reloadData ];
     
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:( UITableView* )tableView
{
    return 1;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void)tableView:( UITableView* )tableView
didSelectRowAtIndexPath:( NSIndexPath* )indexPath
{
    NSUInteger selectedItemIndex = static_cast<NSUInteger>( indexPath.row );
    id selectedItem = self.loadedLevel.levelContentItems[ selectedItemIndex ];

    [ self didSelectItem: selectedItem
             atIndexPath: indexPath ];
}

#pragma mark -
#pragma mark Appearance
-(NSString*)tableView:( UITableView* )tableView
titleForHeaderInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelHeaderTitleForTableViewSectionOfItemsBrowser: ) ] )
    {
        return [ self->_listModeTheme levelHeaderTitleForTableViewSectionOfItemsBrowser: self ];
    }
    
    // @adk : as if not overloaded
    return nil;
}

-(NSString*)tableView:( UITableView* )tableView
titleForFooterInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelFooterTitleForTableViewSectionOfItemsBrowser: ) ] )
    {
        return [ self->_listModeTheme levelFooterTitleForTableViewSectionOfItemsBrowser: self ];
    }
    
    // @adk : as if not overloaded
    return nil;
}

-(UIView *)tableView:( UITableView* )tableView
viewForHeaderInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelHeaderViewForTableViewSectionOfItemsBrowser: ) ] )
    {
        return [ self->_listModeTheme levelHeaderViewForTableViewSectionOfItemsBrowser: self ];
    }

    
    // @adk : as if not overloaded
    return nil;
}

-(UIView *)tableView:( UITableView* )tableView
viewForFooterInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelFooterViewForTableViewSectionOfItemsBrowser: ) ] )
    {
        return [ self->_listModeTheme levelFooterViewForTableViewSectionOfItemsBrowser: self ];
    }

    // @adk : as if not overloaded
    return nil;
}

-(CGFloat)tableView:( UITableView* )tableView
heightForRowAtIndexPath:( NSIndexPath* )indexPath
{
    NSUInteger selectedItemIndex = static_cast<NSUInteger>( indexPath.row );
    id selectedItem = self.loadedLevel.levelContentItems[ selectedItemIndex ];
    
    if ( [ selectedItem isMemberOfClass: [ SCLevelUpItem class ] ] )
    {
        if ( [ self->_listModeTheme respondsToSelector: @selector( itemsBrowser:levelUpCellHeigtAtIndexPath: ) ] )
        {
            return [ self->_listModeTheme itemsBrowser: self
                           levelUpCellHeigtAtIndexPath: indexPath ];
        }
    }
    else
    {
        if ( [ self->_listModeTheme respondsToSelector: @selector( itemsBrowser:heightOfCellForItem:atIndexPath: ) ] )
        {
            return [ self->_listModeTheme itemsBrowser: self
                                   heightOfCellForItem: selectedItem
                                           atIndexPath: indexPath ];
        }
    }
    
    // @adk : as if not overloaded
    return -1;
}

-(CGFloat)tableView:( UITableView* )tableView
heightForHeaderInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelHeaderHeightForTableViewSectionOfItemsBrowser: ) ] )
    {
        return [ self->_listModeTheme levelHeaderHeightForTableViewSectionOfItemsBrowser: self ];
    }
    
    // @adk : as if not overloaded
    return -1;
}

-(CGFloat)tableView:( UITableView* )tableView
heightForFooterInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelFooterHeightForTableViewSectionOfItemsBrowser: ) ] )
    {
        return [ self->_listModeTheme levelFooterHeightForTableViewSectionOfItemsBrowser: self ];
    }
    
    // @adk : as if not overloaded
    return -1;
}

//- (NSInteger)tableView:(UITableView *)tableView
//indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath

@end
