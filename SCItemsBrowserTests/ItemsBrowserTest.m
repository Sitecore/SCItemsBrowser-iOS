#import <XCTest/XCTest.h>

#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItem+Media.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

#import <MobileSDK-Private/SCItemRecord_Source.h>
#import <MobileSDK-Private/SCItem+PrivateMethods.h>

#import "StubRequestBuilder.h"
#import "SCItemListBrowser_UnitTest.h"

@interface ItemsBrowserTest : XCTestCase
@end

@implementation ItemsBrowserTest
{
    SCExtendedApiContext* _context      ;
    SCApiContext        * _legacyContext;
    
    SCItemSourcePOD     * _recordSource ;
    
    SCItem              * _rootItem     ;
    SCItemRecord        * _rootRecord   ;
    
    UITableView         * _tableView    ;
    SCItemListBrowser   * _listBrowser  ;
    
    StubRequestBuilder  * _stubRequestBuilder;
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
    self->_stubRequestBuilder = [ StubRequestBuilder new ];
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

    
    self->_listBrowser.nextLevelRequestBuilder = self->_stubRequestBuilder;
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
    
    self->_listBrowser.nextLevelRequestBuilder = self->_stubRequestBuilder;
    XCTAssertThrows
    (
     [ self->_listBrowser lazyItemsFileManager ],
     @"assert expected"
    );
    
    
    self->_listBrowser.apiContext = self->_context;
    SCItemsFileManager* fm = [ self->_listBrowser lazyItemsFileManager ];
    XCTAssertNotNil( fm, @"items file manager not created" );
}




@end
