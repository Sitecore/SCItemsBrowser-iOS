#import <XCTest/XCTest.h>

#import "SCLevelUpItem.h"
#import "SCLevelResponse.h"
#import "SCLevelInfoPOD.h"

#import <MobileSDK-Private/SCItem+PrivateMethods.h>

@interface HelperStructuresTest : XCTestCase
@end

@implementation HelperStructuresTest

-(void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

-(void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

-(void)testLevelResponseRejectsInit
{
    XCTAssertThrows
    (
        [ SCLevelResponse new ],
        @"assert expected"
    );
}

-(void)testLevelResponseHoldsParentAndContentItems
{
    SCItem* mockRootItem = [ [ SCItem alloc ] initWithRecord: nil
                                                  apiSession: nil ];
    
    SCLevelUpItem* levelUp = [ SCLevelUpItem new ];
    SCItem* mockFirst = [ [ SCItem alloc ] initWithRecord: nil
                                                  apiSession: nil ];
    SCItem* mockSecond = [ [ SCItem alloc ] initWithRecord: nil
                                               apiSession: nil ];
    
    NSArray* levelContent = @[ levelUp, mockFirst, mockSecond ];
    
    SCLevelResponse* response = [ [ SCLevelResponse alloc ] initWithItem: mockRootItem
                                                       levelContentItems: levelContent ];

    XCTAssertTrue( response.levelParentItem == mockRootItem, @"root item mismatch" );
    XCTAssertTrue( response.levelContentItems == levelContent, @"level content mismatch" );
}


-(void)testLevelInfoRejectsInit
{
    XCTAssertThrows
    (
     [ SCLevelInfoPOD new ],
     @"assert expected"
     );
}

@end
