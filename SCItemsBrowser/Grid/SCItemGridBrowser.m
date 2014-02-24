#import "SCItemGridBrowser.h"

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
    NSParameterAssert( nil != self->_rootItem   );

    
    NSAssert( NO, @"NOT IMPLEMENTED" );
}

-(void)reloadDataIgnoringCache:( BOOL )shouldIgnoreCache
{
    NSParameterAssert( nil != self->_apiContext );
    NSParameterAssert( nil != self->_rootItem   );
    
    NSAssert( NO, @"NOT IMPLEMENTED" );
}


#pragma mark - 
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:( UICollectionView* )collectionView
    numberOfItemsInSection:( NSInteger )section
{
    return 1;
}

-(UICollectionViewCell*)collectionView:( UICollectionView* )collectionView
                cellForItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSAssert( NO, @"NOT IMPLEMENTED" );
    return nil;
}


#pragma mark -
#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert( NO, @"NOT IMPLEMENTED" );
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert( NO, @"NOT IMPLEMENTED" );
}

@end
