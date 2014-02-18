#import <XCTest/XCTest.h>

#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItem+Media.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

#import <MobileSDK-Private/SCItemRecord_Source.h>
#import <MobileSDK-Private/SCItem+PrivateMethods.h>

#import "StubRequestBuilder.h"
#import "SCItemListBrowser_UnitTest.h"

#import "SCLevelResponse.h"
#import "ItemsBrowserTestStubs.h"


@interface ItemsListBrowserTest : XCTestCase
@end

@implementation ItemsListBrowserTest
{
    SCExtendedApiContext* _context      ;
    SCApiContext        * _legacyContext;
    
    SCItemSourcePOD     * _recordSource ;
    
    SCItem              * _rootItem     ;
    SCItemRecord        * _rootRecord   ;
    
    UITableView         * _tableView    ;
    SCItemListBrowser   * _listBrowser  ;
    
    StubListModeTheme* _listModeThemeStub;
    StubGridModeTheme* _gridModeThemeStub;
    StubItemsBrowserDelegate* _delegateStub;
    StubCellFactory* _cellFactoryStub;
    StubRequestBuilder* _requestBuilderStub;
}

-(void)setUp
{
    [ super setUp ];
    
    SCItemRecord* newRecord  = nil;
    
    self->_legacyContext = [ SCApiContext contextWithHost: @"stub-host.net" ];
    self->_context = self->_legacyContext.extendedApiContext;
    
    SCItemSourcePOD* recordSource = [ SCItemSourcePOD new ];
    {
        recordSource.database = @"master"         ;
        recordSource.language = @"ru"             ;
        recordSource.site     = @"/sitecore/shell";
        recordSource.itemVersion = @"100500";
    }
    self->_recordSource = recordSource;
    
    newRecord = [ SCItemRecord new ];
    {
        newRecord.displayName  = @"хомяк"                 ;
        newRecord.path         = @"/sitecore/content/home";
        newRecord.itemTemplate = @"common/folder"         ;
        
        newRecord.apiContext     = self->_context      ;
        newRecord.mainApiContext = self->_legacyContext;
        
        newRecord.itemSource = recordSource;
    }
    self->_rootRecord = newRecord;
    self->_rootItem   = [ [ SCItem alloc ] initWithRecord: self->_rootRecord
                                               apiContext: self->_context ];
    
    self->_tableView = [ [ UITableView alloc ] initWithFrame: CGRectMake( 0, 0, 100, 100 )
                                                       style: UITableViewStylePlain ];
    
    self->_listBrowser = [ SCItemListBrowser new ];

    self->_listModeThemeStub  = [ StubListModeTheme        new ];
    self->_gridModeThemeStub  = [ StubGridModeTheme        new ];
    self->_delegateStub       = [ StubItemsBrowserDelegate new ];
    self->_cellFactoryStub    = [ StubCellFactory          new ];
    self->_requestBuilderStub = [ StubRequestBuilder       new ];
    
}

-(void)tearDown
{
    self->_rootItem      = nil;
    self->_rootRecord    = nil;

    self->_context       = nil;
    self->_legacyContext = nil;
    self->_recordSource  = nil;
    
    self->_tableView     = nil;
    self->_listBrowser   = nil;
    
    [ super tearDown ];
}

-(void)testMockTableViewIsCreatedSuccessfully
{
    XCTAssertNotNil( self->_tableView, @"tableview not created" );
}

-(void)testItemsBrowserBecomesDelegateAndDataSourceOfTableView
{
    self->_listBrowser.tableView = self->_tableView;
    
    XCTAssertTrue( self->_tableView.delegate   == self->_listBrowser, @"delegate mismatch"   );
    XCTAssertTrue( self->_tableView.dataSource == self->_listBrowser, @"dataSource mismatch" );
}

-(void)testNumberOfRowsReturnsZeroForNonInitializedBrowser
{
    NSInteger result = NSNotFound;
    
    self->_listBrowser.tableView = self->_tableView;
    
    result = [ self->_listBrowser tableView: self->_tableView
                      numberOfRowsInSection: 0 ];
    XCTAssertTrue( 0 == result, @"number of rows mismatch" );
}

-(void)testNumberOfRowsReturnsZeroForNonLoadedLevel
{
    NSInteger result = NSNotFound;
    
    self->_listBrowser.tableView  = self->_tableView;
    self->_listBrowser.apiContext = self->_context  ;
    self->_listBrowser.rootItem   = self->_rootItem ;
    self->_listBrowser.delegate   = self->_delegateStub;
    self->_listBrowser.listModeTheme = self->_listModeThemeStub;
    self->_listBrowser.listModeCellBuilder = self->_cellFactoryStub;
    
    result = [ self->_listBrowser tableView: self->_tableView
                      numberOfRowsInSection: 0 ];
    XCTAssertTrue( 0 == result, @"number of rows mismatch" );
    
    
    {
        NSArray* mockLevelItems = @[ @"one", @(2), @"three" ];
        
        SCLevelResponse* mockResponse =
        [ [ SCLevelResponse alloc ] initWithItem: self->_rootItem
                               levelContentItems: mockLevelItems ];

        [ self->_listBrowser setLoadedLevel: mockResponse ];
    }
    result = [ self->_listBrowser tableView: self->_tableView
                      numberOfRowsInSection: 0 ];
    XCTAssertTrue( 3 == result, @"number of rows mismatch" );
}

-(void)testLazyItemsFileManagerRequiresContext
{
    XCTAssertThrows
    (
       [ self->_listBrowser lazyItemsFileManager ],
       @"assert expected"
    );
    
    
    self->_listBrowser.apiContext = self->_context;
    XCTAssertThrows
    (
     [ self->_listBrowser lazyItemsFileManager ],
     @"assert expected"
    );

    
    self->_listBrowser.nextLevelRequestBuilder = self->_requestBuilderStub;
    SCItemsFileManager* fm = [ self->_listBrowser lazyItemsFileManager ];
    XCTAssertNotNil( fm, @"items file manager not created" );
}

-(void)testLazyItemsFileManagerRequiresRequestBuilder
{
    XCTAssertThrows
    (
     [ self->_listBrowser lazyItemsFileManager ],
     @"assert expected"
    );
    
    self->_listBrowser.nextLevelRequestBuilder = self->_requestBuilderStub;
    XCTAssertThrows
    (
     [ self->_listBrowser lazyItemsFileManager ],
     @"assert expected"
    );
    
    
    self->_listBrowser.apiContext = self->_context;
    SCItemsFileManager* fm = [ self->_listBrowser lazyItemsFileManager ];
    XCTAssertNotNil( fm, @"items file manager not created" );
}

-(void)testLazyFileManagerReturnsSameThing
{
    self->_listBrowser.nextLevelRequestBuilder = self->_requestBuilderStub;
    self->_listBrowser.apiContext = self->_context;
    
    SCItemsFileManager* first  = [ self->_listBrowser lazyItemsFileManager ];
    SCItemsFileManager* second = [ self->_listBrowser lazyItemsFileManager ];
    
    XCTAssertTrue( first == second, @"fm pointer mismatch" );
}

-(void)testDisposeLazyFileManagerCleansObjectAndOnceToken
{
    self->_listBrowser.nextLevelRequestBuilder = self->_requestBuilderStub;
    self->_listBrowser.apiContext = self->_context;
    
    SCItemsFileManager* first  = [ self->_listBrowser lazyItemsFileManager ];
    XCTAssertNotNil( first, @"fm not created" );
    XCTAssertNotNil( [ self->_listBrowser itemsFileManager ], @"fm not created" );
    XCTAssertFalse( 0 == [ self->_listBrowser onceItemsFileManagerToken ], @"token mismatch" );
    
    [ self->_listBrowser disposeLazyItemsFileManager ];
    XCTAssertNil( [ self->_listBrowser itemsFileManager ], @"fm not created" );
    XCTAssertTrue( 0 == [ self->_listBrowser onceItemsFileManagerToken ], @"token mismatch" );
}

@end
