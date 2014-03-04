#import <XCTest/XCTest.h>

#import "SCItemsFileManager.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>
#import <SitecoreItemsBrowser/SCItemsBrowser.h>

#import "SCItemsFileManager+UnitTest.h"
#import "SCItem+PrivateMethods.h"

#import "ItemsBrowserTestStubs.h"

@interface ItemsFileManagerTest : XCTestCase
@end

@implementation ItemsFileManagerTest
{
    SCExtendedApiContext* _context;
    SCApiContext* _legacyContext;
    
    StubRequestBuilder* _useCacheRequestBuilderStub;
    SCItem* _rootItemStub;
    
    
    SCItemsFileManager* _useCacheFm;
}

-(void)setUp
{
    [ super setUp ];

    self->_legacyContext = [ SCApiContext contextWithHost: @"www.StubHost.net" ];
    self->_context = self->_legacyContext.extendedApiContext;
    self->_useCacheRequestBuilderStub = [ StubRequestBuilder new ];
    
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: nil
                                                 apiContext: self->_context ];
    
    self->_useCacheFm =
    [ [ SCItemsFileManager alloc ] initWithApiContext: self->_context
                                  levelRequestBuilder: self->_useCacheRequestBuilderStub ];
}

-(void)tearDown
{
    self->_legacyContext = nil;
    self->_context = nil;
    self->_useCacheRequestBuilderStub = nil;
    self->_rootItemStub = nil;
    self->_useCacheFm = nil;
    
    [ super tearDown ];
}

-(void)testFileManagerRejectsInit
{
    XCTAssertThrows( [ SCItemsFileManager new ], @"assert expected" );
}

-(void)testFileManagerConstructorRejectsNil
{
    XCTAssertThrows
    (
        [ [ SCItemsFileManager alloc ] initWithApiContext: nil
                                      levelRequestBuilder: self->_useCacheRequestBuilderStub ],
        @"assert expected"
    );
    
    XCTAssertThrows
    (
     [ [ SCItemsFileManager alloc ] initWithApiContext: self->_context
                                   levelRequestBuilder: nil ],
     @"assert expected"
    );
    
    XCTAssertNoThrow
    (
       [ [ SCItemsFileManager alloc ] initWithApiContext: self->_context
                                     levelRequestBuilder: self->_useCacheRequestBuilderStub ],
        @"unexpected assert"
    );
}

-(void)testAssigningCancelBlock_CancelsCurrentOperation
{
    SCItemsFileManager* fm = self->_useCacheFm;
    
    XCTAssertNotNil( fm, @"init failed" );
    XCTAssertNil( fm.cancelLoaderBlock, @"cancel block should be nil" );
    
    __block NSInteger invocationsCount = 0;
    SCCancelAsyncOperation mockCancelBlock = ^void( BOOL isUnsubscribeAction )
    {
        ++invocationsCount;
    };
    
    fm.cancelLoaderBlock = mockCancelBlock;
    XCTAssertTrue( 0 == invocationsCount, @"cancel block should not be called while assigning" );
    
    fm.cancelLoaderBlock = nil;
    XCTAssertTrue( 1 == invocationsCount, @"cancel block should be called before being dropped" );
}

-(void)testRequestBuilderDoesNotModifyFlags
{
    SCItemsReaderRequest* actualRequest = nil;
    SCItemsReaderRequest* requestStub = [ SCItemsReaderRequest new ];
    
    {
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: NO ];
        
        XCTAssertTrue( requestStub.flags == actualRequest.flags, @"flags should not be changed" );
    }
    
    
    {
        requestStub.flags = SCItemReaderRequestIngnoreCache;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: NO ];
        
        
        XCTAssertTrue( requestStub.flags == actualRequest.flags, @"flags should not be changed" );
    }
    
    {
        requestStub.flags = SCItemReaderRequestReadFieldsValues;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: NO ];
        
        
        XCTAssertTrue( requestStub.flags == actualRequest.flags, @"flags should not be changed" );
    }
    
    {
        requestStub.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: NO ];
        
        
        XCTAssertTrue( requestStub.flags == actualRequest.flags, @"flags should not be changed" );
    }
}

-(void)testRequestBuilderCanModifyIgnoreCacheFlagOnly
{
    SCItemsReaderRequest* actualRequest = nil;
    SCItemsReaderRequest* requestStub = [ SCItemsReaderRequest new ];
    
    {
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: YES ];
        
        XCTAssertTrue( SCItemReaderRequestIngnoreCache == actualRequest.flags, @"flags should not be changed" );
    }
    
    
    {
        requestStub.flags = SCItemReaderRequestIngnoreCache;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: YES ];
        
        
        XCTAssertTrue( SCItemReaderRequestIngnoreCache == actualRequest.flags, @"flags should not be changed" );
    }
    
    {
        requestStub.flags = SCItemReaderRequestReadFieldsValues;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: YES ];
        
        
        XCTAssertTrue( (SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues) == actualRequest.flags, @"flags should not be changed" );
    }
    
    {
        requestStub.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: YES ];
        
        
        XCTAssertTrue( (SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues) == actualRequest.flags, @"flags should not be changed" );
    }
}

-(void)testRequestBuilderShouldNotReturnNilRequest
{
    SCItemsFileManager* fm = self->_useCacheFm;
    self->_useCacheRequestBuilderStub.requestStub = nil;
    
    XCTAssertThrows
    (
        [ fm buildLevelRequestForItem: self->_rootItemStub
                        ignoringCache: NO ],
        @"assert expected"
    );
}

@end
