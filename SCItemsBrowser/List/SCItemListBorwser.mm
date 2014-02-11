#import "SCItemListBorwser.h"

#import "SCItemsFileManager.h"
#import "SCItemsFileManagerCallbacks.h"

#import "SCLevelResponse.h"


@implementation SCItemListBorwser
{
    dispatch_once_t _onceItemsFileManagerToken;
    SCItemsFileManager* _itemsFileManager;
    
    SCLevelResponse* _loadedLevel;
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
    self->_loadedLevel = levelResponse;
    
    [ self.tableView reloadData ];
}

-(void)onLevelReloadFailedWithError:( NSError* )levelError
{
    [ self.delegate itemsBrowser: self
      levelLoadinFailedWithError: levelError ];
}

-(SCItemsFileManagerCallbacks*)newCallbacksForItemsFileManager
{
    __weak SCItemListBorwser* weakSelf = self;
    
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
    NSParameterAssert( nil != self->_loadedLevel );
    NSParameterAssert( nil != self->_loadedLevel.levelParentItem );
    NSParameterAssert( nil != self->_loadedLevel.levelContentItems );
    
    NSUInteger result = [ self->_loadedLevel.levelContentItems count ];
    return static_cast<NSInteger>( result );
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert( NO, @"not implemented" );
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
