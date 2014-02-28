#import <XCTest/XCTest.h>

#import "SCItem+Media.h"

#import <MobileSDK-Private/SCItemRecord_Source.h>
#import <MobileSDK-Private/SCItemRecord_UnitTest.h>
#import <MobileSDK-Private/SCItem+PrivateMethods.h>

#import <SCItemsBrowser/SCItemsBrowser.h>
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface AllChildrenRequestBuilderTest : XCTestCase
@end


@implementation AllChildrenRequestBuilderTest
{
    SCExtendedApiSession* _session;
    SCApiSession* _legacySession;
    
    SCItemRecord*  _rootItemRecord;
    SCItem* _rootItemStub;
    SCItemSourcePOD* _recordSource;
}

-(void)setUp
{
    self->_legacySession = [ SCApiSession sessionWithHost: @"www.StubHost.net" ];
    self->_session = self->_legacySession.extendedApiSession;
    {
        self->_session.defaultDatabase = @"core";
        self->_session.defaultSite     = nil    ;
        self->_session.defaultLanguage = @"ru"  ;
    }
    
    self->_recordSource = [ SCItemSourcePOD new ];
    {
        self->_recordSource.database = @"master";
        self->_recordSource.site     = @"/sitecore/shell";
        self->_recordSource.language = @"en";
    }
    
    self->_rootItemRecord = [ SCItemRecord new ];
    {
        self->_rootItemRecord.apiSession= self->_session;
        self->_rootItemRecord.mainApiSession = self->_legacySession;
        
        self->_rootItemRecord.path = @"/sitecore/content/home";
        self->_rootItemRecord.itemId = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}";
        self->_rootItemRecord.displayName = @"home";
        
        [ self->_rootItemRecord setItemSource: self->_recordSource ];
    }
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: self->_rootItemRecord
                                                 apiSession: self->_session ];
}

-(void)tearDown
{
    self->_legacySession  = nil;
    self->_session        = nil;
    
    self->_rootItemStub   = nil;
    self->_rootItemRecord = nil;
    
    self->_recordSource = nil;
    
    [ super tearDown ];
}


-(void)testAllChildrenBuilderConstructsCorrectQueqy
{    
    SIBAllChildrenRequestBuilder* filter = [ SIBAllChildrenRequestBuilder new ];
    
    SCReadItemsRequest* request = [ filter itemsBrowser: nil
                                  levelDownRequestForItem: self->_rootItemStub ];
    
    XCTAssertNotNil( request, @"request builder failed and returned nil" );
    XCTAssertTrue( SCItemReaderRequestItemPath == request.requestType, @"Request type is not 'Query' " );
    XCTAssertEqualObjects( request.request, @"/sitecore/content/home", @"query mismatch" );
    XCTAssertTrue( SCItemReaderChildrenScope == request.scope, @"scope mismatch" );
}

-(void)testAllChildrenBuilderTakesTheSourceFromTheItem
{
    SIBAllChildrenRequestBuilder* filter = [ SIBAllChildrenRequestBuilder new ];
    
    SCReadItemsRequest* request = [ filter itemsBrowser: nil
                                  levelDownRequestForItem: self->_rootItemStub ];
    
    XCTAssertEqualObjects( request.database, self->_recordSource.database, @"database mismatch" );
    XCTAssertEqualObjects( request.site    , self->_recordSource.site    , @"site mismatch"     );
    XCTAssertEqualObjects( request.language, self->_recordSource.language, @"language mismatch" );
}

-(void)testAllChildrenBuilderTakesTheSourceFromTheSessionIfItemHasNone
{
    [ self->_rootItemRecord setItemSource: nil ];

    SIBAllChildrenRequestBuilder* filter = [ SIBAllChildrenRequestBuilder new ];
    
    SCReadItemsRequest* request = [ filter itemsBrowser: nil
                                  levelDownRequestForItem: self->_rootItemStub ];
    
    
    XCTAssertEqualObjects( request.database, self->_session.defaultDatabase, @"database mismatch" );
    XCTAssertEqualObjects( request.site    , self->_session.defaultSite    , @"site mismatch"     );
    XCTAssertEqualObjects( request.language, self->_session.defaultLanguage, @"language mismatch" );
}

@end
