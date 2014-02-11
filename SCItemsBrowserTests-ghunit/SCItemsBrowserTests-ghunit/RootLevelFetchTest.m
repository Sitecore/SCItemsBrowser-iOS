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
    SCItemSourcePOD* _defaultItemSource;
    
    SIBAllChildrenRequestBuilder* _allChildrenRequestBuilder;
    
    
    SCItem* _rootItemStub;
    SCItemRecord*  _rootItemRecord;
    
    SCItemsFileManager* _useCacheFm;
    
    SCItemRecord*  _placeholderSettingsRecord;
    SCItem* _placeholderSettingsStub;
}

-(void)setUp
{
    [ super setUp ];

    self->_defaultItemSource = [ SCItemSourcePOD new ];
    self->_legacyContext = [ SCApiContext contextWithHost: @"http://mobiledev1ua1.dk.sitecore.net:722"
                                                    login: @"sitecore\\admin"
                                                 password: @"b" ];
    {
        self->_legacyContext.defaultDatabase = @"master";
        self->_legacyContext.defaultSite     = @"/sitecore/shell";
        
        
        self->_defaultItemSource.database = self->_legacyContext.defaultDatabase;
        self->_defaultItemSource.site     = self->_legacyContext.defaultSite    ;
        self->_defaultItemSource.language = self->_legacyContext.defaultLanguage;
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

    
    self->_placeholderSettingsRecord = [ SCItemRecord new ];
    {
        self->_placeholderSettingsRecord.path = @"/sitecore/layout/Placeholder Settings";
        self->_placeholderSettingsRecord.itemId = @"{1CE3B36C-9B0C-4EB5-A996-BFCB4EAA5287}";
        self->_placeholderSettingsRecord.displayName = @"Placeholder Settings";
    }
    self->_placeholderSettingsStub = [ [ SCItem alloc ] initWithRecord: self->_placeholderSettingsRecord
                                                            apiContext: self->_context ];
}

-(void)tearDown
{
    self->_context       = nil;
    self->_legacyContext = nil;
    self->_rootItemStub  = nil;
    self->_rootItemRecord = nil;
    
    self->_defaultItemSource = nil;
    
    self->_useCacheFm = nil;
    
    self->_placeholderSettingsRecord = nil;
    self->_placeholderSettingsStub   = nil;
    
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

-(void)testFakeLevelItemIsAddedToInnerLevels
{
    SEL thisTest = _cmd;
    
    
    __block SCLevelResponse* actualResponse = nil;
    __block NSError        * actualError    = nil;
    __block BOOL             isDoneCallbackReached = NO;
    
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
////////

    
    actualResponse = nil;
    actualError    = nil;
    isDoneCallbackReached = NO;
    
    SCItem* allowedParentItem =
    [ self->_context itemWithPath: @"/sitecore/content/Home/Allowed_Parent"
                       itemSource: self->_defaultItemSource ];
    
    [ self prepare: thisTest ];
    {
        dispatch_async( dispatch_get_main_queue() , ^void()
        {
           [ self->_useCacheFm loadLevelForItem: allowedParentItem
                                      callbacks: callbacks
                                  ignoringCache: YES ];
        } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];
    
    
    GHAssertTrue( isDoneCallbackReached, @"completion callback not reached" );
    
    GHAssertNotNil( actualResponse, @"invalid level response" );
    GHAssertNil( actualError, @"unexpected error" );
    
    GHAssertTrue( actualResponse.levelParentItem == allowedParentItem, @"level item mismatch" );
    GHAssertTrue( 3 == [ actualResponse.levelContentItems count ], @"children count mismatch" );
    
    GHAssertTrue( [ actualResponse.levelContentItems[0] isMemberOfClass: [ SCLevelUpItem class ] ], @"levelup item not found" );
}

-(void)testLevelUpReturnsSameItemsAtRootLevel
{
    SEL thisTest = _cmd;
    
    
    NSArray* rootChildrenBeforeLevelUp = nil;
    NSArray* rootChildrenAfterLevelUp  = nil;
    
    NSArray* rootChildrenIdsBeforeLevelUp = nil;
    NSArray* rootChildrenIdsAfterLevelUp = nil;
    
    __block SCLevelResponse* actualResponse = nil;
    __block NSError        * actualError    = nil;
    __block BOOL             isDoneCallbackReached = NO;
    
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

    rootChildrenBeforeLevelUp = actualResponse.levelContentItems;
    rootChildrenIdsBeforeLevelUp = [ rootChildrenBeforeLevelUp map:^NSString*(SCItem* object)
    {
        return object.itemId;
    } ];
    ////////
    
    

    
    
    actualResponse = nil;
    actualError    = nil;
    isDoneCallbackReached = NO;
    
    SCItem* allowedParentItem = [ self->_context itemWithPath: @"/sitecore/content/Home/Allowed_Parent"
                                                   itemSource: self->_defaultItemSource ];
    
    [ self prepare: thisTest ];
    {
        dispatch_async( dispatch_get_main_queue() , ^void()
       {
           [ self->_useCacheFm loadLevelForItem: allowedParentItem
                                      callbacks: callbacks
                                  ignoringCache: YES ];
       } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];
////////

    
    [ self prepare: thisTest ];
    {
        dispatch_async( dispatch_get_main_queue() , ^void()
       {
           [ self->_useCacheFm goToLevelUpNotifyingCallbacks: callbacks ];
       } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];
    
    
    rootChildrenAfterLevelUp = actualResponse.levelContentItems;
    rootChildrenIdsAfterLevelUp = [ rootChildrenAfterLevelUp map:^NSString*(SCItem* object)
   {
       return object.itemId;
   } ];

    
    GHAssertEqualObjects( rootChildrenIdsAfterLevelUp, rootChildrenIdsBeforeLevelUp, @"id array mismatch" );
}

@end
