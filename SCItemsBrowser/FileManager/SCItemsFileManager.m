#import "SCItemsFileManager.h"

#import "SCItemsLevelRequestBuilder.h"
#import "SCItemsFileManagerCallbacks.h"

@interface SCItemsFileManager()

@property ( nonatomic, copy ) SCCancelAsyncOperation cancelLoaderBlock;

@end

@implementation SCItemsFileManager
{
    SCExtendedApiContext*          _apiContext;
    id<SCItemsLevelRequestBuilder> _nextLevelRequestBuilder;
}


#pragma mark -
#pragma mark constructors
-(void)dealloc
{
    self.cancelLoaderBlock = nil;
}

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithApiContext:( SCExtendedApiContext* )apiContext
              levelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder
{
    NSParameterAssert( nil != apiContext );
    NSParameterAssert( nil != nextLevelRequestBuilder );
    
    self = [ super init ];
    
    if ( nil == self )
    {
        return nil;
    }
    
    self->_apiContext = apiContext;
    self->_nextLevelRequestBuilder = nextLevelRequestBuilder;
    
    return self;
}


#pragma mark -
#pragma mark Public
-(void)loadLevelForItem:( SCItem* )item
              callbacks:( SCItemsFileManagerCallbacks* )callbacks
          ignoringCache:( BOOL )shouldIgnoreCache
{
    NSParameterAssert( nil != callbacks.onLevelLoadedBlock );
    
    SCExtendedAsyncOp loader = [ self buildLevelLoaderForItem: item
                                                ignoringCache: shouldIgnoreCache ];
    
    self.cancelLoaderBlock = loader( nil, nil, callbacks.onLevelLoadedBlock );
}

-(void)goToLevelUpNotifyingCallbacks:( SCItemsFileManagerCallbacks* )callbacks
{
    
}


#pragma mark -
#pragma mark loadLevelForItem
-(SCItemsReaderRequest*)buildLevelRequestForItem:( SCItem* )item
                                   ignoringCache:( BOOL )shouldIgnoreCache
{
    NSParameterAssert( nil != item );
    
    NSParameterAssert( nil != self->_apiContext );
    NSParameterAssert( nil != self->_nextLevelRequestBuilder );

    SCItemsReaderRequest* request = [ self->_nextLevelRequestBuilder levelDownRequestForItem: item ];

    NSParameterAssert( nil != request );
    
    if ( shouldIgnoreCache )
    {
        request.flags |= SCItemReaderRequestIngnoreCache;
    }

    return request;
}

-(SCExtendedAsyncOp)buildLevelLoaderForItem:( SCItem* )item
                              ignoringCache:( BOOL )shouldIgnoreCache
{
    SCItemsReaderRequest* request = [ self buildLevelLoaderForItem: item
                                                     ignoringCache: shouldIgnoreCache ];

    SCExtendedAsyncOp loader = [ self->_apiContext itemsReaderWithRequest: request ];
    return loader;
}

-(void)setCancelLoaderBlock:( SCCancelAsyncOperation )cancelLoaderBlock
{
    if ( nil != self->_cancelLoaderBlock )
    {
        self->_cancelLoaderBlock( YES );
    }
    
    self->_cancelLoaderBlock = cancelLoaderBlock;
}

#pragma mark -
#pragma mark goToLevelUpNotifyingCallbacks



@end
