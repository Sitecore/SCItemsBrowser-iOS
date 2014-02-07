#import "SCItemsFileManager.h"

#import "SCItemsLevelRequestBuilder.h"
#import "SCItemsFileManagerCallbacks.h"

#import "SCLevelsHistory.h"
#import "SCLevelResponse.h"

typedef void(^UpdateHistoryActionBlock)(void);

@interface SCItemsFileManager()

@property ( nonatomic, copy ) SCCancelAsyncOperation cancelLoaderBlock;
@property ( nonatomic ) SCLevelsHistory* levelsHistory;

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
    self->_levelsHistory = [ SCLevelsHistory new ];
    
    return self;
}


#pragma mark -
#pragma mark Public
-(void)loadLevelForItem:( SCItem* )item
              callbacks:( SCItemsFileManagerCallbacks* )callbacks
          ignoringCache:( BOOL )shouldIgnoreCache
{
    NSParameterAssert( nil != callbacks.onLevelLoadedBlock );
    
    SCItemsReaderRequest* request = [ self buildLevelRequestForItem: item
                                                      ignoringCache: shouldIgnoreCache ];
    SCExtendedAsyncOp loader = [ self levelLoaderFromRequest: request ];

    
    SCLevelsHistory* levelsHistory = self->_levelsHistory;
    OnLevelLoadedBlock originalCompletion = [ callbacks.onLevelLoadedBlock copy ];
    UpdateHistoryActionBlock pushLevelAction = ^void(void)
    {
        [ levelsHistory pushRequest: request
                            forItem: item ];
    };

    SCDidFinishAsyncOperationHandler completionHook = [ self hookLevelCompletion: originalCompletion
                                                               byUpdatingHistory: pushLevelAction
                                                               parentItemOfLevel: item ];
    
    self.cancelLoaderBlock = loader(
        callbacks.onLevelProgressBlock,
        nil,
        completionHook );
}

-(void)goToLevelUpNotifyingCallbacks:( SCItemsFileManagerCallbacks* )callbacks
{
    
    SCItemsReaderRequest* request = [ self->_levelsHistory levelUpRequest ];
    SCItem* levelUpParentItem     = [ self->_levelsHistory levelUpParentItem ];
    
    // set cache flag to zero
    request.flags &= SCItemReaderRequestReadFieldsValues;
    
    
    SCLevelsHistory* levelsHistory = self->_levelsHistory;
    OnLevelLoadedBlock originalCompletion = [ callbacks.onLevelLoadedBlock copy ];
    UpdateHistoryActionBlock popLevelAction = ^void(void)
    {
        [ levelsHistory popRequest ];
    };
    
    SCDidFinishAsyncOperationHandler completionHook = [ self hookLevelCompletion: originalCompletion
                                                               byUpdatingHistory: popLevelAction
                                                               parentItemOfLevel: levelUpParentItem ];
    
    
    SCExtendedAsyncOp loader = [ self levelLoaderFromRequest: request ];
    self.cancelLoaderBlock = loader(
        callbacks.onLevelProgressBlock,
        nil,
        completionHook );
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
-(SCDidFinishAsyncOperationHandler)hookLevelCompletion:( OnLevelLoadedBlock )originalCompletion
                                     byUpdatingHistory:( UpdateHistoryActionBlock )actionBlock
                                     parentItemOfLevel:( SCItem* )item
{
    SCDidFinishAsyncOperationHandler completionHook = ^void( NSArray* loadedItems, NSError *error )
    {
        SCLevelResponse* response = nil;
        
        if ( nil != loadedItems )
        {
            NSParameterAssert( nil == error );
            actionBlock();
            
            response = [ [ SCLevelResponse alloc ] initWithItem: item
                                              levelContentItems: loadedItems ];
        }
        
        originalCompletion( response, error );
    };
    
    return [ completionHook copy ];
}

-(SCExtendedAsyncOp)levelLoaderFromRequest:( SCItemsReaderRequest* )request
{
    return [ self->_apiContext itemsReaderWithRequest: request ];
}

@end
