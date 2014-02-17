#import <XCTest/XCTest.h>

#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItem+Media.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

#import <MobileSDK-Private/SCItemRecord_Source.h>
#import <MobileSDK-Private/SCItem+PrivateMethods.h>


@interface ItemsBrowserTest : XCTestCase
@end

@implementation ItemsBrowserTest
{
    SCExtendedApiContext* _context      ;
    SCApiContext        * _legacyContext;
    
    SCItemSourcePOD     * _recordSource ;
    
    SCItem              * _rootItem     ;
    SCItemRecord        * _rootRecord   ;
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
}

-(void)tearDown
{
    self->_rootItem                   = nil;
    self->_rootRecord                 = nil;

    self->_context                    = nil;
    self->_legacyContext              = nil;
    self->_recordSource               = nil;
    
    [super tearDown];
}

-(void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
