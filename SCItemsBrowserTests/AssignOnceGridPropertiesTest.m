
#import <XCTest/XCTest.h>

#import <SitecoreMobileSDK/SitecoreMobileSDK.h>
#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItem+PrivateMethods.h"
#import "ItemsBrowserTestStubs.h"


@interface AssignOnceGridPropertiesTest : XCTestCase
@end

@implementation AssignOnceGridPropertiesTest
{
    SCExtendedApiSession* _context;
    SCApiSession* _legacyContext;
    
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
    
    self->_legacyContext = [ SCApiSession contextWithHost: @"www.StubHost.net" ];
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

-(void)testGridModeThemeIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.gridModeTheme, @"nil rootItem expected" );
    
    self->_itemsBrowser.GridModeTheme = self->_gridModeThemeStub;
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


-(void)testGridCellFactoryIsAssignedOnce
{
    XCTAssertNil( self->_itemsBrowser.gridModeCellBuilder, @"nil rootItem expected" );
    
    self->_itemsBrowser.GridModeCellBuilder = self->_cellFactoryStub;
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

-(void)testTableViewIsAssignedOnce
{
    UICollectionViewFlowLayout* collectionLayout = [ UICollectionViewFlowLayout new ];
    UICollectionView* collectionView =
    [ [ UICollectionView alloc ] initWithFrame: CGRectMake(0, 0, 100, 100)
                          collectionViewLayout: collectionLayout ];
    XCTAssertNil( self->_itemsBrowser.collectionView, @"nil rootItem expected" );
    
    self->_itemsBrowser.collectionView = collectionView;
    XCTAssertTrue( self->_itemsBrowser.collectionView == collectionView , @"rootItem pointer mismatch"      );
    XCTAssertTrue( collectionView.delegate   == self->_itemsBrowser, @"table view delegate mismatch"   );
    XCTAssertTrue( collectionView.dataSource == self->_itemsBrowser, @"table view dataSource mismatch" );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setCollectionView: collectionView ],
     @"assign is allowed only once"
     );
    
    XCTAssertThrows
    (
     [ self->_itemsBrowser setCollectionView: nil ],
     @"assign is allowed only once"
     );
}


@end
