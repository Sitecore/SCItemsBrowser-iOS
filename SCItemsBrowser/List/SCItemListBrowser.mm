#import "SCItemListBrowser.h"

#import "SCLevelUpItem.h"


@implementation SCItemListBrowser
{
    dispatch_once_t _onceItemsFileManagerToken;
    SCItemsFileManager* _itemsFileManager;
    
    SCLevelResponse* _loadedLevel;
}

-(void)dealloc
{
    // @adk : this is required since properties are "assign"
    self->_tableView.delegate   = nil;
    self->_tableView.dataSource = nil;
}

#pragma mark -
#pragma mark LazyProperties
-(void)disposeLazyItemsFileManager
{
    self->_onceItemsFileManagerToken = 0;
    self->_itemsFileManager          = nil;
}

-(SCItemsFileManager*)lazyItemsFileManager
{
    SCExtendedApiContext* context = self->_apiContext;
    id<SCItemsLevelRequestBuilder> nextLevelRequestBuilder = self->_nextLevelRequestBuilder;

    NSParameterAssert( nil != context );
    NSParameterAssert( nil != nextLevelRequestBuilder );
    if ( nil == context || nil == nextLevelRequestBuilder )
    {
        return nil;
    }
    
    dispatch_once(&self->_onceItemsFileManagerToken, ^void()
    {
        self->_itemsFileManager =
        [ [ SCItemsFileManager alloc ] initWithApiContext: context
                                      levelRequestBuilder: nextLevelRequestBuilder ];
    });
    
    return self->_itemsFileManager;
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

-(void)setApiContext:( SCExtendedApiContext* )value
{
    NSParameterAssert( nil == self->_apiContext );
    self->_apiContext = value;
}

-(void)setRootItem:(SCItem *)rootItem
{
    NSParameterAssert( nil == self->_rootItem );
    self->_rootItem = rootItem;
}

-(void)setListModeTheme:(id<SIBListModeAppearance>)listModeTheme
{
    NSParameterAssert( nil == self->_listModeTheme );
    self->_listModeTheme = listModeTheme;
}

-(void)setDelegate:(id<SCItemsBrowserDelegate>)delegate
{
    NSParameterAssert( nil == self->_delegate );
    self->_delegate = delegate;
}

-(void)setListModeCellBuilder:(id<SIBListModeCellFactory>)listModeCellBuilder
{
    NSParameterAssert( nil == self->_listModeCellBuilder );
    self->_listModeCellBuilder = listModeCellBuilder;
    
}

-(void)setNextLevelRequestBuilder:(id<SCItemsLevelRequestBuilder>)nextLevelRequestBuilder
{
    NSParameterAssert( nil == self->_nextLevelRequestBuilder );
    self->_nextLevelRequestBuilder = nextLevelRequestBuilder;
}

#pragma mark - 
#pragma mark SCItemsBrowserProtocol
-(void)onLevelReloaded:( SCLevelResponse* )levelResponse
{
    NSParameterAssert( nil != levelResponse );
    NSParameterAssert( nil != levelResponse.levelParentItem );
    
    [ self.delegate itemsBrowser: self
             didLoadLevelForItem: levelResponse.levelParentItem ];

    self->_loadedLevel = levelResponse;
    
    [ self.tableView reloadData ];
}

-(void)onLevelReloadFailedWithError:( NSError* )levelError
{
    [ self.delegate itemsBrowser: self
     levelLoadingFailedWithError: levelError ];
}

-(SCItemsFileManagerCallbacks*)newCallbacksForItemsFileManager
{
    __weak SCItemListBrowser* weakSelf = self;
    
    SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
    {
        callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* levelResponse, NSError* levelError )
        {
            if ( nil == levelResponse )
            {
                [ weakSelf onLevelReloadFailedWithError: levelError ];
            }
            else
            {
                [ weakSelf onLevelReloaded: levelResponse ];
            }
        };
        
        callbacks.onLevelProgressBlock = ^void( id progressInfo )
        {
            [ weakSelf.delegate itemsBrowser: weakSelf
         didReceiveLevelProgressNotification: progressInfo ];
        };
    }
    
    return callbacks;
}


-(void)reloadDataIgnoringCache:( BOOL )shouldIgnoreCache
{
    NSParameterAssert( nil != self->_tableView );
    
    SCItemsFileManagerCallbacks* fmCallbacks = [ self newCallbacksForItemsFileManager ];
    
    if ( ![ self.lazyItemsFileManager isRootLevelLoaded ] )
    {
        [ self.lazyItemsFileManager loadLevelForItem: self->_rootItem
                                           callbacks: fmCallbacks
                                       ignoringCache: shouldIgnoreCache ];
    }
    else
    {
        [ self.lazyItemsFileManager reloadCurrentLevelNotifyingCallbacks: fmCallbacks
                                                           ignoringCache: shouldIgnoreCache ];
    }
}

-(void)reloadData
{
    [ self reloadDataIgnoringCache: NO ];
}

-(void)forceRefreshData
{
    [ self reloadDataIgnoringCache: YES ];
}

-(void)navigateToRootItem
{
    [ self disposeLazyItemsFileManager ];
 
    SCItemsFileManagerCallbacks* fmCallbacks = [ self newCallbacksForItemsFileManager ];
    [ self.lazyItemsFileManager loadLevelForItem: self->_rootItem
                                       callbacks: fmCallbacks
                                   ignoringCache: NO ];
}


#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)tableView:( UITableView* )tableView
numberOfRowsInSection:( NSInteger )section
{
    if ( nil == self->_loadedLevel )
    {
        // @adk : this method is called on delegate assignment by UIKit.
        // Replacing assert with "if" to workaround
        return 0;
    }
    
    NSParameterAssert( nil != self->_loadedLevel );
    NSParameterAssert( nil != self->_loadedLevel.levelParentItem );
    NSParameterAssert( nil != self->_loadedLevel.levelContentItems );
    
    NSUInteger result = [ self->_loadedLevel.levelContentItems count ];
    return static_cast<NSInteger>( result );
}

-(UITableViewCell*)tableView:( UITableView* )tableView
       cellForRowAtIndexPath:( NSIndexPath* )indexPath
{
    NSParameterAssert( nil != self->_listModeCellBuilder );
    
    NSString* LEVEL_UP_CELL_ID = [ self->_listModeCellBuilder reuseIdentifierForLevelUpCellOfItemsBrowser: self ];
    NSParameterAssert( nil != LEVEL_UP_CELL_ID );
    
    
    
    NSParameterAssert( nil != self->_loadedLevel );
    NSParameterAssert( nil != self->_loadedLevel.levelParentItem );
    NSParameterAssert( nil != self->_loadedLevel.levelContentItems );
    
    NSUInteger itemIndex = static_cast<NSUInteger>( indexPath.row );
    id itemForCell = self->_loadedLevel.levelContentItems[ itemIndex ];
    
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
    id selectedItem = self->_loadedLevel.levelContentItems[ selectedItemIndex ];
    
    SCItemsFileManagerCallbacks* callbacks = [ self newCallbacksForItemsFileManager ];
    
    if ( [ selectedItem isMemberOfClass: [ SCLevelUpItem class ] ] )
    {
        [ self->_itemsFileManager goToLevelUpNotifyingCallbacks: callbacks ];
    }
    else
    {
        SCItem* item = (SCItem*)selectedItem;

        BOOL shouldGoToNextLevel = [ self->_delegate itemsBrowser: self
                                           shouldLoadLevelForItem: item ];
        
        if ( shouldGoToNextLevel )
        {        
            [ self->_itemsFileManager loadLevelForItem: item
                                             callbacks: callbacks
                                         ignoringCache: NO ];
        }
    }
}

#pragma mark -
#pragma mark Appearance
-(NSString*)tableView:( UITableView* )tableView
titleForHeaderInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelHeaderTitleForTableViewSection ) ] )
    {
        return [ self->_listModeTheme levelHeaderTitleForTableViewSection ];
    }
    
    // @adk : as if not overloaded
    return nil;
}

-(NSString*)tableView:( UITableView* )tableView
titleForFooterInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelFooterTitleForTableViewSection ) ] )
    {
        return [ self->_listModeTheme levelFooterTitleForTableViewSection ];
    }
    
    // @adk : as if not overloaded
    return nil;
}

-(UIView *)tableView:( UITableView* )tableView
viewForHeaderInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelHeaderViewForTableViewSection ) ] )
    {
        return [ self->_listModeTheme levelHeaderViewForTableViewSection ];
    }

    
    // @adk : as if not overloaded
    return nil;
}

-(UIView *)tableView:( UITableView* )tableView
viewForFooterInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelFooterViewForTableViewSection ) ] )
    {
        return [ self->_listModeTheme levelFooterViewForTableViewSection ];
    }

    // @adk : as if not overloaded
    return nil;
}

-(CGFloat)tableView:( UITableView* )tableView
heightForRowAtIndexPath:( NSIndexPath* )indexPath
{
    NSUInteger selectedItemIndex = static_cast<NSUInteger>( indexPath.row );
    id selectedItem = self->_loadedLevel.levelContentItems[ selectedItemIndex ];
    
    if ( [ selectedItem isMemberOfClass: [ SCLevelUpItem class ] ] )
    {
        if ( [ self->_listModeTheme respondsToSelector: @selector( levelUpCellHeigtAtIndexPath: ) ] )
        {
            return [ self->_listModeTheme levelUpCellHeigtAtIndexPath: indexPath ];
        }
    }
    else
    {
        if ( [ self->_listModeTheme respondsToSelector: @selector( heightOfCellForItem:atIndexPath: ) ] )
        {
            return [ self->_listModeTheme heightOfCellForItem: selectedItem
                                                  atIndexPath: indexPath ];
        }
    }
    
    // @adk : as if not overloaded
    return -1;
}

-(CGFloat)tableView:( UITableView* )tableView
heightForHeaderInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelHeaderHeightForTableViewSection ) ] )
    {
        return [ self->_listModeTheme levelHeaderHeightForTableViewSection ];
    }
    
    // @adk : as if not overloaded
    return -1;
}

-(CGFloat)tableView:( UITableView* )tableView
heightForFooterInSection:( NSInteger )section
{
    if ( [ self->_listModeTheme respondsToSelector: @selector( levelFooterHeightForTableViewSection ) ] )
    {
        return [ self->_listModeTheme levelFooterHeightForTableViewSection ];
    }
    
    // @adk : as if not overloaded
    return -1;
}

//- (NSInteger)tableView:(UITableView *)tableView
//indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath

@end
