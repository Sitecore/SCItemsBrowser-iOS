#import <SCItemsBrowser/FileManager/SCItemsFileManager.h>
#import <SCItemsBrowser/FileManager/SCItemsFileManagerCallbacks.h>

#import "SCItemRecord_UnitTest.h"
#import <SCItemsBrowserTests/SCItem+PrivateMethods.h>

NSTimeInterval SINGLE_REQUEST_TIMEOUT = 60;

@interface RootLevelFetchTest : GHAsyncTestCase
@end

@implementation RootLevelFetchTest
{
    SCExtendedApiContext* _context;
    SCApiContext* _legacyContext;
    
    SIBAllChildrenRequestBuilder* _allChildrenRequestBuilder;
    
    SCItem* _rootItemStub;
    SCItemRecord*  _rootItemRecord;
    
    SCItemsFileManager* _useCacheFm;
}

-(void)setUp
{
    [ super setUp ];

    self->_legacyContext = [ SCApiContext contextWithHost: @"http://mobiledev1ua1.dk.sitecore.net:722"
                                                    login: @"sitecore\\admin"
                                                 password: @"b" ];
    {
        self->_legacyContext.defaultDatabase = @"master";
        self->_legacyContext.defaultSite     = @"/sitecore/shell";
    }
    self->_context = self->_legacyContext.extendedApiContext;
    
    
    self->_allChildrenRequestBuilder = [ SIBAllChildrenRequestBuilder new ];
    
    self->_useCacheFm =
    [ [ SCItemsFileManager alloc ] initWithApiContext: self->_context
                                  levelRequestBuilder: self->_allChildrenRequestBuilder ];
    
    
    self->_rootItemRecord = [ SCItemRecord new ];
    {
        self->_rootItemRecord.path = @"/sitecore/content/home";
        self->_rootItemRecord.itemId = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}";
        self->_rootItemRecord.displayName = @"home";
    }
    
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: self->_rootItemRecord
                                                 apiContext: self->_context ];
}

-(void)tearDown
{
    self->_context       = nil;
    self->_legacyContext = nil;
    self->_rootItemStub  = nil;
    self->_allChildrenRequestBuilder = nil;
    
    [ super tearDown ];
}

-(void)testHomeChildrenAreFetchedCorrectly
{
    SEL thisTest = _cmd;

    
    __block SCLevelResponse* actualResponse = nil;
    __block NSError        * actualError    = nil;
    __block BOOL isDoneCallbackReached = NO;
    
    SCItemsFileManagerCallbacks* callbacks = [ SCItemsFileManagerCallbacks new ];
    {
        callbacks.onLevelLoadedBlock = ^void( SCLevelResponse* blockResponse, NSError* blockError )
        {
            isDoneCallbackReached = YES;

            actualError    = blockError;
            actualResponse = blockResponse;

            [ self notify: kGHUnitWaitStatusSuccess
              forSelector: thisTest ];
        };
    }
    
    [ self prepare: thisTest ];
    {
        dispatch_async( dispatch_get_main_queue() , ^void()
        {
            [ self->_useCacheFm loadLevelForItem: self->_rootItemStub
                                       callbacks: callbacks
                                   ignoringCache: YES ];
        } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];

    GHAssertTrue( isDoneCallbackReached, @"completion callback not reached" );
    
    GHAssertNotNil( actualResponse, @"invalid level response" );
    GHAssertNil( actualError, @"unexpected error" );
    
    GHAssertTrue( actualResponse.levelParentItem == self->_rootItemStub, @"root item mismatch" );
    GHAssertTrue( 4 == [ actualResponse.levelContentItems count ], @"children count mismatch" );
}

@end
