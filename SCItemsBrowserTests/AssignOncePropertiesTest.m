#import <XCTest/XCTest.h>

#import <SitecoreMobileSDK/SitecoreMobileSDK.h>
#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItemsBrowserView.h"
#import "SCItem+PrivateMethods.h"
#import "ItemsBrowserTestStubs.h"

@interface AssignOncePropertiesTest : XCTestCase
@end


@implementation AssignOncePropertiesTest
{
    SCExtendedApiSession* _session;
    SCApiSession* _legacySession;
    
    SCItem* _rootItemStub;
    StubListModeTheme* _listModeThemeStub;
    StubGridModeTheme* _gridModeThemeStub;
    StubItemsBrowserDelegate* _delegateStub;
    StubCellFactory* _cellFactoryStub;
    StubRequestBuilder* _requestBuilderStub;
    
    SCItemsBrowserView* _itemsBrowser;
    CGRect _stubRect;
}


-(void)setUp
{
    [ super setUp ];

    self->_stubRect = CGRectMake( 15.f, 15.f, 320.f, 400.f );
    self->_itemsBrowser = [ [ SCItemsBrowserView alloc ] initWithFrame: self->_stubRect ];
    
    self->_legacySession = [ SCApiSession sessionWithHost: @"www.StubHost.net" ];
    self->_session = self->_legacySession.extendedApiSession;
    
    self->_listModeThemeStub = [ StubListModeTheme        new ];
    self->_gridModeThemeStub = [ StubGridModeTheme        new ];
    self->_delegateStub      = [ StubItemsBrowserDelegate new ];
    self->_cellFactoryStub   = [ StubCellFactory          new ];
    self->_requestBuilderStub = [ StubRequestBuilder new ];
    
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: nil
                                                 apiSession: self->_session ];
}

-(void)tearDown
{
    self->_itemsBrowser  = nil;
    self->_session       = nil;
    self->_legacySession = nil;
    self->_rootItemStub  = nil;
    self->_delegateStub  = nil;

    [ super tearDown ];
}

-(void)testApiSessionIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.apiSession, @"nil ApiSession expected" );
    
    self->_itemsBrowser.apiSession= self->_session;
    XCTAssertTrue( self->_itemsBrowser.apiSession== self->_session, @"Session pointer mismatch" );
    
    XCTAssertThrows
    (
        [ self->_itemsBrowser setApiSession: self->_session ],
        @"assign is allowed only once"
    );

    XCTAssertThrows
    (
     [ self->_itemsBrowser setApiSession: nil ],
     @"assign is allowed only once"
    );
}


-(void)testRootItemIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.rootItem, @"nil rootItem expected" );
    
    self->_itemsBrowser.rootItem = self->_rootItemStub;
    XCTAssertTrue( self->_itemsBrowser.rootItem == self->_rootItemStub, @"rootItem pointer mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setRootItem: self->_rootItemStub ],
     @"assign is allowed only once"
     );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setRootItem: nil ],
     @"assign is allowed only once"
     );
}

-(void)testListModeThemeIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.listModeTheme, @"nil rootItem expected" );
    
    self->_itemsBrowser.listModeTheme = self->_listModeThemeStub;
    XCTAssertTrue( self->_itemsBrowser.listModeTheme == self->_listModeThemeStub, @"rootItem pointer mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setListModeTheme: self->_listModeThemeStub ],
     @"assign is allowed only once"
     );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setListModeTheme: nil ],
     @"assign is allowed only once"
     );
}

-(void)testGridModeThemeIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.gridModeTheme, @"nil rootItem expected" );
    
    self->_itemsBrowser.gridModeTheme = self->_gridModeThemeStub;
    XCTAssertTrue( self->_itemsBrowser.gridModeTheme == self->_gridModeThemeStub, @"rootItem pointer mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setGridModeTheme: self->_gridModeThemeStub ],
     @"assign is allowed only once"
     );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setGridModeTheme: nil ],
     @"assign is allowed only once"
    );
}


-(void)testDelegateThemeIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.delegate, @"nil rootItem expected" );
    
    self->_itemsBrowser.delegate = self->_delegateStub;
    XCTAssertTrue( self->_itemsBrowser.delegate == self->_delegateStub, @"rootItem pointer mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setDelegate: self->_delegateStub ],
     @"assign is allowed only once"
     );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setDelegate: nil ],
     @"assign is allowed only once"
     );
}


-(void)testListCellFactoryIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.listModeCellBuilder, @"nil rootItem expected" );
    
    self->_itemsBrowser.listModeCellBuilder = self->_cellFactoryStub;
    XCTAssertTrue( self->_itemsBrowser.listModeCellBuilder == self->_cellFactoryStub, @"rootItem pointer mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setListModeCellBuilder: self->_cellFactoryStub ],
     @"assign is allowed only once"
     );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setListModeCellBuilder: nil ],
     @"assign is allowed only once"
     );
}


-(void)testGridCellFactoryIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.gridModeCellBuilder, @"nil rootItem expected" );
    
    self->_itemsBrowser.gridModeCellBuilder = self->_cellFactoryStub;
    XCTAssertTrue( self->_itemsBrowser.gridModeCellBuilder == self->_cellFactoryStub, @"rootItem pointer mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setGridModeCellBuilder: self->_cellFactoryStub ],
     @"assign is allowed only once"
    );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setGridModeCellBuilder: nil ],
     @"assign is allowed only once"
    );
}


-(void)testNextLevelBuilderIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.nextLevelRequestBuilder, @"nil rootItem expected" );
    
    self->_itemsBrowser.nextLevelRequestBuilder = self->_requestBuilderStub;
    XCTAssertTrue( self->_itemsBrowser.nextLevelRequestBuilder == self->_requestBuilderStub, @"rootItem pointer mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setNextLevelRequestBuilder: self->_requestBuilderStub ],
     @"assign is allowed only once"
     );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setNextLevelRequestBuilder: nil ],
     @"assign is allowed only once"
     );
}

@end
