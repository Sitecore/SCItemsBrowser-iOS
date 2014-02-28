#import <XCTest/XCTest.h>

#import <MobileSDK-Private/SCItemRecord_Source.h>
#import <MobileSDK-Private/SCItem+PrivateMethods.h>

#import <SCItemsBrowser/SCItemsBrowser.h>
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>


@interface ItemListTextCellTest : XCTestCase
@end


@implementation ItemListTextCellTest
{
    SCExtendedApiSession* _context;
    SCApiSession        * _legacyContext;
    
    SCItemRecord*  _rootItemRecord;
    SCItem* _rootItemStub;
    SCItemSourcePOD* _recordSource;
    
    SCItemListTextCell* _cell;
}

-(void)setUp
{
    self->_legacyContext = [ SCApiSession contextWithHost: @"www.StubHost.net" ];
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
        self->_rootItemRecord.apiSession= self->_context;
        self->_rootItemRecord.mainApiContext = self->_legacyContext;
        
        self->_rootItemRecord.path = @"/sitecore/content/home";
        self->_rootItemRecord.itemId = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}";
        self->_rootItemRecord.displayName = @"home";
        
        [ self->_rootItemRecord setItemSource: self->_recordSource ];
    }
    self->_rootItemStub = [ [ SCItem alloc ] initWithRecord: self->_rootItemRecord
                                                 apiContext: self->_context ];
    
    
    self->_cell = [ [ SCItemListTextCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                               reuseIdentifier: @"mock id" ];
}

-(void)tearDown
{
    self->_legacyContext  = nil;
    self->_context        = nil;
    
    self->_rootItemStub   = nil;
    self->_rootItemRecord = nil;
    
    self->_recordSource = nil;
    self->_cell = nil;
    
    [ super tearDown ];
}

// @adk : mocking UIKit is not worth the effort
-(void)__testSetModelWritesDisplayNameToCellLabel
{
    [ self->_cell setModel: self->_rootItemStub ];
    XCTAssertEqualObjects( self->_cell.textLabel.text, self->_rootItemStub.displayName, @"display name not set" );
}

@end
