#import "StubRequestBuilder.h"

@implementation StubRequestBuilder

-(SCItemsReaderRequest*)levelDownRequestForItem:( SCItem* )item
{
    return self.requestStub;
}

@end
