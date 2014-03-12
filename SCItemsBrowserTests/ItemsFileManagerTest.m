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
    SCExtendedApiSession* _session;
    SCApiSession* _legacySession;
    
    StubRequestBuilder* _useCacheRequestBuilderStub;
    SCItem* _rootItemStub;
    
    
    SCItemsFileManager* _useCacheFm;
}

-(void)setUp
{
    [ super setUp ];

    self->_legacySession = [ SCApiSession sessionWithHost: @"www.StubHost.net" ];
    self->_session = self->_legacySession.extendedApiSession;
    self->_useCacheRequestBuilderStub = [ StubRequestBuilder new ];
    
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: nil
                                                 apiSession: self->_session ];
    
    self->_useCacheFm =
    [ [ SCItemsFileManager alloc ] initWithApiSession: self->_session
                                  levelRequestBuilder: self->_useCacheRequestBuilderStub ];
}

-(void)tearDown
{
    self->_legacySession = nil;
    self->_session = nil;
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
        [ [ SCItemsFileManager alloc ] initWithApiSession: nil
                                      levelRequestBuilder: self->_useCacheRequestBuilderStub ],
        @"assert expected"
    );
    
    XCTAssertThrows
    (
     [ [ SCItemsFileManager alloc ] initWithApiSession: self->_session
                                   levelRequestBuilder: nil ],
     @"assert expected"
    );
    
    XCTAssertNoThrow
    (
       [ [ SCItemsFileManager alloc ] initWithApiSession: self->_session
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
    SCReadItemsRequest* actualRequest = nil;
    SCReadItemsRequest* requestStub = [ SCReadItemsRequest new ];
    
    {
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: NO ];
        
        XCTAssertTrue( requestStub.flags == actualRequest.flags, @"flags should not be changed" );
    }
    
    
    {
        requestStub.flags = SCReadItemRequestIngnoreCache;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: NO ];
        
        
        XCTAssertTrue( requestStub.flags == actualRequest.flags, @"flags should not be changed" );
    }
    
    {
        requestStub.flags = SCReadItemRequestReadFieldsValues;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: NO ];
        
        
        XCTAssertTrue( requestStub.flags == actualRequest.flags, @"flags should not be changed" );
    }
    
    {
        requestStub.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: NO ];
        
        
        XCTAssertTrue( requestStub.flags == actualRequest.flags, @"flags should not be changed" );
    }
}

-(void)testRequestBuilderCanModifyIgnoreCacheFlagOnly
{
    SCReadItemsRequest* actualRequest = nil;
    SCReadItemsRequest* requestStub = [ SCReadItemsRequest new ];
    
    {
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: YES ];
        
        XCTAssertTrue( SCReadItemRequestIngnoreCache == actualRequest.flags, @"flags should not be changed" );
    }
    
    
    {
        requestStub.flags = SCReadItemRequestIngnoreCache;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: YES ];
        
        
        XCTAssertTrue( SCReadItemRequestIngnoreCache == actualRequest.flags, @"flags should not be changed" );
    }
    
    {
        requestStub.flags = SCReadItemRequestReadFieldsValues;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: YES ];
        
        
        XCTAssertTrue( (SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues) == actualRequest.flags, @"flags should not be changed" );
    }
    
    {
        requestStub.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        
        SCItemsFileManager* fm = self->_useCacheFm;
        self->_useCacheRequestBuilderStub.requestStub = requestStub;
        
        actualRequest = [ fm buildLevelRequestForItem: self->_rootItemStub
                                        ignoringCache: YES ];
        
        
        XCTAssertTrue( (SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues) == actualRequest.flags, @"flags should not be changed" );
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
