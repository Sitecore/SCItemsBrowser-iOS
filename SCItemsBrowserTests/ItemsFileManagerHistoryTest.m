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
    SCExtendedApiContext* _context;
    SCApiContext* _legacyContext;
    
    StubRequestBuilder* _useCacheRequestBuilderStub;
    SCItem* _rootItemStub;
    
    
    SCItemsFileManager* _useCacheFm;
    SCLevelsHistory* _levelsHistory;
    
    ItemsLevelOperationBuilderHook* _hook;
}

-(void)setUp
{
    [ super setUp ];
    
    self->_legacyContext = [ SCApiContext contextWithHost: @"www.StubHost.net" ];
    self->_context = self->_legacyContext.extendedApiContext;
    self->_useCacheRequestBuilderStub = [ StubRequestBuilder new ];
    self->_useCacheRequestBuilderStub.requestStub = [ SCItemsReaderRequest new ];
    
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: nil
                                                 apiContext: self->_context ];

    
    self->_useCacheFm =
    [ [ SCItemsFileManager alloc ] initWithApiContext: self->_context
                                  levelRequestBuilder: self->_useCacheRequestBuilderStub ];
    
    self->_levelsHistory = [ self->_useCacheFm levelsHistory ];
}

-(void)tearDown
{
    self->_legacyContext = nil;
    self->_context = nil;
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
    
    LevelOperationFromRequestBuilder hookImpl = ^SCExtendedAsyncOp( SCItemsReaderRequest* request )
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

        XCTAssertNotNil( receivedResponse, @"invalid response" );
        XCTAssertNil( receivedError, @"unexpected" );
        
        
        [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                   callbacks: callbacks
                               ignoringCache: NO ];
        
        XCTAssertTrue( 2 == [ self->_levelsHistory currentLevel ], @"one element history expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastItem ], @"nil last item expected" );
        XCTAssertNotNil( [ self->_levelsHistory lastRequest ], @"nil last request expected" );
        XCTAssertNotNil( [ self->_levelsHistory levelUpParentItem ], @"nil levelUp item expected" );
        XCTAssertNotNil( [ self->_levelsHistory levelUpRequest ], @"nil levelUp request expected" );
        
        XCTAssertNotNil( receivedResponse, @"invalid response" );
        XCTAssertNil( receivedError, @"unexpected" );

        
    }
    [ self->_hook disableHook ];
    
    
}

@end
