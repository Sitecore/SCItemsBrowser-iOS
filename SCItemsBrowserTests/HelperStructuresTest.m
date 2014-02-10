#import <XCTest/XCTest.h>

#import "SCLevelResponse.h"
#import "SCLevelInfoPOD.h"


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

-(void)testLevelInfoRejectsInit
{
    XCTAssertThrows
    (
     [ SCLevelInfoPOD new ],
     @"assert expected"
     );
}

@end
