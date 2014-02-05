#import <XCTest/XCTest.h>

#import "SCItemsFileManager.h"

@interface ItemsFileManagerTest : XCTestCase
@end

@implementation ItemsFileManagerTest

-(void)setUp
{
    [ super setUp ];
    // Put setup code here; it will be run once, before the first test case.
}

-(void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [ super tearDown ];
}

-(void)testFileManagerRejectsInit
{
    XCTAssertThrows( [ SCItemsFileManager new ], @"assert expected" );
}

@end
