
#import <XCTest/XCTest.h>

#import <SitecoreMobileSDK/SitecoreMobileSDK.h>
#import <SitecoreItemsBrowser/SCItemsBrowser.h>

#import "SCItem+PrivateMethods.h"
#import "ItemsBrowserTestStubs.h"

#import "SCItemGridBrowser_UnitTest.h"


@interface GridLazyFileManagerTest : XCTestCase
@end

@implementation GridLazyFileManagerTest
{
    SCExtendedApiContext* _context;
    SCApiContext* _legacyContext;
    
    SCItem* _rootItemStub;
    StubGridModeTheme* _GridModeThemeStub;
    StubGridModeTheme* _gridModeThemeStub;
    StubItemsBrowserDelegate* _delegateStub;
    StubCellFactory* _cellFactoryStub;
    StubRequestBuilder* _requestBuilderStub;
    
    SCItemGridBrowser* _itemsBrowser;
}


-(void)setUp
{
    [ super setUp ];
    
    self->_itemsBrowser = [ SCItemGridBrowser new ];
    
    self->_legacyContext = [ SCApiContext contextWithHost: @"www.StubHost.net" ];
    self->_context = self->_legacyContext.extendedApiContext;
    
    self->_GridModeThemeStub  = [ StubGridModeTheme        new ];
    self->_gridModeThemeStub  = [ StubGridModeTheme        new ];
    self->_delegateStub       = [ StubItemsBrowserDelegate new ];
    self->_cellFactoryStub    = [ StubCellFactory          new ];
    self->_requestBuilderStub = [ StubRequestBuilder new ];
    
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: nil
                                                 apiContext: self->_context ];
}

-(void)tearDown
{
    self->_itemsBrowser  = nil;
    self->_context       = nil;
    self->_legacyContext = nil;
    self->_rootItemStub  = nil;
    self->_delegateStub  = nil;
    
    [ super tearDown ];
}

-(void)testLazyItemsFileManagerRequiresContext
{
    XCTAssertThrows
    (
     [ self->_itemsBrowser lazyItemsFileManager ],
     @"assert expected"
     );
    
    
    self->_itemsBrowser.apiContext = self->_context;
    XCTAssertThrows
    (
     [ self->_itemsBrowser lazyItemsFileManager ],
     @"assert expected"
     );
    
    
    self->_itemsBrowser.nextLevelRequestBuilder = self->_requestBuilderStub;
    SCItemsFileManager* fm = [ self->_itemsBrowser lazyItemsFileManager ];
    XCTAssertNotNil( fm, @"items file manager not created" );
}

-(void)testLazyItemsFileManagerRequiresRequestBuilder
{
    XCTAssertThrows
    (
     [ self->_itemsBrowser lazyItemsFileManager ],
     @"assert expected"
     );
    
    self->_itemsBrowser.nextLevelRequestBuilder = self->_requestBuilderStub;
    XCTAssertThrows
    (
     [ self->_itemsBrowser lazyItemsFileManager ],
     @"assert expected"
     );
    
    
    self->_itemsBrowser.apiContext = self->_context;
    SCItemsFileManager* fm = [ self->_itemsBrowser lazyItemsFileManager ];
    XCTAssertNotNil( fm, @"items file manager not created" );
}

-(void)testLazyFileManagerReturnsSameThing
{
    self->_itemsBrowser.nextLevelRequestBuilder = self->_requestBuilderStub;
    self->_itemsBrowser.apiContext = self->_context;
    
    SCItemsFileManager* first  = [ self->_itemsBrowser lazyItemsFileManager ];
    SCItemsFileManager* second = [ self->_itemsBrowser lazyItemsFileManager ];
    
    XCTAssertTrue( first == second, @"fm pointer mismatch" );
}

-(void)testDisposeLazyFileManagerCleansObjectAndOnceToken
{
    self->_itemsBrowser.nextLevelRequestBuilder = self->_requestBuilderStub;
    self->_itemsBrowser.apiContext = self->_context;
    
    SCItemsFileManager* first  = [ self->_itemsBrowser lazyItemsFileManager ];
    XCTAssertNotNil( first, @"fm not created" );
    XCTAssertNotNil( [ self->_itemsBrowser itemsFileManager ], @"fm not created" );
    XCTAssertFalse( 0 == [ self->_itemsBrowser onceItemsFileManagerToken ], @"token mismatch" );
    
    [ self->_itemsBrowser disposeLazyItemsFileManager ];
    XCTAssertNil( [ self->_itemsBrowser itemsFileManager ], @"fm not created" );
    XCTAssertTrue( 0 == [ self->_itemsBrowser onceItemsFileManagerToken ], @"token mismatch" );
}

@end
