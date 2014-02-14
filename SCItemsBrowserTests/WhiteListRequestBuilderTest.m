#import <XCTest/XCTest.h>

#import "SIBWhiteListTemplateRequestBuilder.h"

@interface WhiteListRequestBuilderTest : XCTestCase
@end

@implementation WhiteListRequestBuilderTest

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

@end
