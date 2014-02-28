#import <XCTest/XCTest.h>


#import "SCItemsFileManager.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>
#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItemsFileManager+UnitTest.h"
#import "SCItem+PrivateMethods.h"

#import "ItemsBrowserTestStubs.h"
#import "ItemsLevelOperationBuilderHook.h"
#import "SCItemsFileManagerCallbacks.h"

#import "SCLevelsHistory.h"

@interface ItemsFileManagerHistoryTest : XCTestCase
@end

@implementation ItemsFileManagerHistoryTest
{
    SCExtendedApiSession* _session;
    SCApiSession* _legacySession;
    
    StubRequestBuilder* _useCacheRequestBuilderStub;
    SCItem* _rootItemStub;
    
    
    SCItemsFileManager* _useCacheFm;
    SCLevelsHistory* _levelsHistory;
    
    ItemsLevelOperationBuilderHook* _hook;
}

-(void)setUp
{
    [ super setUp ];
    
    self->_legacySession = [ SCApiSession sessionWithHost: @"www.StubHost.net" ];
    self->_session = self->_legacySession.extendedApiSession;
    self->_useCacheRequestBuilderStub = [ StubRequestBuilder new ];
    self->_useCacheRequestBuilderStub.requestStub = [ SCReadItemsRequest new ];
    
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: nil
                                                 apiSession: self->_session ];

    
    self->_useCacheFm =
    [ [ SCItemsFileManager alloc ] initWithApiSession: self->_session
                                  levelRequestBuilder: self->_useCacheRequestBuilderStub ];
    
    self->_levelsHistory = [ self->_useCacheFm levelsHistory ];
}

-(void)tearDown
{
    self->_legacySession = nil;
    self->_session = nil;
    self->_useCacheRequestBuilderStub = nil;
    self->_rootItemStub = nil;
    self->_useCacheFm = nil;
    
    [ super tearDown ];
}

-(void)testLevelIsStoredAfterSuccessfullFetch
{
    __block SCLevelResponse* receivedResponse = nil;
    __block NSError* receivedError            = nil;
    
    SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
    {
        callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* response, NSError* error )
        {
            receivedResponse = response;
            receivedError    = error   ;
        };
    }
    
    LevelOperationFromRequestBuilder hookImpl = ^SCExtendedAsyncOp( SCReadItemsRequest* request )
    {
        SCExtendedAsyncOp result = ^SCCancelAsyncOperation(
            SCAsyncOperationProgressHandler progressCallback,
            SCCancelAsyncOperationHandler cancelCallback,
            SCDidFinishAsyncOperationHandler doneCallback)
        {
            SCCancelAsyncOperation cancelBlockStub = ^void( BOOL isUnsubscribe )
            {
              //idle
            };

            doneCallback( @[], nil );
            return [ cancelBlockStub copy ];
        };

        return [ result copy ];
    };
    self->_hook = [ [ ItemsLevelOperationBuilderHook alloc ] initWithHookImpl: hookImpl ];

    
    XCTAssertTrue( 0 == [ self->_levelsHistory currentLevel ], @"empty history expected" );
    XCTAssertNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
    XCTAssertNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
    XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
    XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
    
    XCTAssertFalse( [ self->_useCacheFm isRootLevelLoaded ], @"root level is already loaded for some reason" );
    XCTAssertFalse( [ self->_levelsHistory isRootLevelLoaded ], @"root level is already loaded for some reason" );
    
    [ self->_hook enableHook ];
    {
        [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                   callbacks: callbacks
                               ignoringCache: NO ];
        
        XCTAssertTrue( 1 == [ self->_levelsHistory currentLevel ], @"one element history expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );

        XCTAssertTrue( [ self->_useCacheFm isRootLevelLoaded ], @"root level must have been loaded" );
        XCTAssertTrue( [ self->_levelsHistory isRootLevelLoaded ], @"root level must have been loaded" );

        XCTAssertNotNil( receivedResponse, @"invalid response" );
        XCTAssertNil( receivedError, @"unexpected" );
        XCTAssertTrue( 0 == [ receivedResponse.levelContentItems count ], @"empty list of children expected" );
        
        
        [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                   callbacks: callbacks
                               ignoringCache: NO ];
        
        XCTAssertTrue( 2 == [ self->_levelsHistory currentLevel ], @"two element history expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
        XCTAssertNotNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
        XCTAssertNotNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
        
        
        XCTAssertTrue( [ self->_useCacheFm isRootLevelLoaded ], @"root level must have been loaded" );
        XCTAssertTrue( [ self->_levelsHistory isRootLevelLoaded ], @"root level must have been loaded" );
        
        XCTAssertNotNil( receivedResponse, @"invalid response" );
        XCTAssertNil( receivedError, @"unexpected" );
        
        XCTAssertTrue( 1 == [ receivedResponse.levelContentItems count ], @"list of levelUp item only expected" );
        XCTAssertTrue( [ [ receivedResponse.levelContentItems lastObject ] isMemberOfClass: [ SCLevelUpItem class ] ], @"level up item class mismatch" );
        
    }
    [ self->_hook disableHook ];
}

-(void)testLevelIsNotStoredAfterFailedFetch
{
    __block SCLevelResponse* receivedResponse = nil;
    __block NSError* receivedError            = nil;
    
    SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
    {
        callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* response, NSError* error )
        {
            receivedResponse = response;
            receivedError    = error   ;
        };
    }
    
    LevelOperationFromRequestBuilder hookImpl = ^SCExtendedAsyncOp( SCReadItemsRequest* request )
    {
        SCExtendedAsyncOp result = ^SCCancelAsyncOperation(
           SCAsyncOperationProgressHandler progressCallback,
           SCCancelAsyncOperationHandler cancelCallback,
           SCDidFinishAsyncOperationHandler doneCallback)
        {
            SCCancelAsyncOperation cancelBlockStub = ^void( BOOL isUnsubscribe )
            {
                //idle
            };
            
            NSError* mockError = [ NSError errorWithDomain: @"mock.domain"
                                                      code: 222
                                                  userInfo: nil ];
            
            doneCallback( nil, mockError );
            return [ cancelBlockStub copy ];
        };
        
        return [ result copy ];
    };
    self->_hook = [ [ ItemsLevelOperationBuilderHook alloc ] initWithHookImpl: hookImpl ];
    
    
    XCTAssertTrue( 0 == [ self->_levelsHistory currentLevel ], @"empty history expected" );
    XCTAssertNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
    XCTAssertNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
    XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
    XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
    
    
    XCTAssertFalse( [ self->_useCacheFm isRootLevelLoaded ], @"root level is already loaded for some reason" );
    XCTAssertFalse( [ self->_levelsHistory isRootLevelLoaded ], @"root level is already loaded for some reason" );
    
    [ self->_hook enableHook ];
    {
        [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                   callbacks: callbacks
                               ignoringCache: NO ];
        
        XCTAssertTrue( 0 == [ self->_levelsHistory currentLevel ], @"one element history expected" );
        XCTAssertNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
        XCTAssertNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
        
        
        XCTAssertFalse( [ self->_useCacheFm isRootLevelLoaded ], @"root level is loaded despite error" );
        XCTAssertFalse( [ self->_levelsHistory isRootLevelLoaded ], @"root level is loaded despite error" );
        
        XCTAssertNil( receivedResponse, @"invalid response" );
        XCTAssertNotNil( receivedError, @"unexpected" );
    }
    [ self->_hook disableHook ];
}

-(void)testLevelIsNotStoredAfterCancelledFetch
{
    __block SCLevelResponse* receivedResponse = nil;
    __block NSError* receivedError            = nil;
    __block BOOL isCompletionInvoked = NO;
    
    SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
    {
        callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* response, NSError* error )
        {
            isCompletionInvoked = YES;
            
            receivedResponse = response;
            receivedError    = error   ;
        };
    }
    
    LevelOperationFromRequestBuilder hookImpl = ^SCExtendedAsyncOp( SCReadItemsRequest* request )
    {
        SCExtendedAsyncOp result = ^SCCancelAsyncOperation(
                                                           SCAsyncOperationProgressHandler progressCallback,
                                                           SCCancelAsyncOperationHandler cancelCallback,
                                                           SCDidFinishAsyncOperationHandler doneCallback)
        {
            SCCancelAsyncOperation cancelBlockStub = ^void( BOOL isUnsubscribe )
            {
                //idle
            };
            
            if ( nil != cancelCallback )
            {
                cancelCallback( YES );
            }
            return [ cancelBlockStub copy ];
        };
        
        return [ result copy ];
    };
    self->_hook = [ [ ItemsLevelOperationBuilderHook alloc ] initWithHookImpl: hookImpl ];
    
    
    XCTAssertTrue( 0 == [ self->_levelsHistory currentLevel ], @"empty history expected" );
    XCTAssertNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
    XCTAssertNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
    XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
    XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
    XCTAssertFalse( [ self->_levelsHistory isRootLevelLoaded ], @"root level is already loaded for some reason" );
    
    [ self->_hook enableHook ];
    {
        [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                   callbacks: callbacks
                               ignoringCache: NO ];
        
        XCTAssertTrue( 0 == [ self->_levelsHistory currentLevel ], @"one element history expected" );
        XCTAssertNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
        XCTAssertNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
        XCTAssertFalse( [ self->_levelsHistory isRootLevelLoaded ], @"root level is already loaded for some reason" );
        
        XCTAssertFalse(isCompletionInvoked, @"unexpected completion block invocation" );
    }
    [ self->_hook disableHook ];
}

-(void)testLevelIsPoppedAfterSuccessfullLevelUp
{
    __block SCLevelResponse* receivedResponse = nil;
    __block NSError* receivedError            = nil;
    
    SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
    {
        callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* response, NSError* error )
        {
            receivedResponse = response;
            receivedError    = error   ;
        };
    }
    
    LevelOperationFromRequestBuilder hookImpl = ^SCExtendedAsyncOp( SCReadItemsRequest* request )
    {
        SCExtendedAsyncOp result = ^SCCancelAsyncOperation(
                                                           SCAsyncOperationProgressHandler progressCallback,
                                                           SCCancelAsyncOperationHandler cancelCallback,
                                                           SCDidFinishAsyncOperationHandler doneCallback)
        {
            SCCancelAsyncOperation cancelBlockStub = ^void( BOOL isUnsubscribe )
            {
                //idle
            };
            
            doneCallback( @[], nil );
            return [ cancelBlockStub copy ];
        };
        
        return [ result copy ];
    };
    self->_hook = [ [ ItemsLevelOperationBuilderHook alloc ] initWithHookImpl: hookImpl ];
    
    
    [ self->_hook enableHook ];
    {
        [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                   callbacks: callbacks
                               ignoringCache: NO ];

        
        [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                   callbacks: callbacks
                               ignoringCache: NO ];
        
        XCTAssertTrue( 2 == [ self->_levelsHistory currentLevel ], @"two element history expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
        XCTAssertNotNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
        XCTAssertNotNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
        XCTAssertNotNil( receivedResponse, @"invalid response" );
        XCTAssertNil( receivedError, @"unexpected" );
        XCTAssertTrue( [ self->_levelsHistory isRootLevelLoaded ], @"root level should already be loaded" );
        
        
        [ self->_useCacheFm goToLevelUpNotifyingCallbacks: callbacks ];
        XCTAssertTrue( 1 == [ self->_levelsHistory currentLevel ], @"one element history expected" );
        XCTAssertTrue( 1 == [ self->_levelsHistory currentLevel ], @"one element history expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
        XCTAssertTrue( [ self->_levelsHistory isRootLevelLoaded ], @"root level should already be loaded" );
        XCTAssertNotNil( receivedResponse, @"invalid response" );
        XCTAssertNil( receivedError, @"unexpected" );
    }
    [ self->_hook disableHook ];
}

-(void)testLevelUpWhenNotInitializedProducesCrash
{
    __block SCLevelResponse* receivedResponse = nil;
    __block NSError* receivedError            = nil;
    
    SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
    {
        callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* response, NSError* error )
        {
            receivedResponse = response;
            receivedError    = error   ;
        };
    }
    
    XCTAssertThrows
    (
       [ self->_useCacheFm goToLevelUpNotifyingCallbacks: callbacks ],
       @"assert expected"
    );
}

-(void)testLevelUpFromRootLevelProducesCrash
{
    __block SCLevelResponse* receivedResponse = nil;
    __block NSError* receivedError            = nil;
    
    SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
    {
        callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* response, NSError* error )
        {
            receivedResponse = response;
            receivedError    = error   ;
        };
    }
    
    LevelOperationFromRequestBuilder hookImpl = ^SCExtendedAsyncOp( SCReadItemsRequest* request )
    {
        SCExtendedAsyncOp result = ^SCCancelAsyncOperation(
           SCAsyncOperationProgressHandler progressCallback,
           SCCancelAsyncOperationHandler cancelCallback,
           SCDidFinishAsyncOperationHandler doneCallback)
        {
            SCCancelAsyncOperation cancelBlockStub = ^void( BOOL isUnsubscribe )
            {
                //idle
            };
            
            doneCallback( @[], nil );
            return [ cancelBlockStub copy ];
        };
        
        return [ result copy ];
    };
    self->_hook = [ [ ItemsLevelOperationBuilderHook alloc ] initWithHookImpl: hookImpl ];
    
    
    XCTAssertTrue( 0 == [ self->_levelsHistory currentLevel ], @"empty history expected" );
    XCTAssertNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
    XCTAssertNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
    XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
    XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
    
    
    XCTAssertFalse( [ self->_useCacheFm isRootLevelLoaded ], @"root level is already loaded for some reason" );
    XCTAssertFalse( [ self->_levelsHistory isRootLevelLoaded ], @"root level is already loaded for some reason" );
    
    [ self->_hook enableHook ];
    {
        [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                   callbacks: callbacks
                               ignoringCache: NO ];
        
        XCTAssertTrue( 1 == [ self->_levelsHistory currentLevel ], @"one element history expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
        XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
        
        XCTAssertTrue( [ self->_useCacheFm isRootLevelLoaded ], @"root level must have been loaded" );
        XCTAssertTrue( [ self->_levelsHistory isRootLevelLoaded ], @"root level must have been loaded" );
        
        XCTAssertNotNil( receivedResponse, @"invalid response" );
        XCTAssertNil( receivedError, @"unexpected" );
        XCTAssertTrue( 0 == [ receivedResponse.levelContentItems count ], @"empty list of children expected" );
        
        XCTAssertThrows
        (
         [ self->_useCacheFm goToLevelUpNotifyingCallbacks: callbacks ],
         @"assert expected"
         );
    }
    [ self->_hook disableHook ];
}

-(void)testReloadLevelDoesNotChangeHistory
{
   __block SCLevelResponse* receivedResponse = nil;
   __block NSError* receivedError            = nil;
   
   SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
   {
      callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* response, NSError* error )
      {
         receivedResponse = response;
         receivedError    = error   ;
      };
   }
   
   LevelOperationFromRequestBuilder hookImpl = ^SCExtendedAsyncOp( SCReadItemsRequest* request )
   {
      SCExtendedAsyncOp result = ^SCCancelAsyncOperation(
                                                         SCAsyncOperationProgressHandler progressCallback,
                                                         SCCancelAsyncOperationHandler cancelCallback,
                                                         SCDidFinishAsyncOperationHandler doneCallback)
      {
         SCCancelAsyncOperation cancelBlockStub = ^void( BOOL isUnsubscribe )
         {
            //idle
         };
         
         doneCallback( @[], nil );
         return [ cancelBlockStub copy ];
      };
      
      return [ result copy ];
   };
   self->_hook = [ [ ItemsLevelOperationBuilderHook alloc ] initWithHookImpl: hookImpl ];
   
   
   XCTAssertTrue( 0 == [ self->_levelsHistory currentLevel ], @"empty history expected" );
   XCTAssertNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
   XCTAssertNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
   XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
   XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
   
   XCTAssertFalse( [ self->_useCacheFm isRootLevelLoaded ], @"root level is already loaded for some reason" );
   XCTAssertFalse( [ self->_levelsHistory isRootLevelLoaded ], @"root level is already loaded for some reason" );
   
   [ self->_hook enableHook ];
   {
      [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                 callbacks: callbacks
                             ignoringCache: NO ];
      
      XCTAssertTrue( 1 == [ self->_levelsHistory currentLevel ], @"one element history expected" );
      XCTAssertNotNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
      XCTAssertNotNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
      XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
      XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
      
      XCTAssertTrue( [ self->_useCacheFm isRootLevelLoaded ], @"root level must have been loaded" );
      XCTAssertTrue( [ self->_levelsHistory isRootLevelLoaded ], @"root level must have been loaded" );
      
      XCTAssertNotNil( receivedResponse, @"invalid response" );
      XCTAssertNil( receivedError, @"unexpected" );
      XCTAssertTrue( 0 == [ receivedResponse.levelContentItems count ], @"empty list of children expected" );
      
      
      [ self->_useCacheFm reloadCurrentLevelNotifyingCallbacks: callbacks
                                                 ignoringCache: NO ];
      
      XCTAssertTrue( 1 == [ self->_levelsHistory currentLevel ], @"one element history expected" );
      XCTAssertNotNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
      XCTAssertNotNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
      XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
      XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
      
      XCTAssertTrue( [ self->_useCacheFm isRootLevelLoaded ], @"root level must have been loaded" );
      XCTAssertTrue( [ self->_levelsHistory isRootLevelLoaded ], @"root level must have been loaded" );
      
      XCTAssertNotNil( receivedResponse, @"invalid response" );
      XCTAssertNil( receivedError, @"unexpected" );
      XCTAssertTrue( 0 == [ receivedResponse.levelContentItems count ], @"empty list of children expected" );
   }
   [ self->_hook disableHook ];
}

-(void)testReloadLevelRequiresRootItem
{
   __block SCLevelResponse* receivedResponse = nil;
   __block NSError* receivedError            = nil;
   
   SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
   {
      callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* response, NSError* error )
      {
         receivedResponse = response;
         receivedError    = error   ;
      };
   }
   
   LevelOperationFromRequestBuilder hookImpl = ^SCExtendedAsyncOp( SCReadItemsRequest* request )
   {
      SCExtendedAsyncOp result = ^SCCancelAsyncOperation(
                                                         SCAsyncOperationProgressHandler progressCallback,
                                                         SCCancelAsyncOperationHandler cancelCallback,
                                                         SCDidFinishAsyncOperationHandler doneCallback)
      {
         SCCancelAsyncOperation cancelBlockStub = ^void( BOOL isUnsubscribe )
         {
            //idle
         };
         
         doneCallback( @[], nil );
         return [ cancelBlockStub copy ];
      };
      
      return [ result copy ];
   };
   self->_hook = [ [ ItemsLevelOperationBuilderHook alloc ] initWithHookImpl: hookImpl ];
   
   
   XCTAssertTrue( 0 == [ self->_levelsHistory currentLevel ], @"empty history expected" );
   XCTAssertNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
   XCTAssertNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
   XCTAssertNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
   XCTAssertNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
   
   XCTAssertFalse( [ self->_useCacheFm isRootLevelLoaded ], @"root level is already loaded for some reason" );
   XCTAssertFalse( [ self->_levelsHistory isRootLevelLoaded ], @"root level is already loaded for some reason" );
   
   [ self->_hook enableHook ];
   {
      XCTAssertThrows
      (
         [ self->_useCacheFm reloadCurrentLevelNotifyingCallbacks: callbacks
                                                    ignoringCache: NO ],
         @"assert expected"
      );
   }
   [ self->_hook disableHook ];

}

@end
