#import <XCTest/XCTest.h>

#import "SCItem+Media.h"

#import <MobileSDK-Private/SCItemRecord_Source.h>
#import <MobileSDK-Private/SCItemRecord_UnitTest.h>
#import <MobileSDK-Private/SCItem+PrivateMethods.h>

#import <SitecoreMobileSDK/SitecoreMobileSDK.h>
#import "SIBWhiteListTemplateRequestBuilder.h"



@interface WhiteListRequestBuilderTest : XCTestCase
@end

@implementation WhiteListRequestBuilderTest
{
   SCExtendedApiContext* _context;
   SCApiContext* _legacyContext;

   SCItemRecord*  _rootItemRecord;
   SCItem* _rootItemStub;
   SCItemSourcePOD* _recordSource;
}

-(void)setUp
{
   self->_legacyContext = [ SCApiContext contextWithHost: @"www.StubHost.net" ];
   self->_context = self->_legacyContext.extendedApiContext;
   {
      self->_context.defaultDatabase = @"core";
      self->_context.defaultSite     = nil    ;
      self->_context.defaultLanguage = @"ru"  ;
   }

   self->_recordSource = [ SCItemSourcePOD new ];
   {
      self->_recordSource.database = @"master";
      self->_recordSource.site     = @"/sitecore/shell";
      self->_recordSource.language = @"en";
   }
   
   self->_rootItemRecord = [ SCItemRecord new ];
   {
       self->_rootItemRecord.apiContext = self->_context;
       self->_rootItemRecord.mainApiContext = self->_legacyContext;
       
       self->_rootItemRecord.path = @"/sitecore/content/home";
       self->_rootItemRecord.itemId = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}";
       self->_rootItemRecord.displayName = @"home";
       
       [ self->_rootItemRecord setItemSource: self->_recordSource ];
   }
   self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: self->_rootItemRecord
                                                apiContext: self->_context ];
}

-(void)tearDown
{
   self->_legacyContext  = nil;
   self->_context        = nil;
   
   self->_rootItemStub   = nil;
   self->_rootItemRecord = nil;
   
   self->_recordSource = nil;
   
   [ super tearDown ];
}

-(void)testWhiteListBuilderRejectsInit
{
    XCTAssertThrows
    (
        [ SIBWhiteListTemplateRequestBuilder new ],
        @"assert expected"
    );
}

-(void)testWhiteListBuilderRejectsNilArray
{
    XCTAssertThrows
    (
       [ [ SIBWhiteListTemplateRequestBuilder alloc ] initWithTemplateNames: nil ],
       @"assert expected"
    );
}

-(void)testWhiteListBuilderRejectsEmptyArray
{
    XCTAssertThrows
    (
     [ [ SIBWhiteListTemplateRequestBuilder alloc ] initWithTemplateNames: @[] ],
     @"assert expected"
     );
}

-(void)testWhiteListBuilderStoresTemplateNames
{
    NSArray* templates = @[ @"А", @"и", @"Б" ];
    
    SIBWhiteListTemplateRequestBuilder* filter =
    [ [ SIBWhiteListTemplateRequestBuilder alloc ] initWithTemplateNames: templates ];
    
    XCTAssertEqualObjects( templates, filter.templateNames, @"template names mismatch" );
    XCTAssertTrue( templates == filter.templateNames, @"template names mismatch" );
}

-(void)testWhiteListBuilderTakesTheSourceFromTheItem
{
   NSArray* templates = @[ @"x", @"y", @"z" ];
   
   SIBWhiteListTemplateRequestBuilder* filter =
   [ [ SIBWhiteListTemplateRequestBuilder alloc ] initWithTemplateNames: templates ];
   
   SCItemsReaderRequest* request = [ filter itemsBrowser: nil
                                 levelDownRequestForItem: self->_rootItemStub ];
   
   XCTAssertEqualObjects( request.database, self->_recordSource.database, @"database mismatch" );
   XCTAssertEqualObjects( request.site    , self->_recordSource.site    , @"site mismatch"     );
   XCTAssertEqualObjects( request.language, self->_recordSource.language, @"language mismatch" );
}

-(void)testWhiteListBuilderTakesTheSourceFromTheContextIfItemHasNone
{
    [ self->_rootItemRecord setItemSource: nil ];
    NSArray* templates = @[ @"x", @"y", @"z" ];
    
    
    SIBWhiteListTemplateRequestBuilder* filter =
    [ [ SIBWhiteListTemplateRequestBuilder alloc ] initWithTemplateNames: templates ];
    
    SCItemsReaderRequest* request = [ filter itemsBrowser: nil
                                  levelDownRequestForItem: self->_rootItemStub ];
    
    XCTAssertEqualObjects( request.database, self->_context.defaultDatabase, @"database mismatch" );
    XCTAssertEqualObjects( request.site    , self->_context.defaultSite    , @"site mismatch"     );
    XCTAssertEqualObjects( request.language, self->_context.defaultLanguage, @"language mismatch" );
}

-(void)testWhiteListBuilderConstructsCorrectQueqy
{
   NSArray* templates = @[ @"Folder", @"Author", @"BlogPost" ];
   
   SIBWhiteListTemplateRequestBuilder* filter =
   [ [ SIBWhiteListTemplateRequestBuilder alloc ] initWithTemplateNames: templates ];
   
   SCItemsReaderRequest* request = [ filter itemsBrowser: nil
                                 levelDownRequestForItem: self->_rootItemStub ];
   
   XCTAssertNotNil( request, @"request builder failed and returned nil" );
   XCTAssertTrue( SCItemReaderRequestQuery == request.requestType, @"Request type is not 'Query' " );
   XCTAssertEqualObjects( request.request, @"/sitecore/content/home/*[@@templatename = 'Folder' OR @@templatename = 'Author' OR @@templatename = 'BlogPost']", @"query mismatch" );
}

-(void)testWhiteListBuilderDoesNotTrimWhitespaces
{
   NSArray* templates = @[ @"    Folder    ", @"\t", @"" ];
   
   SIBWhiteListTemplateRequestBuilder* filter =
   [ [ SIBWhiteListTemplateRequestBuilder alloc ] initWithTemplateNames: templates ];
   
   SCItemsReaderRequest* request = [ filter itemsBrowser: nil
                                 levelDownRequestForItem: self->_rootItemStub ];
   
   XCTAssertNotNil( request, @"request builder failed and returned nil" );
   XCTAssertTrue( SCItemReaderRequestQuery == request.requestType, @"Request type is not 'Query' " );
   XCTAssertEqualObjects( request.request, @"/sitecore/content/home/*[@@templatename = '    Folder    ' OR @@templatename = '\t' OR @@templatename = '']", @"query mismatch" );
}

@end
