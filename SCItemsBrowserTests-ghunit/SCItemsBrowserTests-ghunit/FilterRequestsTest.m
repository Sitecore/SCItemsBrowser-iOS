static const NSTimeInterval SINGLE_REQUEST_TIMEOUT = 60;


@interface FilterRequestsTest : GHAsyncTestCase
@end


@implementation FilterRequestsTest
{
    SCExtendedApiSession* _context;
    SCApiSession* _legacyContext;
    SCItemSourcePOD* _defaultItemSource;
    
    
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
    self->_legacyContext = [ SCApiSession sessionWithHost: @"http://mobiledev1ua1.dk.sitecore.net:722"
                                                    login: @"sitecore\\admin"
                                                 password: @"b" ];
    {
        self->_legacyContext.defaultDatabase = @"master";
        self->_legacyContext.defaultSite     = @"/sitecore/shell";
        
        
        self->_defaultItemSource.database = self->_legacyContext.defaultDatabase;
        self->_defaultItemSource.site     = self->_legacyContext.defaultSite    ;
        self->_defaultItemSource.language = self->_legacyContext.defaultLanguage;
    }
    self->_context = self->_legacyContext.extendedApiSession;
    

    
    self->_rootItemRecord = [ SCItemRecord new ];
    {
        self->_rootItemRecord.path = @"/sitecore/content/home";
        self->_rootItemRecord.itemId = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}";
        self->_rootItemRecord.displayName = @"home";
    }
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: self->_rootItemRecord
                                                 apiSession: self->_context ];
    
    
    self->_placeholderSettingsRecord = [ SCItemRecord new ];
    {
        self->_placeholderSettingsRecord.path = @"/sitecore/layout";
        self->_placeholderSettingsRecord.itemId = @"{EB2E4FFD-2761-4653-B052-26A64D385227}";
        self->_placeholderSettingsRecord.displayName = @"Layout";
    }
    self->_placeholderSettingsStub = [ [ SCItem alloc ] initWithRecord: self->_placeholderSettingsRecord
                                                            apiSession: self->_context ];
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
    
    [ super tearDown ];
}

-(void)testWhiteListFilterForSingleTemplate
{
    SEL thisTest = _cmd;
    
    SIBWhiteListTemplateRequestBuilder* foldersOnlyrequestBuilder = [ [ SIBWhiteListTemplateRequestBuilder alloc ] initWithTemplateNames: @[ @"Folder" ] ];
    
    self->_useCacheFm =
    [ [ SCItemsFileManager alloc ] initWithApiSession: self->_context
                                  levelRequestBuilder: foldersOnlyrequestBuilder ];

    GHAssertNotNil( self->_useCacheFm, @"items file manager initialization error" );
    
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
           [ self->_useCacheFm loadLevelForItem: self->_placeholderSettingsStub
                                      callbacks: callbacks
                                  ignoringCache: YES ];
       } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];
    
    GHAssertTrue( isDoneCallbackReached, @"completion callback not reached" );
    
    GHAssertNotNil( actualResponse, @"invalid level response" );
    GHAssertNil( actualError, @"unexpected error" );
    
    GHAssertTrue( actualResponse.levelParentItem == self->_placeholderSettingsStub, @"root item mismatch" );
    GHAssertTrue( 2 == [ actualResponse.levelContentItems count ], @"children count mismatch" );
}

-(void)testWhiteListFilterForMultipleTemplates
{
    SEL thisTest = _cmd;
    
    SIBWhiteListTemplateRequestBuilder* foldersOnlyrequestBuilder = [ [ SIBWhiteListTemplateRequestBuilder alloc ] initWithTemplateNames: @[ @"Folder", @"Node" ] ];
    
    self->_useCacheFm =
    [ [ SCItemsFileManager alloc ] initWithApiSession: self->_context
                                  levelRequestBuilder: foldersOnlyrequestBuilder ];
    
    GHAssertNotNil( self->_useCacheFm, @"items file manager initialization error" );
    
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
           [ self->_useCacheFm loadLevelForItem: self->_placeholderSettingsStub
                                      callbacks: callbacks
                                  ignoringCache: YES ];
       } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];
    
    GHAssertTrue( isDoneCallbackReached, @"completion callback not reached" );
    
    GHAssertNotNil( actualResponse, @"invalid level response" );
    GHAssertNil( actualError, @"unexpected error" );
    
    GHAssertTrue( actualResponse.levelParentItem == self->_placeholderSettingsStub, @"root item mismatch" );
    GHAssertTrue( 8 == [ actualResponse.levelContentItems count ], @"children count mismatch" );
}

-(void)testBlackListFilterForSingleTemplate
{
    SEL thisTest = _cmd;
    
    SIBBlackListTemplateRequestBuilder* foldersOnlyrequestBuilder = [ [ SIBBlackListTemplateRequestBuilder alloc ] initWithTemplateNames: @[ @"Folder" ] ];
    
    self->_useCacheFm =
    [ [ SCItemsFileManager alloc ] initWithApiSession: self->_context
                                  levelRequestBuilder: foldersOnlyrequestBuilder ];
    
    GHAssertNotNil( self->_useCacheFm, @"items file manager initialization error" );
    
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
                           [ self->_useCacheFm loadLevelForItem: self->_placeholderSettingsStub
                                                      callbacks: callbacks
                                                  ignoringCache: YES ];
                       } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];
    
    GHAssertTrue( isDoneCallbackReached, @"completion callback not reached" );
    
    GHAssertNotNil( actualResponse, @"invalid level response" );
    GHAssertNil( actualError, @"unexpected error" );
    
    GHAssertTrue( actualResponse.levelParentItem == self->_placeholderSettingsStub, @"root item mismatch" );
    GHAssertTrue( 6 == [ actualResponse.levelContentItems count ], @"children count mismatch" );
}

-(void)testBlackListFilterForMultipleTemplates
{
    SEL thisTest = _cmd;
    
    SIBBlackListTemplateRequestBuilder* foldersOnlyrequestBuilder = [ [ SIBBlackListTemplateRequestBuilder alloc ] initWithTemplateNames: @[ @"Folder", @"Node" ] ];
    
    self->_useCacheFm =
    [ [ SCItemsFileManager alloc ] initWithApiSession: self->_context
                                  levelRequestBuilder: foldersOnlyrequestBuilder ];
    
    GHAssertNotNil( self->_useCacheFm, @"items file manager initialization error" );
    
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
           [ self->_useCacheFm loadLevelForItem: self->_placeholderSettingsStub
                                      callbacks: callbacks
                                  ignoringCache: YES ];
        } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];
    
    GHAssertTrue( isDoneCallbackReached, @"completion callback not reached" );
    
    GHAssertNotNil( actualResponse, @"invalid level response" );
    GHAssertNil( actualError, @"unexpected error" );
    
    GHAssertTrue( actualResponse.levelParentItem == self->_placeholderSettingsStub, @"root item mismatch" );
    GHAssertTrue( 0 == [ actualResponse.levelContentItems count ], @"children count mismatch" );
}

@end
