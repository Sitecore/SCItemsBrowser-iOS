
#import <XCTest/XCTest.h>

#import <SitecoreMobileSDK/SitecoreMobileSDK.h>
#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItem+PrivateMethods.h"
#import "ItemsBrowserTestStubs.h"


@interface AssignOnceListPropertiesTest : XCTestCase
@end

@implementation AssignOnceListPropertiesTest
{
    SCExtendedApiSession* _context;
    SCApiSession* _legacyContext;
    
    SCItem* _rootItemStub;
    StubListModeTheme* _listModeThemeStub;
    StubGridModeTheme* _gridModeThemeStub;
    StubItemsBrowserDelegate* _delegateStub;
    StubCellFactory* _cellFactoryStub;
    StubRequestBuilder* _requestBuilderStub;
    
    SCItemListBrowser* _itemsBrowser;
}


-(void)setUp
{
    [ super setUp ];
    
    self->_itemsBrowser = [ SCItemListBrowser new ];
    
    self->_legacyContext = [ SCApiSession contextWithHost: @"www.StubHost.net" ];
    self->_context = self->_legacyContext.extendedApiContext;
    
    self->_listModeThemeStub  = [ StubListModeTheme        new ];
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

-(void)testApiContextIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.apiSession, @"nil ApiContext expected" );
    
    self->_itemsBrowser.apiSession= self->_context;
    XCTAssertTrue( self->_itemsBrowser.apiSession== self->_context, @"context pointer mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setApiContext: self->_context ],
     @"assign is allowed only once"
     );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setApiContext: nil ],
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

-(void)testTableViewIsAssignedOnce
{
    UITableView* tableView =
    [ [ UITableView alloc ] initWithFrame: CGRectMake(0, 0, 100, 100)
                                    style:UITableViewStylePlain ];
    XCTAssertNil( self->_itemsBrowser.tableView, @"nil rootItem expected" );
    
    self->_itemsBrowser.tableView = tableView;
    XCTAssertTrue( self->_itemsBrowser.tableView == tableView , @"rootItem pointer mismatch"      );
    XCTAssertTrue( tableView.delegate   == self->_itemsBrowser, @"table view delegate mismatch"   );
    XCTAssertTrue( tableView.dataSource == self->_itemsBrowser, @"table view dataSource mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setTableView: tableView ],
     @"assign is allowed only once"
     );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setTableView: nil ],
     @"assign is allowed only once"
     );
}


@end
