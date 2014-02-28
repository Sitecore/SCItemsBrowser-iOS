#import "SCAbstractItemsBrowser.h"
#import "SCAbstractItemsBrowserSubclassing.h"


#import "SCLevelUpItem.h"

@interface SCAbstractItemsBrowser()<SCAbstractItemsBrowserSubclassing>

// unit test
@property ( nonatomic, assign, readonly ) dispatch_once_t     onceItemsFileManagerToken;
@property ( nonatomic, strong, readonly ) SCItemsFileManager* itemsFileManager         ;

// protected
@property ( nonatomic, strong ) SCLevelResponse* loadedLevel;

@end

@implementation SCAbstractItemsBrowser
{
    dispatch_once_t _onceItemsFileManagerToken;
    SCItemsFileManager* _itemsFileManager;
}

-(void)didSelectItem:( id )selectedItem
         atIndexPath:( NSIndexPath* )indexPath
{
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

-(void)reloadContentView
{
    [ self doesNotRecognizeSelector: _cmd ];
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
    SCExtendedApiSession* session = self->_apiSession;
    id<SCItemsLevelRequestBuilder> nextLevelRequestBuilder = self->_nextLevelRequestBuilder;
    
    NSParameterAssert( nil != session );
    NSParameterAssert( nil != nextLevelRequestBuilder );
    
    // @adk : in case asserts are disabled or ignored
    // Returning nil to avoid exceptions within dispatch_once()
    if ( nil == session || nil == nextLevelRequestBuilder )
    {
        return nil;
    }
    
    dispatch_once(&self->_onceItemsFileManagerToken, ^void()
    {
      self->_itemsFileManager =
      [ [ SCItemsFileManager alloc ] initWithApiSession: session
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
-(void)setApiSession:( SCExtendedApiSession* )value
{
    NSParameterAssert( nil == self->_apiSession );
    self->_apiSession = value;
}

-(void)setRootItem:( SCItem* )rootItem
{
    NSParameterAssert( nil == self->_rootItem );
    self->_rootItem = rootItem;
}

-(void)setDelegate:( id<SCItemsBrowserDelegate> )delegate
{
    NSParameterAssert( nil == self->_delegate );
    self->_delegate = delegate;
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
    NSParameterAssert( nil != self->_apiSession );
    NSParameterAssert( nil != self->_rootItem );
    
    [ self disposeLazyItemsFileManager ];
    
    SCItemsFileManagerCallbacks* fmCallbacks = [ self newCallbacksForItemsFileManager ];
    [ self.lazyItemsFileManager loadLevelForItem: self->_rootItem
                                       callbacks: fmCallbacks
                                   ignoringCache: NO ];
}


-(void)onLevelReloadFailedWithError:( NSError* )levelError
{
    [ self.delegate itemsBrowser: self
     levelLoadingFailedWithError: levelError ];
}

-(void)onLevelReloaded:( SCLevelResponse* )levelResponse
{
    NSParameterAssert( nil != levelResponse );
    NSParameterAssert( nil != levelResponse.levelParentItem );
    
    self->_loadedLevel = levelResponse;
    [ self reloadContentView ];
    
    [ self.delegate itemsBrowser: self
             didLoadLevelForItem: levelResponse.levelParentItem ];
}

-(SCItemsFileManagerCallbacks*)newCallbacksForItemsFileManager
{
    __weak SCAbstractItemsBrowser* weakSelf = self;
    
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
//    NSParameterAssert( nil != self->_collectionView  );
    NSParameterAssert( nil != self->_rootItem   );
    NSParameterAssert( nil != self->_apiSession );
    
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

@end
