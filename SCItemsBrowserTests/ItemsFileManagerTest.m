#import <XCTest/XCTest.h>

#import "SCItemsFileManager.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>
#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItemsFileManager+UnitTest.h"
#import "ItemsBrowserTestStubs.h"

@interface ItemsFileManagerTest : XCTestCase
@end

@implementation ItemsFileManagerTest
{
    SCExtendedApiContext* _context;
    SCApiContext* _legacyContext;
    
    StubRequestBuilder* _requestBuilderStub;
}

-(void)setUp
{
    [ super setUp ];

    self->_legacyContext = [ SCApiContext contextWithHost: @"www.StubHost.net" ];
    self->_context = self->_legacyContext.extendedApiContext;
    self->_requestBuilderStub = [ StubRequestBuilder new ];
}

-(void)tearDown
{
    self->_legacyContext = nil;
    self->_context = nil;
    self->_requestBuilderStub = nil;
    
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
                                      levelRequestBuilder: self->_requestBuilderStub ],
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
                                     levelRequestBuilder: self->_requestBuilderStub ],
        @"unexpected assert"
    );
}

-(void)testAssigningCancelBlock_CancelsCurrentOperation
{
    SCItemsFileManager* fm =
    [ [ SCItemsFileManager alloc ] initWithApiContext: self->_context
                                  levelRequestBuilder: self->_requestBuilderStub ];
    
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

@end
