#import <XCTest/XCTest.h>


#import "SCItemsFileManager.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>
#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItemsFileManager+UnitTest.h"
#import "SCItem+PrivateMethods.h"

#import "ItemsBrowserTestStubs.h"



@interface ItemsFileManagerHistoryTest : XCTestCase
@end

@implementation ItemsFileManagerHistoryTest
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

-(void)testLevelIsStoredAfterSuccessfullFetch
{

}

@end
