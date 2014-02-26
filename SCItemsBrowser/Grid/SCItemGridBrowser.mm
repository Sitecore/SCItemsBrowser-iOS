#import "SCItemGridBrowser.h"

#import "SIBGridModeCellFactory.h"
#import "SCLevelUpItem.h"

#import "SIBGridModeAppearance.h"
#import "SCItemsBrowserDelegate.h"

@implementation SCItemGridBrowser
{
    dispatch_once_t _onceItemsFileManagerToken;
    SCItemsFileManager* _itemsFileManager;
    
    SCLevelResponse* _loadedLevel;
}

-(void)dealloc
{
    // @adk : this is required since properties are "assign"
    self->_collectionView.delegate   = nil;
    self->_collectionView.dataSource = nil;
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
    
    // @adk : in case asserts are disabled or ignored
    // Returning nil to avoid exceptions within dispatch_once()
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

-(SCItemsFileManager*)itemsFileManager
{
    return self->_itemsFileManager;
}

-(dispatch_once_t)onceItemsFileManagerToken
{
    return self->_onceItemsFileManagerToken;
}

#pragma mark -
#pragma mark Once assign properties
-(void)setCollectionView:(UICollectionView *)collectionView
{
    NSParameterAssert( nil == self->_collectionView );
    self->_collectionView = collectionView;
    self->_collectionView.dataSource = self;
    self->_collectionView.delegate   = self;
}

-(void)setApiContext:( SCExtendedApiContext* )value
{
    NSParameterAssert( nil == self->_apiContext );
    self->_apiContext = value;
}

-(void)setRootItem:( SCItem* )rootItem
{
    NSParameterAssert( nil == self->_rootItem );
    self->_rootItem = rootItem;
}

-(void)setGridModeTheme:( id<SIBGridModeAppearance> )gridModeTheme
{
    NSParameterAssert( nil == self->_gridModeTheme );
    self->_gridModeTheme = gridModeTheme;
}

-(void)setDelegate:( id<SCItemsBrowserDelegate> )delegate
{
    NSParameterAssert( nil == self->_delegate );
    self->_delegate = delegate;
}

-(void)setGridModeCellBuilder:( id<SIBGridModeCellFactory> )gridModeCellBuilder
{
    NSParameterAssert( nil == self->_gridModeCellBuilder );
    self->_gridModeCellBuilder = gridModeCellBuilder;
    
}

-(void)setNextLevelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder
{
    NSParameterAssert( nil == self->_nextLevelRequestBuilder );
    self->_nextLevelRequestBuilder = nextLevelRequestBuilder;
}

#pragma mark -
#pragma mark SCItemsBrowserProtocol
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
    NSParameterAssert( nil != self->_apiContext );
    NSParameterAssert( nil != self->_rootItem );
    
    [ self disposeLazyItemsFileManager ];
    
    SCItemsFileManagerCallbacks* fmCallbacks = [ self newCallbacksForItemsFileManager ];
    [ self.lazyItemsFileManager loadLevelForItem: self->_rootItem
                                       callbacks: fmCallbacks
                                   ignoringCache: NO ];
}

-(void)onLevelReloaded:( SCLevelResponse* )levelResponse
{
    NSParameterAssert( nil != levelResponse );
    NSParameterAssert( nil != levelResponse.levelParentItem );
    
    self->_loadedLevel = levelResponse;
    [ self.collectionView reloadData ];
    
    [ self.delegate itemsBrowser: self
             didLoadLevelForItem: levelResponse.levelParentItem ];
}

-(void)onLevelReloadFailedWithError:( NSError* )levelError
{
    [ self.delegate itemsBrowser: self
     levelLoadingFailedWithError: levelError ];
}

-(SCItemsFileManagerCallbacks*)newCallbacksForItemsFileManager
{
    __weak SCItemGridBrowser* weakSelf = self;
    
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
    NSParameterAssert( nil != self->_collectionView  );
    NSParameterAssert( nil != self->_rootItem   );
    NSParameterAssert( nil != self->_apiContext );
    
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


#pragma mark - 
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:( UICollectionView* )collectionView
{
    return 1;
}

-(NSInteger)collectionView:( UICollectionView* )collectionView
    numberOfItemsInSection:( NSInteger )section
{
    if ( nil == self->_loadedLevel )
    {
        return 0;
    }
    
    NSUInteger result = [ self->_loadedLevel.levelContentItems count ];
    return static_cast<NSInteger>( result );
}

-(UICollectionViewCell*)collectionView:( UICollectionView* )collectionView
                cellForItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSParameterAssert( nil != self->_loadedLevel                   );
    NSParameterAssert( nil != self->_loadedLevel.levelParentItem   );
    NSParameterAssert( nil != self->_loadedLevel.levelContentItems );
    
    NSUInteger cellIndex = static_cast<NSUInteger>( indexPath.row );
    id itemObject = self->_loadedLevel.levelContentItems[cellIndex];
    BOOL isLevelUpItem = [ itemObject isMemberOfClass: [ SCLevelUpItem class ] ];
  
    UICollectionViewCell* result = nil;
    if ( isLevelUpItem )
    {
        // calls
        // registerClass:forCellWithReuseIdentifier:
        // dequeueReusableCellWithReuseIdentifier:forIndexPath:
        result = [ self.gridModeCellBuilder itemsBrowser: self
                            createLevelUpCellAtIndexPath: indexPath ];
    }
    else
    {
        // calls
        // registerClass:forCellWithReuseIdentifier:
        // dequeueReusableCellWithReuseIdentifier:forIndexPath:
        NSParameterAssert( [ itemObject isMemberOfClass: [ SCItem class ] ] );
        SCItem* item = (SCItem*)itemObject;
        
        UICollectionViewCell<SCItemCell>* cell =
        [ self.gridModeCellBuilder itemsBrowser: self
                      createGridModeCellForItem: item
                                    atIndexPath: indexPath ];
        
        [ cell setModel: itemObject ];
        [ cell reloadData ];
        
        result = cell;
    }
    
    return result;
}


#pragma mark -
#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:( UICollectionView* )collectionView
shouldSelectItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSUInteger itemIndex = static_cast<NSUInteger>( indexPath.row );
    id itemObject = self->_loadedLevel.levelContentItems[itemIndex];
    BOOL isLevelUpItem = [ itemObject isMemberOfClass: [ SCLevelUpItem class ] ];
    
    if ( isLevelUpItem )
    {
        return YES;
    }
    else
    {
        NSParameterAssert( [ itemObject isMemberOfClass: [ SCItem class ] ] );
        SCItem* item = (SCItem*)itemObject;

        return [ self.delegate itemsBrowser: self
                     shouldLoadLevelForItem: item ];
    }
}

-(void)collectionView:( UICollectionView* )collectionView
didSelectItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSUInteger selectedItemIndex = static_cast<NSUInteger>( indexPath.row );
    id selectedItem = self->_loadedLevel.levelContentItems[ selectedItemIndex ];
    BOOL isLevelUpItem = [ selectedItem isMemberOfClass: [ SCLevelUpItem class ] ];
    
    SCItemsFileManagerCallbacks* callbacks = [ self newCallbacksForItemsFileManager ];

    if ( isLevelUpItem )
    {
        [ self->_itemsFileManager goToLevelUpNotifyingCallbacks: callbacks ];
    }
    else
    {
        NSParameterAssert( [ selectedItem isMemberOfClass: [ SCItem class ] ] );
        SCItem* item = (SCItem*)selectedItem;

        [ self->_itemsFileManager loadLevelForItem: item
                                         callbacks: callbacks
                                     ignoringCache: NO ];
    }
}


#pragma mark -
#pragma mark Appearance
-(void)collectionView:( UICollectionView* )collectionView
didHighlightItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSParameterAssert( nil != self->_loadedLevel );
    NSParameterAssert( nil != indexPath );
    NSParameterAssert( nil != collectionView );
    
    SEL delegateSelector = @selector( itemsBrowser:didHighlightCell:forItem:atIndexPath: );
    if ( ![ self.gridModeTheme respondsToSelector: delegateSelector ]  )
    {
        return;
    }

    
    UICollectionViewCell* cell = [ self.collectionView cellForItemAtIndexPath: indexPath ];
    NSParameterAssert( nil != cell );
    
    
    NSUInteger selectedItemIndex = static_cast<NSUInteger>( indexPath.row );
    SCItem* selectedItem = self->_loadedLevel.levelContentItems[selectedItemIndex];
    NSParameterAssert( nil != selectedItem );
    
    [ self.gridModeTheme itemsBrowser: self
                     didHighlightCell: cell
                              forItem: selectedItem
                          atIndexPath: indexPath ];
}

-(void)collectionView:( UICollectionView* )collectionView
didUnhighlightItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSParameterAssert( nil != self->_loadedLevel );
    NSParameterAssert( nil != indexPath );
    NSParameterAssert( nil != collectionView );
 
    SEL delegateSelector = @selector( itemsBrowser:didUnhighlightCell:forItem:atIndexPath: );
    if ( ![ self.gridModeTheme respondsToSelector: delegateSelector ]  )
    {
        return;
    }
    
    UICollectionViewCell* cell = [ self.collectionView cellForItemAtIndexPath: indexPath ];
    NSParameterAssert( nil != cell );
    
    NSUInteger selectedItemIndex = static_cast<NSUInteger>( indexPath.row );
    SCItem* selectedItem = self->_loadedLevel.levelContentItems[selectedItemIndex];
    NSParameterAssert( nil != selectedItem );
    
    [ self.gridModeTheme itemsBrowser: self
                   didUnhighlightCell: cell
                              forItem: selectedItem
                          atIndexPath: indexPath ];
}

-(UICollectionViewTransitionLayout *)collectionView:( UICollectionView* )collectionView
                       transitionLayoutForOldLayout:( UICollectionViewLayout* )fromLayout
                                          newLayout:( UICollectionViewLayout* )toLayout
{
    SEL delegateSelector = @selector( collectionView:transitionLayoutForOldLayout:newLayout: );
    if ( ![ self.gridModeTheme respondsToSelector: delegateSelector ]  )
    {
        return nil;
    }
    
    return [ self.gridModeTheme itemsBrowser: self
                transitionLayoutForOldLayout: fromLayout
                                   newLayout: toLayout ];
}



@end
